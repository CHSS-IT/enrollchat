require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.find_or_create_by(singleton_guard: 0) do |setting|
      setting.current_term = 201810
      setting.undergraduate_enrollment_threshold = 12
      setting.graduate_enrollment_threshold = 10
      setting.email_delivery = 'scheduled'
    end
  end

  test 'should GET home' do
    get home_url
    assert_response :success
  end

  test 'should GET unregistered' do
    get unregistered_url
    assert_response :success
  end
end
