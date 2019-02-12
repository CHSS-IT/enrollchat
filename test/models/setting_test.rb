require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:one)
  end

  test 'current term can be null' do
    @setting.current_term = nil
    @setting.save
    assert_nil @setting.reload.current_term
  end

  test 'current term must be a 6-digit number if present' do
    @setting.current_term = 201870
    @setting.save
    assert_equal @setting.reload.current_term, 201870
  end

  test 'current term fails if five digits' do
    @setting.current_term = 20187
    assert_not @setting.valid?
  end

  test 'graduate enrollment threshold cannot be null' do
    @setting.graduate_enrollment_threshold = nil
    assert_not @setting.valid?
  end

  test 'undergraduate enrollment threshold cannot be null' do
    @setting.undergraduate_enrollment_threshold = nil
    assert_not @setting.valid?
  end

  test 'email delivery cannot be null' do
    @setting.email_delivery = nil
    assert_not @setting.valid?
  end

  test 'returns valid email delivery options' do
    assert_equal Setting.email_deliveries, 'scheduled' => 0, 'off' => 1, 'on' => 2
  end

  test 'returns a list of keys from the available email delivery options' do
    assert_equal Setting.delivery_options, %w[scheduled off on]
  end
end
