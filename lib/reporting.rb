module Reporting
  def send_report
    email = ''
    subject = @subject ||= "Email from Enrollchat"
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

  def report_action(target, group, message)
    @report[target] ||= {}
    @report[target][group] ||= []
    @report[target][group] << message
  end
end
