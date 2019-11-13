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
    @section.update(delete_at: 1.day.ago)
    Section.delete_marked
    assert_equal @sections.unscoped, [@section_two, @section_three, @section_four, @section_five]
    assert_equal @sections.count, 4
  end

  test 'should return a unique, unsorted list of departments' do
    @section_five = sections(:four)
    assert_equal @sections.departments, %w[BIS CRIM SINT ENGL]
  end

  test 'should create a list of all available statuses including the manually added ALL and ACTIVE statuses' do
    assert_equal @sections.status_list, %w[ACTIVE ALL C CL CN O WL]
  end

  test 'should create a list of level names available for selection' do
    assert_equal @sections.level_name_list, ["Undergraduate - Lower Division", "Undergraduate - Upper Division", "Graduate - First", "Graduate - Advanced"]
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

  test 'graduate_under_enrolled and graduate_level scopes should return graduate sections where actual enrollment and cross list enrollment is less than the enrollment threshold' do
    @section_three.update(actual_enrollment: 7)
    @section_three.update(cross_list_enrollment: 2)
    assert_equal @sections.graduate_level.graduate_under_enrolled, [@section_three]
  end

  test 'undergraduate_under_enrolled and undergraduate_level scopes should return undergraduate sections where actual and cross list enrollment is less than the enrollment threshold' do
    @section_four.update(actual_enrollment: 9)
    @section_four.update(cross_list_enrollment: 2)
    assert_equal @sections.undergraduate_level.undergraduate_under_enrolled, [@section_four]
  end

  test 'undergraduate_level and over_enrolled scopes should return undergraduate sections where actual enrollment is at least 5 greater than the enrollment limit' do
    @section.update(waitlist: 6)
    assert_equal @sections.undergraduate_level.over_enrolled, [@section]
  end

  test 'graduate_level and over_enrolled scopes should return graduate sections where actual enrollment is greater than the enrollment limit' do
    assert_equal @sections.graduate_level.over_enrolled, [@section_two]
  end

  # import
  test 'import updates attributes for the first existing section' do
    assert_equal @section.actual_enrollment, 22
    assert_equal @section.cross_list_enrollment, 1
    assert_equal @section.waitlist, 1
    Section.import(file_fixture('test_crse.csv'))
    @section.reload
    assert_equal @section.actual_enrollment, 24
    assert_equal @section.cross_list_enrollment, 3
    assert_equal @section.waitlist, 0
  end

  test 'import updates attributes for the last existing section' do
    assert_equal @section_five.actual_enrollment, 26
    assert_equal @section_five.cross_list_enrollment, 2
    assert_equal @section_five.waitlist, 7
    Section.import(file_fixture('test_crse.csv'))
    @section_five.reload
    assert_equal @section_five.actual_enrollment, 27
    assert_equal @section_five.cross_list_enrollment, 3
    assert_equal @section_five.waitlist, 6
  end

  test 'import adds a new section' do
    assert_equal @sections.count, 5
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @sections.count, 6
  end

  test 'import correctly sets attributes for a new section' do
    Section.import(file_fixture('test_crse.csv'))
    @new_section = Section.last
    assert_equal @new_section.term, 201810
    assert_equal @new_section.department, 'HIST'
    assert_equal @new_section.course_description, 'HIST 100'
    assert_equal @new_section.section_number, '002'
    assert_equal @new_section.title, 'History of Western Civ'
    assert_equal @new_section.credits, 3
    assert_equal @new_section.level, 'UUL'
    assert_equal @new_section.status, 'O'
    assert_equal @new_section.enrollment_limit, 55
    assert_equal @new_section.actual_enrollment, 54
    assert_equal @new_section.cross_list_enrollment, 0
    assert_equal @new_section.waitlist, 0
    assert_nil @new_section.canceled_at
    assert_nil @new_section.delete_at
    assert_equal @new_section.enrollment_limit_yesterday, 0
    assert_equal @new_section.actual_enrollment_yesterday, 0
    assert_equal @new_section.cross_list_enrollment_yesterday, 0
    assert_equal @new_section.waitlist_yesterday, 0
  end

  test 'import identifies newly canceled sections' do
    assert_equal @section_three.status, 'O'
    Section.import(file_fixture('test_crse.csv'))
    @section_three.reload
    assert_equal @section_three.status, 'C'
    assert_not_nil @section_three.canceled_at
  end

  test 'import creates an enrollment for a section' do
    assert_difference('@section.enrollments.count', + 1) do
      Section.import(file_fixture('test_crse.csv'))
    end
  end

  test 'import sets enrollment attributes for a section' do
    Section.import(file_fixture('test_crse.csv'))
    @section.reload
    @new_enrollment = @section.enrollments.last
    assert_equal @new_enrollment.department, @section.department
    assert_equal @new_enrollment.term, @section.term
    assert_equal @new_enrollment.enrollment_limit, @section.enrollment_limit
    assert_equal @new_enrollment.actual_enrollment, @section.actual_enrollment
    assert_equal @new_enrollment.cross_list_enrollment, @section.cross_list_enrollment
    assert_equal @new_enrollment.waitlist, @section.waitlist
  end

  # track_differences
  test 'tracks differences in enrollment_limit' do
    assert_equal @section.enrollment_limit_yesterday, 0
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.enrollment_limit_yesterday, 1
  end

  test 'tracks differences in actual_enrollment' do
    assert_equal @section.actual_enrollment_yesterday, 0
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.actual_enrollment_yesterday, 2
  end

  test 'tracks differences in cross_list_enrollment' do
    assert_equal @section.cross_list_enrollment_yesterday, 0
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.cross_list_enrollment_yesterday, 2
  end

  test 'tracks differences in waitlist' do
    assert_equal @section.waitlist_yesterday, 0
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.waitlist_yesterday, -1
  end

  test 'sets change in enrollment limit to 0 if previous value was nil' do
    @section.update(enrollment_limit: nil)
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.enrollment_limit_yesterday, 0
  end

  test 'sets change in actual enrollment to 0 if previous value was nil' do
    @section.update(actual_enrollment: nil)
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.actual_enrollment_yesterday, 0
  end

  test 'sets change in cross_list_enrollment to 0 if previous value was nil' do
    @section.update(cross_list_enrollment: nil)
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.cross_list_enrollment_yesterday, 0
  end

  test 'sets change in waitlist to 0 if previous value was nil' do
    @section.update(waitlist: nil)
    Section.import(file_fixture('test_crse.csv'))
    assert_equal @section.reload.waitlist_yesterday, 0
  end

  test 'sets change in section attributes to 0 for a new record' do
    Section.import(file_fixture('test_crse.csv'))
    @new_section = Section.last
    assert_equal @new_section.reload.enrollment_limit_yesterday, 0
    assert_equal @new_section.reload.actual_enrollment_yesterday, 0
    assert_equal @new_section.reload.cross_list_enrollment_yesterday, 0
    assert_equal @new_section.reload.waitlist_yesterday, 0
  end

  test 'import cancels a section that no longer appears in the import file' do
    @cancel = sections(:one)
    @cancel.update(section_id: 7, status: 'CN')
    Section.import(file_fixture('test_crse.csv'))
    assert @cancel.status, 'C'
  end

  test 'returns an array of unique terms' do
    @section.update(term: 201710)
    @section_two.update(term: 201710)
    @section_three.update(term: 201410)
    @section_four.update(term: 201540)
    @section_five.update(term: 201370)
    assert_equal @sections.reload.terms.sort, [201370, 201410, 201540, 201710]
  end

  test 'determines terms to delete based on their age' do
    @section.update(term: 201710)
    @section_two.update(term: 201770)
    @section_three.update(term: 201410)
    @section_four.update(term: 201540)
    @section_five.update(term: 201370)
    assert_equal @sections.terms_to_delete, [201370, 201410, 201540]
  end

  test 'sets delete_at for terms that should be removed based on their age' do
    @section.update(term: 201710)
    @section_two.update(term: 201770)
    @section_three.update(term: 201410)
    @section_four.update(term: 201540)
    @section_five.update(term: 201370)
    Section.mark_for_deletion
    assert_nil @section.reload.delete_at
    assert_nil @section_two.reload.delete_at
    assert_not_nil @section_three.reload.delete_at
    assert_not_nil @section_four.reload.delete_at
    assert_not_nil @section_five.reload.delete_at
  end
end
