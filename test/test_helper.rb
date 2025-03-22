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
  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do
    SimpleCov.result
  end
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  parallelize threshold: 0 if ENV["CI"].present?
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
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
