require 'test_helper'

class ReportsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:one)
  end

  test 'should display a row for each department' do
    get reports_path
    assert_select 'table tbody tr td', text: 'BIS'
    assert_select 'table tbody tr td', text: 'CRIM'
    assert_select 'table tbody tr td', text: 'ENGL'
    assert_select 'table tbody tr td', text: 'SINT'
  end

  test 'should display the total enrollment limit for each department' do
    get reports_path
    assert_select 'table tbody tr td', text: '20'
    assert_select 'table tbody tr td', text: '20'
    assert_select 'table tbody tr td', text: '25'
    assert_select 'table tbody tr td', text: '30'
  end

  test 'should display the total actual enrollment for each department' do
    get reports_path
    assert_select 'table tbody tr td', text: '22'
    assert_select 'table tbody tr td', text: '26'
    assert_select 'table tbody tr td', text: '13'
    assert_select 'table tbody tr td', text: '9'
  end

  test 'should display the total cross-list enrollment for each deparment' do
    get reports_path
    assert_select 'table tbody tr td', text: '1'
    assert_select 'table tbody tr td', text: '2'
    assert_select 'table tbody tr td', text: '6'
    assert_select 'table tbody tr td', text: '5'
  end

  test 'should display the total waitlisted for each department' do
    get reports_path
    assert_select 'table tbody tr td', text: '1'
    assert_select 'table tbody tr td', text: '7'
    assert_select 'table tbody tr td', text: '0'
    assert_select 'table tbody tr td', text: '2'
  end

  test 'should return enrollments for a department in the proper term' do
    @enrollment_one = enrollments(:one)
    @enrollment_two = enrollments(:two)
    @enrollment_three = enrollments(:three)
    @enrollment_four = enrollments(:four)
    @enrollment_five = enrollments(:five)
    @enrollment_six = enrollments(:six)
    @enrollment_seven = enrollments(:seven)
    @enrollments = Enrollment.all
    get report_url(sections(:two))
    assert_equal @enrollments.in_term(1).in_department("CRIM"), [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five, @enrollment_seven]
  end
end
