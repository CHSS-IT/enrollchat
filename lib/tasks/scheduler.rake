namespace :scheduler do
  include Rake::DSL
  include ReportAction

  task :yearly => [:schedule_old_term_purge]

  desc "Marks all sections for deletion in terms that are older than 3 years"
  task :schedule_old_term_purge => :environment do
    initialize_report_action
    subject = "Terms Marked for Deletion"
    if Time.now.month == 1 && Time.now.day == 10
      to_delete = Section.terms_to_delete
      deleted_terms = Section.terms_to_delete.each { |term| puts term.to_s }.join("<br>")
      Section.mark_for_deletion
      report_item("Yearly Term Purge", "Terms Marked for Deletion", "<br />All sections from these terms will be removed from the system in 30 days.")
      if to_delete.empty?
        report_item("Yearly Term Purge", "Terms Marked for Deletion", "There were no terms marked for deletion this year.")
      else
        report_item("Yearly Term Purge", "Terms Marked for Deletion", deleted_terms)
      end
      build_report('Yearly Term Purge')
      CommentsMailer.generic(@report_body.html_safe, subject, ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver!
    end
  end

  desc "This task is called by the Heroku scheduler add-on"
  task :purge_deleted => :environment do
    puts "Deleting marked sections..."
    Section.delete_marked
    puts "done."
  end
end
