require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.find_or_create_by(singleton_guard: 0) do |setting|
      setting.current_term = 201810
      setting.undergraduate_enrollment_threshold = 12
      setting.graduate_enrollment_threshold = 10
      setting.email_delivery = 'scheduled'
    end
  end

  test 'should GET index' do
    login_as(users(:two))
    get reports_url
    assert_response :success
    logout
  end

  test 'should not GET index for unregistered user' do
    unregistered_login
    get reports_url
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
    logout
  end

  test 'should GET show' do
    login_as(users(:two))
    get report_url(sections(:two))
    assert_response :success
    logout
  end

  test 'should not GET show for unregistered user' do
    unregistered_login
    get report_url(sections(:two))
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
    logout
  end
end
