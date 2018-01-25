class CommentsMailer < ApplicationMailer
  # default from: 'chssweb@gmu.edu' # TBD: Base on variable

  def digest(message, subject, recipient)
    @message = message
    @recipient = recipient
    to = to_switch(recipient.email)
    subject = "#{subject} #{development_text}"
    mail(:to => to, :subject => subject)
  end

  def generic(message, subject, address)
    @message = message
    to = to_switch(address)
    subject = "#{subject} #{development_text}"
    mail(:to => to, :subject => subject)
  end

end
