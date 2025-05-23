require 'test_helper'

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section_one = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @section_four = sections(:four)
    @section_five = sections(:five)
    @sections = Section.all
  end

  teardown do
    logout
  end

  test 'should GET index' do
    login_as(users(:two))
    get sections_url
    assert_response :success
  end

  test 'should GET index with full collection of sections' do
    login_as(users(:two))
    get sections_url
    assert_response :success
    assert_equal @sections, [@section_one, @section_two, @section_three, @section_four, @section_five]
  end

  test 'should not GET index for an unregistered user' do
    unregistered_login
    get sections_url
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test 'should GET show for a section' do
    login_as(users(:two))
    get section_url(@section_one)
    assert_response :success
  end

  test 'should not GET show for a section for an unregistered user' do
    unregistered_login
    get section_url(@section_one)
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test 'should toggle_resolved_section for an admin' do
    login_as(users(:one))
    patch toggle_resolved_section_section_path(@section_one), params: { format: :turbo_stream }
    assert_equal @section_one.reload.resolved_section, true
  end

  test 'should not toggle_resolved_section for a non-admin user' do
    login_as users(:two)
    patch toggle_resolved_section_section_path(@section_one), params: { format: :turbo_stream }
    assert_equal @section_one.reload.resolved_section, false
  end

  test 'should not toggle_resolved_section for an unregistered user' do
    unregistered_login
    patch toggle_resolved_section_section_path(@section_one), params: { format: :turbo_stream }
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
    assert_equal @section_one.reload.resolved_section, false
  end
end
