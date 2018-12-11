require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting = settings(:one)
    login_as users(:one)

  end

  test "index should redirect to edit" do
    get settings_url
    assert_redirected_to edit_setting_url(@setting)
  end

  test "should get edit" do
    get edit_setting_url(@setting)
    assert_response :success
  end

  test "should update setting" do
    patch setting_url(@setting), params: { setting: { current_term: @setting.current_term } }
    assert_redirected_to sections_url
  end

end
