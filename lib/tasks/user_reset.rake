namespace :user_reset do
  desc 'Resets the active_session attribute to false. Protects user stat integretity by covering edge case where a user might logout by non-standard means - deleting cookie, appending /logout to url'
  include Rake::DSL

  task :active_session => :environment do
    closed_session_report = ReportAction::Report.new
    subject = "EnrollChat User Active Sessions Closed"
    closed_session_report.report_item('User Active Sessions', 'Closed Sessions', 'The Active Session attribute for these users has been reset to false.')
    closed_count = 0
    users = User.all
    users.each do |user|
      if user.active_session == true
        user.active_session = false
        user.save!(touch: false)
        closed_count += 1
        closed_session_report.report_item('User Active Sessions', 'Closed Sessions', user.username)
      end
    end
    if closed_count > 0
      email = closed_session_report.build_report('User Active Sessions')
      CommentsMailer.generic(email.html_safe, subject, ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)).deliver! if closed_session_report.has_messages?('User Active Sessions', 'Closed Sessions')
    end
  end
end
