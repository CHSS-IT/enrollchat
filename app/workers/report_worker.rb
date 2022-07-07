class ReportWorker
  include Sidekiq::Worker
  include ActionView::Helpers::TagHelper
  include Rails.application.routes.url_helpers
  include ActionView::Context
  include ApplicationHelper
  sidekiq_options retry: false

  def initialize
    @report = ReportAction::Report.new
    @recipients = User.wanting_report
    @report_term = Setting.first.current_term
  end

  def perform
    build_comment_report
    build_summary_report
    identify_and_send unless @recipients.empty?
    report_complete
  end

  def build_comment_report
    host = Rails.env.test? ? 'localhost' : ENV.fetch('ENROLLCHAT_HOST', nil)
    Section.department_list.each do |department|
      comments = Comment.in_past_week.for_department(department).by_course
      if comments.present?
        # Add to list of departments
        @report.report_item('departments', 'list', department)

        # build email contents
        text = "<h3>#{department}</h3>"

        comments.group_by(&:section).sort.each do |section, c|
          text += "<p>#{ActionController::Base.helpers.link_to section.section_and_number, section_url(section, host: host)}" + ": #{c.size} comment#{'s' if c.size > 1}</p>"
        end

        # Add to report for department
        @report.report_item('departments',department,text)

      end
    end
  end

  def build_summary_report
    Section.department_list.each do |department|
      sections = Section.in_term(@report_term).in_department(department)
      text = "Report for #{department} goes here.".html_safe
      # Add to report for department
      @report.report_item('summaries',department,text)
    end
  end

  def identify_and_send
    report_content = @report.retrieve_report_structure
    @recipients.each do |recipient|
      text = departments_with_comments(recipient).present? ? departments_with_comments(recipient).collect { |department| report_content['departments'][department] }.join.html_safe : ''
      send_report(recipient, text)
    end
  end

  def report_complete
    text = content_tag(:h1, "EnrollChat Weekly Report Sent") + content_tag(:p, "Reports sent to:")
    text += content_tag :ul do
      @recipients.collect { |user| content_tag :li, "#{user.full_name} (#{user.email})" }.join.html_safe
    end
    CommentsMailer.generic(text.html_safe, "EnrollChat Report Task Executed", ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)).deliver!
    # puts "Report ran fully."
  end

  def departments_with_comments(recipient)
    report_content = @report.retrieve_report_structure
    report_content['departments']['list'] & recipient.reporting_departments if report_content.key?('departments')
  end

  def send_report(recipient, text)
    report_content = @report.retrieve_report_structure
    CommentsMailer.report('EnrollChat Report',recipient, report_content, text, @report_term).deliver!
    @report.report_item('enrollchat','recipients',recipient.email)
  end
end
