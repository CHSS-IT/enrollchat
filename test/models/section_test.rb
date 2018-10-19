require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  setup do
    @section = sections(:one)
    @section_two = sections(:two)
    @section_three = sections(:three)
    @section_four = sections(:four)
    @section_five = sections(:five)
    @sections = Section.all
    @enrollment_one = enrollments(:one)
    @enrollment_two = enrollments(:two)
    @enrollment_three = enrollments(:three)
    @enrollment_four = enrollments(:four)
    @enrollment_five = enrollments(:five)
  end

  test 'should return an array of the enrollment history_dates for a section' do
    assert_equal @section_two.history_dates, [@enrollment_five.created_at, @enrollment_four.created_at, @enrollment_three.created_at, @enrollment_two.created_at, @enrollment_one.created_at]
  end

  test 'should return the enrollment history_dates as string for a section' do
    assert_equal @section_two.history_date_strings, [@enrollment_five.created_at.strftime('%b %e').to_s, @enrollment_four.created_at.strftime('%b %e').to_s, @enrollment_three.created_at.strftime('%b %e').to_s, @enrollment_two.created_at.strftime('%b %e').to_s, @enrollment_one.created_at.strftime('%b %e').to_s]
  end

  test 'should return the enrollment_limit_history for a section' do
    assert_equal @section_two.enrollment_limit_history, [20, 20, 20, 20, 20]
  end

  test 'should return the actual_enrollment_history for a section' do
    assert_equal @section_two.actual_enrollment_history, [12, 14, 17, 19, 19]
  end

  test 'should return the cross_list_enrollment_history for a section' do
    assert_equal @section_two.cross_list_enrollment_history, [0, 0, 1, 1, 1]
  end

  test 'should return the waitlist_history for a section' do
    assert_equal @section_two.waitlist_history, [0, 0, 0, 2, 6]
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

  test 'should create a list of all unique departments' do
    @section_five = sections(:four)
    assert_equal @sections.department_list, %w[BIS CRIM ENGL SINT]
  end

  test 'should destroy sections marked for deletion' do
    @section.update_attribute(:delete_at, DateTime.now().next_month)
    Section.delete_marked
    assert_equal @sections, [@section_two, @section_three, @section_four, @section_five]
    assert_equal @sections.count, 4
  end

  test 'should return a unique, unsorted list of departments' do
    @section_five = sections(:four)
    assert_equal @sections.departments, %w[BIS CRIM SINT ENGL]
  end

  test 'should create a list of all available statuses including the manually added ALL and ACTIVE statuses' do
    assert_equal @sections.status_list, %w[ACTIVE ALL C CL CN O WL]
  end

  test 'should create a list of level codes available for selection' do
    assert_equal @sections.level_code_list, %w[uul uuu ugf uga]
  end

  test 'should create a list of enrollment statuses' do
    assert_equal Section.enrollment_status_list, ['Undergraduate under-enrolled', 'Undergraduate over-enrolled', 'Graduate under-enrolled', 'Graduate over-enrolled']
  end

  # test scopes used in filter

  test 'by_department scope should properly filter sections by department' do
    assert_equal @sections.in_department('CRIM'), [@section_two, @section_five]
  end

  test 'by_status scope should properly filter sections by section status' do
    assert_equal @sections.in_status('CN'), [@section]
  end

  test 'graduate_advanced scope should properly filter sections by level' do
    assert_equal @sections.uga, [@section_three]
  end

  test 'graduate_first scope should properly filter sections by level' do
    assert_equal @sections.ugf, [@section_two, @section_five]
  end

  test 'undergraduate_upper scope should properly filter sections by level' do
    assert_equal @sections.uuu, [@section_four]
  end

  test 'undergraduate_lower scope should properly filter sections by level' do
    assert_equal @sections.uul, [@section]
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

  # import
  test 'import updates attributes for existing sections' do
    assert_equal @section.actual_enrollment, 22
    assert_equal @section.cross_list_enrollment, 1
    assert_equal @section.waitlist, 1
    Section.import(file_fixture('test_crse.csv'))
    @section.reload
    assert_equal @section.actual_enrollment, 23
    assert_equal @section.cross_list_enrollment, 2
    assert_equal @section.waitlist, 0
  end

  # track_differences
  test 'tracks differences in enrollment_limit' do
    puts 'XXXXXXXX'
    @section.save!
    puts @section.enrollment_limit_yesterday
    puts @section.enrollment_limit_before_last_save
    assert_equal @section.enrollment_limit_yesterday, 0
    Section.import(file_fixture('test_crse.csv'))
    puts 'XXXXXX'
    puts @section.reload.enrollment_limit_before_last_save
    puts 'XXXXXXXX'
    @section.reload
    puts @section.enrollment_limit
    puts @section.enrollment_limit_yesterday
    assert_equal @section.enrollment_limit_yesterday, 1
  end
end
