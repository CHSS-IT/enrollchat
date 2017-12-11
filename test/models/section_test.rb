require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  setup do
    @section = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @section_four = sections(:four)
    @sections = Section.all
  end

  test 'section number is formatted correctly' do
    @section.section_number = '23'
    assert_equal @section.section_number_zeroed, '023'
  end

  test 'should format the section and number' do
    @section.course_description = 'ABC 123'
    @section.section_number = '01'
    assert_equal @section.section_and_number, 'ABC 123-001'
  end

  test 'should create a list of all departments' do
    assert_equal @sections.department_list, ["BIS", "CLS", "ENGL", "SINT"]
  end

  test 'should create a list of all available statuses including the manually added ALL and ACTIVE statuses' do
    assert_equal @sections.status_list, ["ACTIVE", "ALL", "CL", "CN", "O", "WL"]
  end

  test 'should create a list of levels available for selection' do
    assert_equal @sections.level_list, ["Undergraduate - Lower Division", "Undergraduate - Upper Division", "Graduate - First", "Graduate - Advanced"]
  end

  test 'should create a list of enrollment statuses' do
    assert_equal Section.enrollment_status_list, ["Undergraduate under-enrolled", "Undergraduate over-enrolled", "Graduate under-enrolled", "Graduate over-enrolled"]
  end

  # test scopes used in filter

  test 'by_department scope should properly filter sections by department' do
    assert_equal @sections.in_department('CLS'), [@section_two]
  end

  test 'by_status scope should properly filter sections by section status' do
    assert_equal @sections.in_status('CN'), [@section]
  end

  test 'graduate_advanced scope should properly filter sections by level' do
    assert_equal @sections.graduate_advanced, [@section_three]
  end

  test 'graduate_first scope should properly filter sections by level' do
    assert_equal @sections.graduate_first, [@section_two]
  end

  test 'undergraduate_upper scope should properly filter sections by level' do
    assert_equal @sections.undergraduate_upper, [@section_four]
  end

  test 'undergraduate_lower scope should properly filter sections by level' do
    assert_equal @sections.undergraduate_lower, [@section]
  end

  test 'graduate_under_enrolled and graduate_level scopes should return graduate sections where actual enrollment and cross list enrollment is less than 10' do
    assert_equal @sections.graduate_level.graduate_under_enrolled, [@section_three]
  end

  test 'undergraduate_under_enrolled and undergraduate_level scopes should return undergraduate sections where actual and cross list enrollment is less than 15' do
    assert_equal @sections.undergraduate_level.undergraduate_under_enrolled, [@section_four]
  end

  test 'undergraduate_level and over_enrolled scopes should return undergraduate sections where actual enrollment is greater than the enrollment limit' do
    assert_equal @sections.undergraduate_level.over_enrolled, [@section]
  end

  test 'graduate_level and over_enrolled scopes should return graduate sections where actual enrollment is greater than the enrollment limit' do
    assert_equal @sections.graduate_level.over_enrolled, [@section_two]
  end
end
