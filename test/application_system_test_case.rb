require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Silence deprecation warnings until upstream Capybara version is updated
  Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
  driven_by :selenium, using: :headless_firefox, screen_size: [1400,1050]

  # Added to ignore the browser options deprecation warning in rails 6.1 after upgrading to the
  # latest webdrivers gem using Selenium 4. Rails 7 fixes these but the patch will not be
  # backported. See https://github.com/rails/rails/pull/43503.
  # Remove this line when upgrading to Rails 7.
  # Selenium::WebDriver.logger.ignore(:browser_options)

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

module BootstrapSelectHelper
  # Example
  # bootstrap_select('Coca Pola', :from => 'company_id')
  # Modified version of helper by victorhazbun
  # https://gist.github.com/victorhazbun/ab703e8bc195924853e9ccfd683f9055
  def bootstrap_select(value, attrs)
    find(".bootstrap-select .dropdown-toggle[data-id='#{attrs[:from]}']").click
    find("ul.inner li a span", text: value).click
  end

  def bootstrap_multi_select(value1, value2, attrs)
    find(".bootstrap-select .dropdown-toggle[data-id='#{attrs[:from]}']").click
    find("ul.inner li a span", text: value1).click
    find("ul.inner li a span", text: value2).click
  end
end
