class DigestWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  sidekiq_options retry: false

  def initialize
    @report = Hash.new
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
    identify_and_send unless @report.empty?
    report_complete
  end

  def build_report
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
    puts @report.inspect
  end

  def identify_and_send
    recipients = User.wanting_digest
    if recipients.present?
      recipients.each do |recipient|
        puts "#{recipient.email} #{departments_with_comments(recipient).present?}"
        if departments_with_comments(recipient).present?
          send_digest(recipient)
        end
      end
    end
  end

  def report_complete
    text = ''
    text += '<h1>Departments With Comments</h1><p>' + @report['departments']['list'].join(', ') + '</p>' if @report['departments'].present?
    text += '<h1>Digests Sent to</h1><p>' + @report['chssweb']['recipients'].join(', ') + '</p>' if @report['chssweb'].present?
    text += '<p>No comment activity.</>' if @report['departments'].present? && !@report['chssweb'].present?
    CommentsMailer.generic(text.html_safe, "EnrollChat Digest Task Executed", ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver! # TBD: move email recipient to setting
    puts "Report ran fully."
  end


  def departments_with_comments(recipient)
    @report['departments']['list'] & (recipient.departments.present? ? recipient.departments : Section.department_list)
  end

  def send_digest(recipient)
    # puts "#{recipient.full_name} wants reports on #{departments_with_comments(recipient)}"
    text = departments_with_comments(recipient).collect { |department| @report['departments'][department] }.join.html_safe
    # puts text
    CommentsMailer.digest(text,'EnrollChat Comments Digest',recipient).deliver!
    report_action('chssweb','recipients',recipient.email)
  end


  def report_action(target, group, message)
    @report[target] ||= Hash.new
    @report[target][group] ||= []
    @report[target][group] << message
    # puts target + " " + message
  end

end