require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    login_as users(:one)
    @setting = settings(:one)
  end

  test "visiting the index" do
    skip
    visit settings_url
    assert_selector "h1", text: "Settings"
  end

  test "creating a Setting" do
    skip
    visit settings_url
    click_on "New Setting"

    fill_in "Current Term", with: @setting.current_term
    click_on "Create Setting"

    assert_text "Setting was successfully created"
    click_on "Back"
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

  test "destroying a Setting" do
    skip
    visit settings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Setting was successfully destroyed"
  end
end
