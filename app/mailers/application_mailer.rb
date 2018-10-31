class ApplicationMailer < ActionMailer::Base
  default from: ENV['ENROLLCHAT_ADMIN_EMAIL']
  layout 'mailer'

  private

  def development_text
    "(Triggered in #{Rails.env})" if !Rails.env.production?
  end

  def to_switch(email)
    Rails.env.development? ? ENV['ENROLLCHAT_ADMIN_EMAIL'] : email
  end
end
