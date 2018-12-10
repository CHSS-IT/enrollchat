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

end
