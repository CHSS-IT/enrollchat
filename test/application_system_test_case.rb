require "test_helper"
require "capybara/cuprite"
require "turbo/system_test_helper"

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1400, 1050]
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Turbo::SystemTestHelper
  driven_by :cuprite

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
