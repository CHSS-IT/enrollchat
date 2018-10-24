class Section < ApplicationRecord
  require 'roo'

  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :enrollments, -> { order(:created_at) }, dependent: :destroy

  default_scope { where("delete_at is null") }

  scope :by_department, -> { order(:department) }
  scope :by_section_and_number, -> { order(:course_description, :section_number) }
  scope :canceled, -> { where(status: 'C') }
  scope :not_canceled, -> { where("status <> 'C'") }
  scope :in_term, ->(term) { where(term: term) }
  scope :in_department, ->(department) { where(department: department) }
  scope :in_status, ->(status) { where(status: status) }
  scope :full_or_over_enrolled, -> { not_canceled.where('actual_enrollment >= enrollment_limit') }
  scope :full, -> { not_canceled.where('actual_enrollment = enrollment_limit') }
  scope :over_enrolled, -> { not_canceled.where('actual_enrollment > enrollment_limit') }
  scope :under_enrolled, -> { not_canceled.where('actual_enrollment < enrollment_limit') }
  scope :graduate_under_enrolled, -> { graduate_level.not_canceled.where('actual_enrollment < 10 and cross_list_enrollment < 10') }
  scope :undergraduate_under_enrolled, -> { undergraduate_level.not_canceled.where('actual_enrollment < 15 and cross_list_enrollment < 15') }
  scope :graduate_level, -> { where("level like 'UG%'") }
  scope :undergraduate_level, -> { where("level like 'UU%'") }
  scope :with_status, -> { where("status is not null and status <> ' '") }

  scope :marked_for_deletion, -> { unscoped.where("delete_at is not null") }
  scope :delete_now, -> { unscoped.where("delete_at is not null AND delete_at < ?", DateTime.now()) }

  def most_recent_comment_date
    comments.first.created_at unless comments.empty?
  end

  # def current_enrollment_limit
  #   enrollments.present? ? enrollments.last.enrollment_limit : 0
  # end
  #
  # def current_actual_enrollment
  #   enrollments.present? ? enrollments.last.actual_enrollment : 0
  # end
  #
  # def current_cross_list_enrollment
  #   enrollments.present? ? enrollments.last.cross_list_enrollment : 0
  # end
  #
  # def current_waitlist
  #   enrollments.present? ? enrollments.last.waitlist : 0
  # end

  def history_dates
    enrollments.collect { |e| e.created_at }.to_a
  end

  def history_date_strings
    history_dates.map { |d| d.strftime('%b %e') }
  end

  def enrollment_limit_history
    enrollments.collect { |e| e.enrollment_limit }
  end

  def actual_enrollment_history
    enrollments.map { |e| e.actual_enrollment }
  end

  def cross_list_enrollment_history
    enrollments.collect { |e| e.cross_list_enrollment }
  end

  def waitlist_history
    enrollments.collect { |e| e.waitlist }
  end

  def section_number_zeroed
    section_number.to_s.rjust(3, "0")
  end

  def section_and_number
    "#{course_description}-#{section_number_zeroed}"
  end

  def self.department_list
    self.pluck(:department).uniq.sort
  end

  def self.delete_marked
    self.delete_now.destroy_all
  end

  def self.departments
    all.collect { |s| s.department }.uniq
  end

  def self.status_list
    list = self.with_status.map { |s| s.status }
    list << 'ALL'
    list << 'ACTIVE'
    list.sort.uniq
  end

  def self.level_list
    [['Undergraduate - Lower Division','uul'],['Undergraduate - Upper Division','uuu'],['Graduate - First','ugf'],['Graduate - Advanced','uga']]
  end

  def self.level_name_list
    self.level_list.collect { |l| l[0] }
  end

  def self.level_code_list
    self.level_list.collect { |l| l[1] }
  end

  self.level_code_list.each do |level|
    scope level.downcase.to_sym, -> { where(level: level.upcase) }
  end

  def self.enrollment_status_list
    ['Undergraduate under-enrolled','Undergraduate over-enrolled','Graduate under-enrolled','Graduate over-enrolled']
  end

  def self.import(filepath)
    # Grab most recent update time
    last_touched_at = Section.maximum(:updated_at)
    # Open file using Roo.
    file = File.open(filepath)
    spreadsheet = Roo::Spreadsheet.open(file, extension: '.csv')

    # spreadsheet = Roo::Spreadsheet.open(open(imported_file.file_url), extension: File.extname(imported_file.file_url).gsub('.','').to_sym) rescue nil

    # Left over from having to process spreadsheets with embedded text we had to ignore. Left in place as a possible future configurable setting.
    last_real_row = spreadsheet.last_row
    first_row = 2

    # Use local names instead of names from file header
    header = %w[section_id term department cross_list_group course_description section_number title credits level status enrollment_limit actual_enrollment cross_list_enrollment waitlist]
    # Parse spreadsheet.
    @updated_sections = 0
    (first_row..last_real_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["term"].blank? || row["term"].to_i.to_s != row["term"]
        # Hack to avoid blanks and headers when dealing with generated csv or xslt with dislaimer rows
        puts "Row fails reality check:"
      else
        section = Section.find_or_initialize_by(term: row["term"], section_id: row["section_id"])
        section.attributes = row.to_hash.slice(*header)
        if section.cross_list_enrollment.nil?
          section.cross_list_enrollment = 0
          section.cross_list_enrollment_yesterday = 0
        end

        section.track_differences
        section.save! if section.new_record?
        section.enrollments.create(department: section.department, term: section.term, enrollment_limit: section.enrollment_limit, actual_enrollment: section.actual_enrollment, cross_list_enrollment: section.cross_list_enrollment, waitlist: section.waitlist)

        report_action('New Sections', section.section_and_number) if section.new_record?

        # TODO: do we have a flag for cancellation?
        if section.status == 'C'
          if section.status_changed? || section.canceled_at.blank?
            section.canceled_at = DateTime.now()
            report_action('Canceled Sections', section.section_and_number)
          end
        end

        # Save if changed, touch if unchanged
        if section.changed? || section.enrollments.last.new_record?
          section.save!
          @updated_sections += 1
        else
          unless section.new_record?
            section.updated_at <= 1.day.ago ? section.reset_yesterday : section.touch
          end
        end
      end
    end

    # Used last_touched_at to determine which terms were updated
    touched = Section.where('updated_at > ?', last_touched_at)
    created = Section.where('created_at > ?', last_touched_at)
    @touched_sections = touched.size - created.size
    @new_sections = created.size
    if touched.size > 0
      report_action('Updated Sections', "<a href='/sections' class='dropdown-item'>#{@updated_sections} sections were updated during the import process. #{@new_sections} sections were created.</a>")
    else
      report_action('Updated Sections', "<a href='/sections' class='dropdown-item'>The import file was empty.</a>")
    end
    # From those, gather the terms
    touched_terms = touched.collect { |t| t.term }.uniq
    # Then find any untouched sections from those terms
    untouched = Section.where('updated_at <= ? and term in (?)', last_touched_at, touched_terms)
    if untouched.size > 0
      report_action('Updated Sections', "<a href='/sections' class='dropdown-item'>#{untouched.size} sections from terms contained in feed were not touched by import. It is possible that these were cancelled.</a>")
    else
      report_action('Updated Sections', "<a href='/sections' class='dropdown-item'>All sections were touched by the import process.</a>")
    end
    # puts @report
    ActionCable.server.broadcast 'room_channel',
                                 message:  "<a href='/sections' class='dropdown-item'>Registration data import complete. #{@new_sections} added. #{@updated_sections} updated. Refreshing browser to show changes.</a>",
                                 trigger: 'Updated'
  end

  def self.report_action(subject, message)
    @report ||= {}
    @report[subject] ||= []
    @report[subject] << message
  end

  def graduate?
    level[0..7] == 'Graduate'
  end

  def undergraduate?
    level[0..12] == 'Undergraduate'
  end

  def flagged_as
    # It would be nice to add highlights to low enrolled courses.  The rules for this are a bit complicated.  An undergraduate course would get a highlight if its actual enrolled were under 15 and its crosslist enrolled were also under 15 (e.g. a course with 7 actual enrolled and 16 crosslist enrolled should not be highlighted).  A graduate course would be highlighted if its actual enrolled were under 10 and its cross list enrolled were under 10.  One more wrinkle, that we could ignore.  An undergraduate course should be treated as if it were a graduate course viz. these minimums if it is linked to a grad course with a cross list code.  Again, this last rule could be disregarded if that kind of check is hard to program and/or would slow down the program considerably. (The logic here is that if a course is cross listed as a grad/undergrad course, I have given the benefit of the doubt at treated it as a grad course with the min. enrollment at 10--probably an overly generous policy.)
    # The might also be a different highlight color for any course with a WL above 5.

    if status == 'C'
      "canceled"
    elsif waitlist > 5
      "long-waitlist"
    elsif graduate? # or state for undergraduate cross-listed with grad if possible
      if (actual_enrollment < 10 && cross_list_enrollment < 10) && actual_enrollment < enrollment_limit
        "under-enrolled"
      end
    elsif (actual_enrollment < 15 && cross_list_enrollment < 15) && actual_enrollment < enrollment_limit
      "under-enrolled"
    end
  end

  def self.flagged_as_list
    %w[long-waitlist under-enrolled]
  end

  def self.flagged_as?(flag)
    all.select { |section| section.flagged_as == flag }
  end

  def show_yesterday(field)
    self.send("#{field}_yesterday")
  end

  def reset_yesterday
    self.update(enrollment_limit_yesterday: 0, actual_enrollment_yesterday: 0, cross_list_enrollment_yesterday: 0, waitlist_yesterday: 0)
  end

  def track_differences
    # Dry it up
    # Differences since last file upload
    #
    self.enrollment_limit_yesterday = (self.new_record? || self.enrollment_limit_was.nil?) ? 0 : enrollment_limit_changed? ? enrollment_limit - enrollment_limit_was : 0
    self.actual_enrollment_yesterday = (self.new_record? || self.actual_enrollment_was.nil?) ? 0 : actual_enrollment_changed? ? actual_enrollment - actual_enrollment_was : 0
    self.cross_list_enrollment_yesterday = cross_list_enrollment_was.nil? ? 0 : cross_list_enrollment_changed? ? cross_list_enrollment - cross_list_enrollment_was : 0
    self.waitlist_yesterday = (self.new_record? || self.waitlist_was.nil?) ? 0 : waitlist_changed? ? waitlist - waitlist_was : 0
  end
end
