require "application_system_test_case"

class SectionsTest < ApplicationSystemTestCase
  setup do
    login_as users(:one)
  end

  test "visiting the index" do
    visit sections_url
    assert_selector "h1", text: "Sections"
    take_screenshot
  end
end
