class ReportWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
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
    # report_complete
  end

  def build_comment_report
    Section.department_list.each do |department|
      comments = Comment.yesterday.for_department(department).by_course
      if comments.present?
        puts "Comments on #{department} present"
        # Add to list of departments (probably not necessary TBD: review and eliminate)
        report_action('departments', 'list', department)

        # build email contents
        subject = "EnrollChat Digest Email for #{department}"
        text = "<h2>#{subject} - #{basic_date(DateTime.yesterday)}</h2>"

        comments.group_by(&:section).sort.each do |section, c|
          text += "<p>#{ActionController::Base.helpers.link_to section.section_and_number, section_url(section, host: 'enrollchat.herokuapp.com')}" + ": #{c.size} comment#{'s' if c.size > 1}</p>"
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
      send_report(recipient)
    end
  end

  def report_complete
    text = 'summary report goes here'
    # text += '<h1>Departments With Comments</h1><p>' + @report['departments']['list'].join(', ') + '</p>' if @report['departments'].present?
    # text += '<h1>Digests Sent to</h1><p>' + @report['chssweb']['recipients'].join(', ') + '</p>' if @report['chssweb'].present?
    # text += '<p>No comment activity.</>' if @report['departments'].present? && !@report['chssweb'].present?
    CommentsMailer.generic(text.html_safe, "EnrollChat Report Task Executed", ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver! # TBD: move email recipient to setting
    puts "Report ran fully."
  end


  def departments_with_comments(recipient)
    @report['departments']['list'] & (recipient.reporting_departments.present? ? recipient.reporting_departments : Section.department_list)
  end

  def send_report(recipient)

    # puts @report['summaries']
    # puts "#{recipient.full_name} wants reports on #{departments_with_comments(recipient)}"
    # text = 'report goes here'
    # text += recipient.reporting_departments.collect { |department| @report['summaries'][department] }.join.html_safe
    # text += departments_with_comments(recipient).collect { |department| @report['departments'][department] }.join.html_safe
    # puts text
    CommentsMailer.report('EnrollChat Report',recipient, @report).deliver!
    report_action('chssweb','recipients',recipient.email)
  end


  def report_action(target, group, message)
    @report[target] ||= Hash.new
    @report[target][group] ||= []
    @report[target][group] << message
    # puts target + " " + message
  end

end