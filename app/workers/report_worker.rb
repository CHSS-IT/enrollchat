class ReportWorker
  include Sidekiq::Worker
  include ActionView::Helpers::TagHelper
  include Rails.application.routes.url_helpers
  include ActionView::Context
  include ApplicationHelper
  sidekiq_options retry: false

  def initialize
    @report = Hash.new
    @recipients = User.wanting_report
  end

  def perform
    build_comment_report
    build_summary_report
    identify_and_send unless @recipients.empty?
    report_complete
  end

  def build_comment_report
    Section.department_list.each do |department|
      comments = Comment.in_past_week.for_department(department).by_course
      if comments.present?
        # Add to list of departments
        report_action('departments', 'list', department)

        # build email contents
        text = "<h3>#{department}</h3>"

        comments.group_by(&:section).sort.each do |section, c|
          text += "<p>#{ActionController::Base.helpers.link_to section.section_and_number, section_url(section, host: ENV['ENROLLCHAT_HOST'])}" + ": #{c.size} comment#{'s' if c.size > 1}</p>"
        end

        # Add to report for department
        report_action('departments',department,text)

      end
    end
  end

  def build_summary_report
    Section.department_list.each do |department|
      sections = Section.in_term(@term).in_department(department)
      text = "Report for #{department} goes here.".html_safe
      # Add to report for department
      report_action('summaries',department,text)
    end
  end

  def identify_and_send
    @recipients.each do |recipient|
      text = departments_with_comments(recipient).present? ? departments_with_comments(recipient).collect { |department| @report['departments'][department] }.join.html_safe : ''
      send_report(recipient, text)
    end
  end

  def report_complete
    text = content_tag(:h1, "EnrollChat Weekly Report Sent") + content_tag(:p, "Reports sent to:")
    text += content_tag :ul do
      @recipients.collect { |user| content_tag :li, "#{user.full_name} (#{user.email})" }.join.html_safe
    end
    CommentsMailer.generic(text.html_safe, "EnrollChat Report Task Executed", ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver!
    puts "Report ran fully."
  end

  def departments_with_comments(recipient)
    @report['departments']['list'] & recipient.reporting_departments if @report.key?('departments')
  end

  def send_report(recipient, text)
    CommentsMailer.report('EnrollChat Report',recipient, @report, text).deliver!
    report_action('enrollchat','recipients',recipient.email)
  end

  def report_action(target, group, message)
    @report[target] ||= Hash.new
    @report[target][group] ||= []
    @report[target][group] << message
  end

end
