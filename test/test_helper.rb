require 'simplecov'
SimpleCov.start 'rails'
puts "required simplecov"

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

# support for Webdrivers gem
Webdrivers.cache_time = 0

# silence Puma output in system tests
Capybara.server = :puma, { Silent: true }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  teardown do
    Warden.test_reset!
  end
end

class ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  Warden.test_mode!
end
