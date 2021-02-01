require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:one)
    @enrollment_one = enrollments(:one)
    @enrollment_two = enrollments(:two)
    @enrollment_three = enrollments(:three)
    @enrollment_four = enrollments(:four)
    @enrollment_five = enrollments(:five)
    @enrollment_six = enrollments(:six)
    @enrollment_seven = enrollments(:seven)
    @enrollments = Enrollment.all
  end

  test 'returns all enrollments in a term' do
    assert_equal @enrollments.in_term(1), [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five, @enrollment_seven]
  end

  test 'returns all enrollments in a department' do
    assert_equal @enrollments.in_department('CRIM'), [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five, @enrollment_seven]
  end

  test 'returns enrollments for only sections that are not canceled' do
    assert_equal @enrollments.not_canceled, [@enrollment_one, @enrollment_two, @enrollment_three, @enrollment_four, @enrollment_five, @enrollment_six]
  end

  test 'changes null waitlist value to 0' do
    @enrollment_one.waitlist = nil
    assert_equal(@enrollment_one.send(:null_to_zero), 0)
  end
end
