class ApplicationMailer < ActionMailer::Base
  default from: ENV['ENROLLCHAT_ADMIN_EMAIL'] # TBD: Base on variable
  layout 'mailer'

  private

  def development_text
    "[Triggered in Development]" if Rails.env == "development"
  end

  def to_switch(email)
    Rails.env == "development" ? ENV['ENROLLCHAT_ADMIN_EMAIL'] : email # TBD: Base on variable/environment
  end

end
