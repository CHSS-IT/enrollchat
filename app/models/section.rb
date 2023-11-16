class Section < ApplicationRecord
  require 'roo'

  cattr_accessor :graduate_enrollment_threshold, default: Setting.first.graduate_enrollment_threshold
  cattr_accessor :undergraduate_enrollment_threshold, default: Setting.first.undergraduate_enrollment_threshold

  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :enrollments, -> { order(:created_at) }, dependent: :destroy

  default_scope { where("delete_at is null") }

  scope :by_department, -> { order(:department) }
  scope :by_section_and_number, -> { order(:course_description, :section_number) }
  scope :canceled, -> { where(status: 'C') }
  scope :not_canceled, -> { where("status <> 'C'") }
  scope :in_term, ->(term) { where(term:) }
  scope :upcoming, ->(term) { where('term >= ?', term) }
  scope :in_department, ->(department) { where(department:) }
  scope :in_status, ->(status) { where(status:) }
  scope :full_or_over_enrolled, -> { not_canceled.where('actual_enrollment >= enrollment_limit or waitlist > 5') }
  scope :all_waitlists, -> { not_canceled.where('waitlist > 0') }
  scope :full, -> { not_canceled.where('actual_enrollment = enrollment_limit') }
  scope :under_enrolled, -> { not_canceled.where('actual_enrollment < enrollment_limit and cross_list_enrollment < enrollment_limit') }
  scope :over_enrolled, -> { not_canceled.where('waitlist > 5') }
  scope :graduate_under_enrolled, -> { graduate_level.not_canceled.where('actual_enrollment < ? and cross_list_enrollment < ?', graduate_enrollment_threshold, graduate_enrollment_threshold) }
  scope :undergraduate_under_enrolled, -> { undergraduate_level.not_canceled.where('actual_enrollment < ? and cross_list_enrollment < ?', undergraduate_enrollment_threshold, undergraduate_enrollment_threshold) }
  scope :graduate_level, -> { where("lower(level) like 'ug%'") }
  scope :undergraduate_level, -> { where("lower(level) like 'uu%'") }
  scope :all_graduate, -> { where(level: ['UGF', 'UGA']) }
  scope :all_undergraduate, -> { where(level: ['UUL', 'UUU']) }
  scope :with_status, -> { where("status is not null and status <> ' '") }
  scope :in_level, ->(level) { where("lower(level) = ?", level.downcase) }

  scope :face_to_face, -> { where("modality like '_A_'") }
  scope :fully_remote, -> { where("modality like '_C_'") }
  scope :hybrid, -> { where.not("modality like '_C_'").where.not("modality like '_A_'").where.not(modality: [nil, '']) }

  scope :marked_for_deletion, -> { unscoped.where("delete_at is not null") }
  scope :delete_now, -> { unscoped.where("delete_at is not null AND delete_at < ?", DateTime.now()) }

  def most_recent_comment_date
    comments.first.created_at unless comments.empty?
  end

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

  def self.upcoming_terms(term)
    self.upcoming(term).pluck(:term).uniq
  end

  def course_code
    course_description.split[0]
  end

  def self.course_codes_in_term(term)
    sections = self.in_term(term)
    sections.collect { |section| section.course_code }.uniq.sort
  end

  def self.modality_list
    %w[face_to_face hybrid fully_remote]
    # [['Face to Face','face_to_face'],%w[Hybrid,hybrid],['Fully Remote','fully_remote']]
  end

  def self.level_list
    [['Undergraduate - Lower Division','uul'],['Undergraduate - Upper Division','uuu'],['Undergraduate - All', 'uuall'],['Graduate - First','ugf'],['Graduate - Advanced','uga'],['Graduate - All', 'ugall']]
  end

  def self.level_name_list
    self.level_list.pluck(0)
  end

  def self.level_code_list
    self.level_list.pluck(1)
  end

  def self.modality_list_with_labels
    self.modality_list.map { |l| [l.humanize,l] }
  end

  self.level_code_list.each do |level|
    scope level.downcase.to_sym, -> { where(level: level.upcase) }
  end

  def self.enrollment_status_list
    ['Undergraduate under-enrolled','Undergraduate over-enrolled','Graduate under-enrolled','Graduate over-enrolled']
  end

  def self.home_department_list
    %w[CULT COMM ENGL RELI MCL PSYC SINT CRIM HE SOAN GLOA HIST WMST PHIL ECON AFAM LA HNRS BIS MAIS MEIS]
  end

  def self.import(filepath)
    @import_report = ReportAction::Report.new

    # Grab most recent update time
    last_touched_at = Section.maximum(:updated_at)
    # Open file using Roo.
    file = URI.open(filepath)
    spreadsheet = Roo::Spreadsheet.open(file, extension: '.csv')

    # spreadsheet = Roo::Spreadsheet.open(open(imported_file.file_url), extension: File.extname(imported_file.file_url).gsub('.','').to_sym) rescue nil

    # Left over from having to process spreadsheets with embedded text we had to ignore. Left in place as a possible future configurable setting.
    last_real_row = spreadsheet.last_row
    first_row = 2

    # Use local names instead of names from file header
    header = %w[section_id term department cross_list_group course_description section_number title credits level status enrollment_limit actual_enrollment cross_list_enrollment waitlist modality modality_description print_flag]
    # Parse spreadsheet.
    @updated_sections = 0
    (first_row..last_real_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # Hack to avoid blanks and headers when dealing with generated csv or xslt with disclaimer rows
      if row["term"].blank? || row["term"].to_i.to_s != row["term"]
      # Temporarily exclude sections where the print_flag is set to no.
      # This is to limit disruptions when the enhanced data feed is first implemented.
      elsif row["print_flag"] == 'N'
        @import_report.report_item('Executing Import', 'Skipped Sections', "No Print Flag: #{row['department']} #{row['section_number']}")
      elsif row["section_number"].include?('SA')
        @import_report.report_item('Executing Import', 'Skipped Sections', "Study abroad #{row['section_number']}")
      elsif Section.home_department_list.include?(row["department"])
        section = Section.find_or_initialize_by(term: row["term"], section_id: row["section_id"])
        section.attributes = row.to_hash.slice(*header)
        if section.cross_list_enrollment.nil?
          section.cross_list_enrollment = 0
          section.cross_list_enrollment_yesterday = 0
        end

        section.track_differences
        section.save! if section.new_record?
        section.enrollments.create(department: section.department, term: section.term, enrollment_limit: section.enrollment_limit, actual_enrollment: section.actual_enrollment, cross_list_enrollment: section.cross_list_enrollment, waitlist: section.waitlist)

        @import_report.report_item('Executing Import', 'New Sections', section.section_and_number) if section.new_record?

        if section.status == 'C'
          if section.status_changed? || section.canceled_at.blank?
            section.canceled_at = DateTime.now()
            @import_report.report_item('Executing Import', 'Canceled Sections', "#{section.section_and_number} in #{section.term}")
          end
        end

        # Save if changed, touch if unchanged
        if section.changed? || section.enrollments.last.new_record?
          section.save!
          @updated_sections += 1
        else
          unless section.new_record?
            section.updated_at <= 1.day.ago ? (section.reset_yesterday && section.touch) : section.touch
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
      @import_report.report_item('Executing Import', 'Updated Sections', "<a href='/sections' class='dropdown-item'>#{@updated_sections} sections were updated during the import process. #{@new_sections} sections were created.</a>")
    else
      @import_report.report_item('Executing Import', 'Updated Sections', "<a href='/sections' class='dropdown-item'>The import file was empty.</a>")
    end
    # From those, gather the terms
    touched_terms = touched.collect { |t| t.term }.uniq
    # Then find any untouched sections from those terms
    untouched = Section.where('updated_at <= ? and term in (?)', last_touched_at, touched_terms)
    if untouched.size > 0
      untouched.not_canceled.each do |s|
        s.status = 'C'
        s.canceled_at = DateTime.now()
        s.save!
        @import_report.report_item('Executing Import', 'Canceled Sections', "(ID: #{s.id}) #{s.section_and_number} in #{s.term} was not touched by import and has been canceled.")
      end
      @import_report.report_item('Executing Import', 'Updated Sections', "<a href='/sections' class='dropdown-item'>#{untouched.size} sections from terms contained in feed were not touched by import. It is possible that these were cancelled.</a>")
    else
      @import_report.report_item('Executing Import', 'Updated Sections', "<a href='/sections' class='dropdown-item'>All sections were touched by the import process.</a>")
    end
    Turbo::StreamsChannel.broadcast_update_later_to("new_data_notification", target: "new-data-available", partial: "sections/new_data_message", locals: { new_sections: @new_sections, updated_sections: @updated_sections })
    send_report if @import_report.has_messages?('Executing Import', 'Updated Sections')
  end

  def self.send_report
    subject = "Import Processed"
    email = @import_report.build_report('Executing Import')
    CommentsMailer.generic(email.html_safe, subject, ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)).deliver!
  end

  def graduate?
    level[0..1].downcase == 'ug'
  end

  def undergraduate?
    level[0..12].downcase == 'uu'
  end

  def instructor_names
    [instructor_name, second_instructor_name].compact.join(' and ')
  end

  def flagged_as
    # It would be nice to add highlights to low enrolled courses.  The rules for this are a bit complicated.  An undergraduate course would get a highlight if its actual enrolled were under 15 and its crosslist enrolled were also under 15 (e.g. a course with 7 actual enrolled and 16 crosslist enrolled should not be highlighted).  A graduate course would be highlighted if its actual enrolled were under 10 and its cross list enrolled were under 10.  One more wrinkle, that we could ignore.  An undergraduate course should be treated as if it were a graduate course viz. these minimums if it is linked to a grad course with a cross list code.  Again, this last rule could be disregarded if that kind of check is hard to program and/or would slow down the program considerably. (The logic here is that if a course is cross listed as a grad/undergrad course, I have given the benefit of the doubt at treated it as a grad course with the min. enrollment at 10--probably an overly generous policy.)
    # The might also be a different highlight color for any course with a WL above 5.

    if status == 'C'
      "canceled"
    elsif waitlist > 5
      "long-waitlist"
    elsif graduate? # or state for undergraduate cross-listed with grad if possible
      if (actual_enrollment < graduate_enrollment_threshold && cross_list_enrollment < graduate_enrollment_threshold) && actual_enrollment < enrollment_limit
        "under-enrolled"
      end
    elsif (actual_enrollment < undergraduate_enrollment_threshold && cross_list_enrollment < undergraduate_enrollment_threshold) && actual_enrollment < enrollment_limit
      "under-enrolled"
    end
  end

  def self.flagged_as_list
    %w[waitlisted long-waitlist under-enrolled]
  end

  def self.flagged_as?(flag)
    select { |section| section.flagged_as == flag }
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

  def title_changed?
    title != chssweb_title if chssweb_title.present?
  end

  def self.terms
    all.collect { |s| s.term }.uniq
  end

  def self.terms_to_delete
    terms.select { |t| t.to_s[0..3].to_i < Time.now.year - 3 }.sort
  end

  def self.mark_for_deletion
    self.terms_to_delete.each do |term|
      Section.in_term(term).update_all(delete_at: Time.now.next_month)
    end
  end

  def formatted_time(time)
    time&.to_datetime&.strftime("%-I:%M%p")
  end

  def campus_label
    case campus_code
    when ENV.fetch('CAMPUS_CODE_ONE', nil)
      ENV.fetch('CAMPUS_LABEL_ONE', nil)
    when ENV.fetch('CAMPUS_CODE_TWO', nil)
      ENV.fetch('CAMPUS_LABEL_TWO', nil)
    when ENV.fetch('CAMPUS_CODE_THREE', nil)
      ENV.fetch('CAMPUS_LABEL_THREE', nil)
    when ENV.fetch('CAMPUS_CODE_FOUR', nil)
      ENV.fetch('CAMPUS_LABEL_FOUR', nil)
    when ENV.fetch('CAMPUS_CODE_FIVE', nil)
      ENV.fetch('CAMPUS_LABEL_FIVE', nil)
    when ENV.fetch('CAMPUS_CODE_SIX', nil), ENV.fetch('CAMPUS_CODE_TEN', nil)
      ENV.fetch('CAMPUS_LABEL_SIX', nil)
    when ENV.fetch('CAMPUS_CODE_SEVEN', nil), ENV.fetch('CAMPUS_CODE_ELEVEN', nil)
      ENV.fetch('CAMPUS_LABEL_SEVEN', nil)
    when ENV.fetch('CAMPUS_CODE_EIGHT', nil)
      ENV.fetch('CAMPUS_LABEL_EIGHT', nil)
    when ENV.fetch('CAMPUS_CODE_NINE', nil)
      ENV.fetch('CAMPUS_LABEL_NINE', nil)
    else
      campus_code
    end
  end
end
