class Section < ApplicationRecord
  require 'roo'

  has_many :comments, dependent: :destroy

  default_scope  { where("delete_at is null") }

  scope :canceled, -> { where(status: 'C') }
  scope :not_canceled, -> { where("status <> 'C'") }
  scope :by_term, ->(term) { where(term: term) }
  scope :by_department, ->(department) { where(department: department) }
  scope :by_status, ->(status) { where(status: status) }
  scope :full_or_over_enrolled, -> { where('actual_enrollment >= enrollment_limit') }
  scope :full, -> { where('actual_enrollment = enrollment_limit') }
  scope :over_enrolled, -> { where('actual_enrollment > enrollment_limit') }
  scope :under_enrolled, -> { where('actual_enrollment < enrollment_limit') }
  scope :graduate_under_enrolled, -> { where('actual_enrollment < 10 and cross_list_enrollment < 10') }
  scope :undergraduate_under_enrolled, -> { where('actual_enrollment < 15 and cross_list_enrollment < 15')}
  scope :graduate_level, -> { where("level = 'Graduate - First' or level = 'Graduate - Advanced'") }
  scope :undergraduate_level, -> { where("level = 'Undergraduate - Upper Division' or level = 'Undergraduate - Lower Division'") }
  scope :with_status, -> { where("status is not null and status <> ' '") }

  scope :marked_for_deletion, -> { unscoped.where("delete_at is not null") }
  scope :delete_now, -> { unscoped.where("delete_at is not null AND delete_at < ?", DateTime.now()) }

  def section_number_zeroed
    section_number.to_s.rjust(3, "0")
  end

  def section_and_number
    "#{course_description}-#{section_number_zeroed}"
  end

  def self.department_list
     self.all.map{|s| s.department}.sort.uniq
  end

  def self.delete_marked
    self.delete_now.destroy_all
  end

  def self.status_list
    list = self.with_status.map{|s| s.status}
    # adds an option to list all sections that aren't canceled.
    list << 'ACTIVE'
    list.sort.uniq
  end

  def self.level_list
    ['Graduate', 'Undergraduate']
  end

  def self.enrollment_status_list
    ['Graduate under-enrolled','Undergraudate under-enrolled', 'All over-enrolled']
  end

  def self.import(filepath)
    # Grab most recent update time
    last_touched_at = Section.maximum(:updated_at)
    puts filepath
    # Open file using Roo.
    spreadsheet = Roo::Spreadsheet.open(filepath)
    if filepath.to_s.include?('.xlsx')
      last_real_row = spreadsheet.last_row - 2
      first_row = 4
    elsif filepath.to_s.include?('.csv')
      last_real_row = spreadsheet.last_row
      first_row = 4
      # puts spreadsheet.inspect
    end
    # Use local names instead of names from file header
    header = %w[section_id term department cross_list_group course_description section_number title credits level status enrollment_limit actual_enrollment cross_list_enrollment waitlist]
    # Parse spreadsheet.
    @updated_sections = 0
    # We will skip the first three rows (non-spreadsheet message and headers) and the last two (blank line and disclaimer).
    (first_row..last_real_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["term"].blank? or row["term"].to_i.to_s != row["term"]
        # Hack to avoid blanks and headers when dealing with generated csv or xslt with dislaimer rows
        puts "Skipping this row:"
      else
        section = Section.find_or_initialize_by(term: row["term"], section_id: row["section_id"])
        section.attributes = row.to_hash.slice(*header)

        #bulletproof numericals; this should be in the model
        section.enrollment_limit = 0 if section.enrollment_limit.nil?
        section.actual_enrollment = 0 if section.actual_enrollment.nil?
        section.cross_list_enrollment = 0 if section.cross_list_enrollment.nil?
        section.waitlist = 0 if section.waitlist.nil?

        report_action('New Sections', section.section_and_number) if section.new_record?

        # TODO: do we have a flag for cancellation?
        if section.status == 'C'
          if section.status_changed? || section.canceled_at.blank?
            puts "NEW CANCEL! - #{section.status_changed?} - #{section.canceled_at.blank?}"
            section.canceled_at = DateTime.now()
            report_action('Canceled Sections', section.section_and_number)
          end
        end

        # Save if changed, touch if unchanged
        if section.changed?
          section.save!
          @updated_sections += 1
        else
          (section.touch unless section.new_record?)
        end
      end
      puts row
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
    touched_terms = touched.collect { |touched| touched.term }.uniq
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
    @report ||= Hash.new
    @report[subject] ||= []
    @report[subject] << message
    puts message
  end

  def graduate?
    level[0..7] == 'Graduate'
  end

  def undergraduate?
    level[0..12] == 'Undergraduate'
  end

  def flagged_as
    # It would be nice to add highlights to low enrolled courses.  The rules for this are a bit complicated.  An undergraduate course would get a highlight if its actual enrolled were under 15 and its crosslist enrolled were also under 15 (e.g. a course with 7 actual enrolled and 16 crosslist enrolled should not be highlighted).  A graduate course would be highlighted if its actual enrolled were under 10 and its cross list enrolled were under 10.  One more wrinkle, that we could ignore.  An undergraduate course should be treated as if it were a graduate course viz. these minimums if it is linked to a grad course with a cross list code.  Again, this last rule could be disregarded if that kind of check is hard to program and/or would slow down the program considerably. (The logic here is that if a course is cross listed as a grad/undergrad course, I’ve given the benefit of the doubt at treated it as a grad course with the min. enrollment at 10--probably an overly generous policy.)
    # The might also be a different highlight color for any course with a WL above 5.

    if status == 'C'
      "canceled"
    elsif waitlist > 5
      "waitlisted"
    elsif graduate? # or state for undergraduate cross-listed with grad if possible
      if actual_enrollment < 10 and cross_list_enrollment < 10
        "under-enrolled"
      end
    elsif actual_enrollment < 15 and cross_list_enrollment < 15
      "under-enrolled"
    end
  end

end
