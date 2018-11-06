require 'reporting'

namespace :scheduler do
  include Rake::DSL

  task :yearly => [:schedule_old_term_purge]

  desc "Marks all sections for deletion in terms that are older than 3 years"
  task :schedule_old_term_purge => :environment do
    include Reporting
    if Time.now.month == 1 && Time.now.day == 10
      @subject = "Terms Marked for Deletion"
      @report = {}
      deleted_terms = Section.terms_to_delete.each { |term| puts "#{term}"}.join("<br>")
      Section.mark_for_deletion
      report_action("Yearly Term Purge", "Terms Marked for Deletion", "<br />All sections from these terms will be removed from the system in 30 days." )
      report_action("Yearly Term Purge", "Terms Marked for Deletion", deleted_terms )
      send_report if @report.present?
    end
  end

  desc "This task is called by the Heroku scheduler add-on"
  task :purge_deleted => :environment do
    puts "Deleting marked sections..."
    Section.delete_marked
    puts "done."
  end
end
