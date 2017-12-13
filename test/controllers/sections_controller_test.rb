require 'test_helper'

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section_one = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @section_four = sections(:four)
    @sections = Section.all
    login_as users(:one)
  end

  test "should GET index" do
    get sections_url
    assert_response :success
  end

  test "should GET index with full collection of sections" do
    get sections_url
    assert_response :success
    assert_equal @sections, [@section_one, @section_two, @section_three, @section_four]
  end

  test "should show section" do
    get section_url(@section_one)
    assert_response :success
  end

  test "should not perform import for a non-admin user" do
    login_as users(:two)
    post sections_import_path
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

end
