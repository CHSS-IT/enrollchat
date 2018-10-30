namespace :scheduler do
  include Rake::DSL

  task :yearly => [:schedule_old_term_purge]

  desc "Marks all sections for deletion in terms that are older than 3 years"
  task :schedule_old_term_purge => :environment do
    #if Time.now.month == 1 && Time.now.day == 10
      @report = {}
      deleted_terms = Section.terms_to_delete.each { |term| puts "#{term}"}.join("<br>")
      Section.mark_for_deletion
      report_action("Yearly Term Purge", "Terms Marked for Deletion", "<br />All sections from these terms will be removed from the system in 30 days." )
      report_action("Yearly Term Purge", "Terms Marked for Deletion", deleted_terms )
      send_report if @report.present?
    #end
  end

  desc "This task is called by the Heroku scheduler add-on"
  task :purge_deleted => :environment do
    puts "Deleting marked sections..."
    Section.delete_marked
    puts "done."
  end

  def send_report
    email = ''
    subject = "Terms Marked for Deletion"
    subject += " (TRIGGERED IN #{Rails.env})" if Rails.env != 'production'
    @report.each do |target,groups|
      groups.each do |group,messages|
        email = email + "<h1>#{group.capitalize}</h1>"
        messages.uniq.sort.each do |message|
          email = email + message + '<br />'
        end
      end
    end
    CommentsMailer.generic(email.html_safe, subject, ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver!
  end

  # TODO: Code smell. Gemify reporting process.
  def report_action(target, group, message)
    @report[target] ||= {}
    @report[target][group] ||= []
    @report[target][group] << message
  end
end
