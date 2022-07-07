class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.test? ? "no-reply@example.com" : ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)
  layout 'mailer'

  private

  def development_text
    "(Triggered in #{Rails.env})" unless Rails.env.production?
  end

  def to_switch(email)
    case Rails.env
    when "production"
      email
    when "development"
      ENV.fetch('ENROLLCHAT_ADMIN_EMAIL', nil)
    when "test"
      "recipient@example.com"
    end
  end
end
