require 'test_helper'

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section_one = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @section_four = sections(:four)
    @section_five = sections(:five)
    @sections = Section.all
    login_as users(:one)
  end

  test 'should GET index' do
    get sections_url
    assert_response :success
  end

  test 'should GET index with full collection of sections' do
    get sections_url
    assert_response :success
    assert_equal @sections, [@section_one, @section_two, @section_three, @section_four, @section_five]
  end

  test 'should GET show for a section' do
    get section_url(@section_one)
    assert_response :success
  end

  test 'should toggle_resolved_section for an admin' do
    patch toggle_resolved_section_section_path(@section_one), params: { format: :js }
    assert_equal @section_one.reload.resolved_section, true
  end

  test 'should not toggle_resolved_section for a non-admin user' do
    login_as users(:two)
    patch toggle_resolved_section_section_path(@section_one), params: { format: :js }
    assert_equal @section_one.reload.resolved_section, false
  end

  test 'should not perform import for a non-admin user' do
    login_as users(:two)
    post sections_import_path
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end
end
