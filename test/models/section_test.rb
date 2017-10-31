require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  setup do
    @section = sections(:one)
    @section_two = sections(:two)
  end

  test 'section number is formatted correctly' do
    @section.section_number = 23
    assert_equal @section.section_number_zeroed, '023'
  end

  test 'should format the section and number' do
    @section.course_description = 'ABC 123'
    @section.section_number = '01'
    assert_equal @section.section_and_number, 'ABC 123-001'
  end

  test 'should create a list of all departments' do
    assert_equal Section.department_list, ["BIS", "CLS", "SINT"]
  end

  test 'should create a list of all available statuses including the manually added ACTIVE status' do
    assert_equal Section.status_list, ['ACTIVE', 'CN', 'O', 'WL']
  end

  test 'should create a list of levels available for selection' do
    assert_equal Section.level_list, ['Graduate', 'Undergraduate']
  end

  test 'should create a list of registrations statuses' do
    skip
  end
end
