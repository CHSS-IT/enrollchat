require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400,1050]

<<<<<<< HEAD
  include Warden::Test::Helpers
  Warden.test_mode!

  teardown do
    Warden.test_reset!
  end
=======
  def login_as(user)
    visit test_login_path
    fill_in 'username', with: user.username
    fill_in 'password', with: 'any password'
    click_button 'Login'
  end

  def test_login_path
    ENV['TEST_LOGIN_PATH']
  end

  def logout
    visit logout_path
  end

>>>>>>> master
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
