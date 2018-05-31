require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'app/uploaders/feed_uploader.rb'
  add_filter 'bin/'
  add_filter 'app/channels/'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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
