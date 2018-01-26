class CommentsMailer < ApplicationMailer
  # default from: 'chssweb@gmu.edu' # TBD: Base on variable
  helper :application

  def digest(message, subject, recipient)
    @message = message
    @recipient = recipient
    to = to_switch(recipient.email)
    subject = "#{subject} #{development_text}"
    mail(:to => to, :subject => subject)
  end

  def new_comment(comment, subject, recipient)
    @comment = comment
    @subject = subject
    @recipient = recipient
    to = to_switch(recipient)
    mail(to: to, subject: subject, comment: comment)
  end

  def generic(message, subject, address)
    @message = message
    to = to_switch(address)
    subject = "#{subject} #{development_text}"
    mail(:to => to, :subject => subject)
  end

end
