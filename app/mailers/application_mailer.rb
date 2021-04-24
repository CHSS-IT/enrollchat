class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.test? ? "no-reply@example.com" : ENV['ENROLLCHAT_ADMIN_EMAIL']
  layout 'mailer'

  private

  def development_text
    "(Triggered in #{Rails.env})" unless Rails.env.production?
  end

  def to_switch(email)
    Rails.env.production? ? email : ENV['ENROLLCHAT_ADMIN_EMAIL']
  end
end
