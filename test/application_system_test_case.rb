require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Silence deprecation warnings until upstream Capybara version is updated
  Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
  driven_by :selenium, using: :headless_firefox, screen_size: [1400,1050]

  def login_as(user)
    visit cas_login_path
    fill_in 'username', with: user.username
    fill_in 'password', with: 'any password'
    click_button 'Login'
  end

  def cas_login_path
    '/fake_cas_login'
  end

  def logout
    visit logout_path
  end
end
