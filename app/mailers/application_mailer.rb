class ApplicationMailer < ActionMailer::Base
  default from: 'chssweb@gmu.edu' # TBD: Base on variable
  layout 'mailer'

  private

  def development_text
    "[Triggered in Development]" if Rails.env == "development"
  end

  def to_switch(email)
    Rails.env == "development" ? "chssweb@gmu.edu" : email # TBD: Base on variable/environment
  end

end
