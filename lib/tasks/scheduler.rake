namespace :scheduler do
  include Rake::DSL

  task :yearly => [:schedule_old_term_purge]

  desc "Marks all sections for deletion in terms that are older than 3 years"
  task :schedule_old_term_purge => :environment do
    scheduler_report = ReportAction::Report.new
    subject = "Terms Marked for Deletion"
    #if Time.now.month == 1 && Time.now.day == 10
      to_delete = Section.terms_to_delete
      deleted_terms = Section.terms_to_delete.each { |term| term.to_s }.join("<br>")
      Section.mark_for_deletion
      scheduler_report.report_item("Yearly Term Purge", "Terms Marked for Deletion", "All sections from these terms will be removed from the system in 30 days.")
      if to_delete.empty?
        scheduler_report.report_item("Yearly Term Purge", "Terms Marked for Deletion", "There were no terms marked for deletion this year.")
      else
        scheduler_report.report_item("Yearly Term Purge", "Terms Marked for Deletion", deleted_terms)
      end
      email = scheduler_report.build_report('Yearly Term Purge')
      CommentsMailer.generic(email.html_safe, subject, ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver! if scheduler_report.has_messages?("Yearly Term Purge", "Terms Marked for Deletion")
    #end
  end

  desc "This task is called by the Heroku scheduler add-on"
  task :purge_deleted => :environment do
    puts "Deleting marked sections..."
    Section.delete_marked
    puts "done."
  end
end
