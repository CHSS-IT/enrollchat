class NewCommentWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  sidekiq_options retry: false

  # def initialize
  #   @report = Hash.new
  # end

  def perform(comment_id)
    @comment = Comment.find(comment_id)
    # A new comment has been created
    # Construct an email informing users of the new comment
    recipient = User.find(2)
    subject = "New Comment on #{@comment.section.section_and_number}"
    CommentsMailer.new_comment(@comment, subject, recipient).deliver!


    # Send that email to each user who
    # - Wants either comment emails or both comment and digest
    # - AND (has the comment's section's program selected OR has no programs selected)
    # We will not send a report after this runs
    # build_report
    # identify_and_send
    # report_complete
  end


  def identify_and_send
    recipients = User.wanting_digest # includes admins
    if recipients.present?
      recipients.each do |recipient|
        send_digest(recipient) if departments_with_comments(recipient).present?
      end
    end
  end

  def departments_with_comments(recipient)
    @report['departments']['list'] & (recipient.departments.present? ? recipient.departments : Section.department_list)
  end

  def send_digest(recipient)
    # puts "#{recipient.full_name} wants reports on #{departments_with_comments(recipient)}"
    text = departments_with_comments(recipient).collect { |department| @report['departments'][department] }.join.html_safe
    # puts text
    CommentsMailer.digest(text,'EnrollChat Comments Digest',recipient).deliver!
  end

  def report_complete

    # CommentsMailer.generic(report.html_safe, "EnrollChat Digest Task Report", 'dcollie2@gmu.edu').deliver! # TBD: move email recipient to setting
    puts "Report ran fully."
  end

  def report_action(target, group, message)
    @report[target] ||= Hash.new
    @report[target][group] ||= []
    @report[target][group] << message
    # puts target + " " + message
  end

end