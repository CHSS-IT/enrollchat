class CommentsMailer < ApplicationMailer
  helper :application

  def digest(message, subject, recipient)
    @message = message
    @recipient = recipient
    to = to_switch(recipient.email)
    subject = "#{subject} #{development_text}"
    mail(to: to, subject: subject)
  end

  def new_comment(comment, subject, recipient)
    @comment = comment
    @subject = "#{subject} #{development_text}"
    @recipient = recipient
    to = to_switch(recipient.email)
    mail(to: to, subject: @subject, comment: comment)
  end

  def report(subject, recipient, report, text, term)
    @term = term
    @recipient = recipient
    @report = report
    @text = text
    to = to_switch(recipient.email)
    subject = "#{subject} #{development_text}"
    mail(to: to, subject: subject)
  end

  def generic(message, subject, address)
    @message = message
    to = to_switch(address)
    subject = "#{subject} #{development_text}"
    mail(to: to, subject: subject)
  end
end
