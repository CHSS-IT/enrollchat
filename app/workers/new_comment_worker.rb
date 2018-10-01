class NewCommentWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  sidekiq_options retry: false

  def perform(comment_id)
    @comment = Comment.find(comment_id)
    # A new comment has been created
    # Construct an email informing users of the new comment
    subject = "EnrollChat: Comment on #{@comment.section.section_and_number}"
    # Send that email to each user who
    # - Wants either comment emails or both comment and digest
    # - AND (has the comment's section's program selected OR has no programs selected)
    recipients = User.in_department(@comment.section.department).wanting_comment_emails # includes admins
    if recipients.present?
      recipients.each do |recipient|
        CommentsMailer.new_comment(@comment, subject, recipient).deliver!
      end
    end
  end
end
