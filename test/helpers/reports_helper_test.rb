require 'test_helper'

class ReportHelperTest < ActionView::TestCase
  include ReportsHelper

  setup do
    @enrollment_one = enrollments(:one)
    @enrollment_two = enrollments(:two)
    @enrollment_three = enrollments(:three)
    @enrollment_four = enrollments(:four)
    @enrollment_five = enrollments(:five)
    @enrollment_seven = enrollments(:seven)
    @enrollments = Enrollment.in_term(1).in_department("CRIM").not_canceled.order(:created_at).group_by { |e| e.created_at.strftime('%b %e') }
  end

  test "returns the version_date_strings for a department's enrollments in a term" do
    assert_equal version_date_strings, "[#{@enrollment_five.created_at.strftime("\"%b %e\"")},#{@enrollment_four.created_at.strftime("\"%b %e\"")},#{@enrollment_three.created_at.strftime("\"%b %e\"")},#{@enrollment_two.created_at.strftime("\"%b %e\"")},#{@enrollment_one.created_at.strftime("\"%b %e\"")}]"
  end

  test "calculates the waitlist_history for a department's enrollments in a term" do
    assert_equal waitlist_history, [@enrollment_five.waitlist, @enrollment_four.waitlist, @enrollment_three.waitlist, @enrollment_two.waitlist, @enrollment_one.waitlist]
  end

  test "calculates the cross_list_enrollment_history for a department's enrollments in a term" do
    assert_equal cross_list_enrollment_history, [@enrollment_five.cross_list_enrollment, @enrollment_four.cross_list_enrollment, @enrollment_three.cross_list_enrollment, @enrollment_two.cross_list_enrollment, @enrollment_one.cross_list_enrollment]
  end

  test "calculates the actual_enrollment_history for a department's enrollments in a term" do
    assert_equal actual_enrollment_history, [@enrollment_five.actual_enrollment, @enrollment_four.actual_enrollment, @enrollment_three.actual_enrollment, @enrollment_two.actual_enrollment, @enrollment_one.actual_enrollment]
  end

  test "calculates the enrollment_limit_history for a department's enrollments in a term" do
    assert_equal enrollment_limit_history, [@enrollment_five.enrollment_limit, @enrollment_four.enrollment_limit, @enrollment_three.enrollment_limit, @enrollment_two.enrollment_limit, @enrollment_one.enrollment_limit]
  end
end
