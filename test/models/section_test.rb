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

  test 'department list shoud create an array of all departments' do
    assert_equal Section.department_list, ['BIS', 'CLS']
  end
end
