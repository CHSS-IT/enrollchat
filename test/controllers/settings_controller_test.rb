require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.find_or_create_by(singleton_guard: 0) do |setting|
      setting.current_term = 201810
      setting.undergraduate_enrollment_threshold = 12
      setting.graduate_enrollment_threshold = 10
      setting.email_delivery = 'scheduled'
    end
    @setting = settings(:one)
  end

  teardown do
    logout
  end

  test "index should redirect to edit for admin" do
    login_as(users(:one))
    get settings_url
    assert_redirected_to edit_setting_url(@setting)
  end

  test "should not GET index for a non-admin user" do
    login_as(users(:two))
    get settings_url
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page.', flash[:notice]
  end

  test "should not GET index for unregistered user" do
    unregistered_login
    get settings_url
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test "should get edit" do
    login_as(users(:one))
    get edit_setting_url(@setting)
    assert_response :success
  end

  test "should not GET edit for non-admin user" do
    login_as(users(:two))
    get edit_setting_url(@setting)
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page.', flash[:notice]
  end

  test "should not GET edit for unregistered user" do
    unregistered_login
    get edit_setting_url(@setting)
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test "should UPDATE setting" do
    login_as(users(:one))
    patch setting_url(@setting), params: { setting: { current_term: 123456 } }
    assert_redirected_to sections_url
    assert_equal @setting.reload.current_term, 123456
    assert_equal 'Setting was successfully updated.', flash[:notice]
  end

  test "should not UPDATE setting for non-admin user" do
    login_as(users(:two))
    patch setting_url(@setting), params: { setting: { current_term: 123456 } }
    assert_redirected_to sections_url
    assert_equal @setting.reload.current_term, 201810
    assert_equal 'You do not have access to this page.', flash[:notice]
  end

  test "should not UPDATE setting for unregistered user" do
    unregistered_login
    patch setting_url(@setting), params: { setting: { current_term: 123456 } }
    assert_redirected_to unregistered_url
    assert_equal @setting.reload.current_term, 201810
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end
end
