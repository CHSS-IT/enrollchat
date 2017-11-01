require 'test_helper'

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section_one = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @sections = Section.all
    login_as users(:one)
  end

  test "should GET index" do
    get sections_url
    assert_response :success
  end

  test "should GET index with full collection of sections" do
    assert_equal @sections, [@section_one, @section_two, @section_three]
  end

  test "should GET index with sections filtered by proper department" do
    get sections_url params: { section: { department: 'CLS' } }
    assert_response :success
    @sections = @sections.by_department('CLS')
    assert_equal @sections, [@section_two]
  end

  test "should GET index with sections filtered by proper status" do
    skip
  end

  test "should GET index with sections filtered by proper level" do
    skip
  end

  test "should GET index with sections filtered by proper registration status" do
    skip
  end

  # test "should get new" do
  #   get new_section_url
  #   assert_response :success
  # end
  #
  # test "should create section" do
  #   assert_difference('Section.count') do
  #     post sections_url, params: { section: { actual_enrollment: @section.actual_enrollment, course_description: @section.course_description, credits: @section.credits, cross_list_enrollment: @section.cross_list_enrollment, cross_list_group: @section.cross_list_group, department: @section.department, enrollment_limit: @section.enrollment_limit, level: @section.level, owner: @section.owner, section_id: @section.section_id, section_number: @section.section_number, status: @section.status, term: @section.term, title: @section.title, waitlist: @section.waitlist } }
  #   end
  #
  #   assert_redirected_to section_url(Section.last)
  # end

  test "should show section" do
    get section_url(@section_one)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_section_url(@section)
  #   assert_response :success
  # end
  #
  # test "should update section" do
  #   patch section_url(@section), params: { section: { actual_enrollment: @section.actual_enrollment, course_description: @section.course_description, credits: @section.credits, cross_list_enrollment: @section.cross_list_enrollment, cross_list_group: @section.cross_list_group, department: @section.department, enrollment_limit: @section.enrollment_limit, level: @section.level, owner: @section.owner, section_id: @section.section_id, section_number: @section.section_number, status: @section.status, term: @section.term, title: @section.title, waitlist: @section.waitlist } }
  #   assert_redirected_to section_url(@section)
  # end
  #
  # test "should destroy section" do
  #   assert_difference('Section.count', -1) do
  #     delete section_url(@section)
  #   end
  #
  #   assert_redirected_to sections_url
  # end

  test "should not perform import for a non-admin user" do
    login_as users(:two)
    post sections_import_path
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

end
