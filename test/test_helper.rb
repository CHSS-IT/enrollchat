require 'simplecov'
SimpleCov.start 'rails'
puts "required simplecov"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/autorun'

# silence Puma output in system tests
Capybara.server = :puma, { Silent: true }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
  # Ensure that a setting is available
  Setting.find_or_create_by(singleton_guard: 0) do |setting|
    setting.current_term = 201810
    setting.undergraduate_enrollment_threshold = 12
    setting.graduate_enrollment_threshold = 10
    setting.email_delivery = 'scheduled'
  end

  def login_as(user)
    post login_path, params: { username: user.username, password: 'any password' }
  end

  def unregistered_login
    post login_path, params: { username: 'unregistered', password: 'any password' }
  end

  def logout
    get logout_path
  end

  ENV['TERM_ONE_START'] = '4'
  ENV['TERM_ONE_END'] = '9'
  ENV['TERM_TWO_START'] = '11'
  ENV['TERM_TWO_END'] = '1'
  ENV['CAMPUS_CODE_ONE'] = 'VA'
  ENV['CAMPUS_LABEL_ONE'] = 'Virginia Campus'
end
