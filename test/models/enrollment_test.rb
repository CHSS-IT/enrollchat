require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  setup do
    @enrollment_one = enrollments(:one)
    @enrollment_two = enrollments(:two)
    @enrollment_three = enrollments(:three)
    @enrollment_four = enrollments(:four)
    @enrollment_five = enrollments(:five)
    @enrollments = Enrollment.all
  end

  test 'returns all enrollments in a term' do
    assert_equal @enrollments.in_term(1), [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five]
  end

  test 'returns all enrollments in a department' do
    assert_equal @enrollments.in_department('CRIM'), [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five]
  end

  test 'changes null waitlist value to 0' do
    @enrollment_one.waitlist = nil
    assert_equal(@enrollment_one.send(:null_to_zero), 0)
  end
end
