require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
    @setting = settings(:one)
  end

  teardown do
    logout
  end

  test "updating the undergraduate_enrollment_threshold setting" do
    visit edit_setting_url(@setting)
    fill_in "setting[undergraduate_enrollment_threshold]", with: 5
    click_on "Save"
    assert_text "Setting was successfully updated"
    assert_equal Section.undergraduate_enrollment_threshold, 5
  end

  test "updating the graduate_enrollment_threshold setting" do
    visit edit_setting_url(@setting)
    fill_in "setting[graduate_enrollment_threshold]", with: 7
    click_on "Save"
    assert_text "Setting was successfully updated"
    assert_equal Section.graduate_enrollment_threshold, 7
  end

  test "updating the email delivery setting" do
    visit edit_setting_url(@setting)
    select('on', from: 'setting_email_delivery')
    click_on 'Save'
    assert_text "Setting was successfully updated"
    assert_equal @setting.reload.email_delivery, 'on'
  end

  test "documentation link is optional" do
    visit sections_url
    refute_text "EnrollChat Information and Updates"
  end

  test "display documentation link when it is set" do
    @setting.update(documentation_url: "https://testdoclink.com")
    visit sections_url
    assert_text 'EnrollChat Information and Updates'
  end
end
