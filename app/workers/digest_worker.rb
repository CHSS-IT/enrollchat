class DigestWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  sidekiq_options retry: false

  def initialize
    @report = ReportAction::Report.new
  end

  def perform
    # We're going to do this from department out
    # We'll build digests for each department that has comments
    # Then loop the users and send based on their preferences
    # Digest and both users get a single email with their digests
    # Digest and both people with no department get a single email with all digests
    # We'll send a report after this runs:
    # - Report ran
    # - Comments on [these] departments were sent to [count] users
    build_report
    identify_and_send if @report.has_messages?('departments', 'list')
    report_complete
  end

  def build_report
    host = Rails.env.test? ? 'localhost' : ENV.fetch('ENROLLCHAT_HOST', nil)
    Section.department_list.each do |department|
      comments = Comment.yesterday.for_department(department).by_course
      if comments.present?
        # puts "Comments on #{department} present"
        # Add to list of departments
        @report.report_item('departments', 'list', department)

        # build email contents
        subject = "EnrollChat Digest Email for #{department}"
        text = "<h2>#{subject} - #{basic_date(DateTime.yesterday)}</h2>"

        comments.group_by(&:section).sort.each do |section, c|
          text += "<p>#{ActionController::Base.helpers.link_to section.section_and_number, section_url(section, host: host)}" + ": #{c.size} comment#{'s' if c.size > 1}</p>"
        end

        # Add to report for department
        @report.report_item('departments',department,text)

      end
    end
  end

  def identify_and_send
    recipients = User.wanting_digest
    if recipients.present?
      recipients.each do |recipient|
        # puts "#{recipient.email} #{departments_with_comments(recipient).present?}"
        if departments_with_comments(recipient).present?
          send_digest(recipient)
        end
      end
    end
  end

  def report_complete
    report_content = @report.retrieve_report_structure
    text = ''
    text += '<h1>Departments With Comments</h1><p>' + report_content['departments']['list'].join(', ') + '</p>' if report_content['departments'].present?
    text += '<h1>Digests Sent to</h1><p>' + report_content['enrollchat']['recipients'].join(', ') + '</p>' if report_content['enrollchat'].present?
    text += '<p>No comment activity.</>' if report_content['departments'].present? && !report_content['enrollchat'].present?
    CommentsMailer.generic(text.html_safe, "EnrollChat Digest Task Executed", ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)).deliver!
    # puts "Report ran fully."
  end

  def departments_with_comments(recipient)
    report_content = @report.retrieve_report_structure
    report_content['departments']['list'] & (recipient.departments.present? ? recipient.departments : Section.department_list)
  end

  def send_digest(recipient)
    report_content = @report.retrieve_report_structure
    text = departments_with_comments(recipient).collect { |department| report_content['departments'][department] }.join.html_safe
    CommentsMailer.digest(text,'EnrollChat Comments Digest',recipient).deliver!
    @report.report_item('enrollchat','recipients',recipient.email)
  end
end
