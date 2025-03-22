require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage) # Silence deprecation warnings until upstream Capybara version is updated https://github.com/teamcapybara/capybara/issues/2779

  driven_by :selenium, using: :headless_firefox, screen_size: [1920, 1080]
  # Switched to Firefox temporarily on 3/13/25. Since Chrome 133,
  # we have been seeing race condition failures in our system specs.

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

  setup do
    Setting.create!(current_term: 201810, singleton_guard: 0, undergraduate_enrollment_threshold: 12, graduate_enrollment_threshold: 10, email_delivery: 'scheduled') unless Setting.first
  end

  teardown do
    Setting.first&.destroy
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
