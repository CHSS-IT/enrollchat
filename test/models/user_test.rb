require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:one)
    @admin = users(:one)
    @user = users(:two)
  end

  test 'user is valid' do
    @user.save
    assert @user.valid?
  end

  test 'user is invalid without a first name' do
    @user.first_name = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:first_name]
  end

  test 'user is invalid without a last name' do
    @user.last_name = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:last_name]
  end

  test 'user is invalid without an email' do
    @user.email = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:email]
  end

  test 'user is invalid without an username' do
    @user.username = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:username]
  end

  test 'admin defaults to false for a new user' do
    test_user = User.new(first_name: 'Test', last_name: 'User', email: 'test@mail.com', username: 'tuser')
    assert_not test_user.is_admin?
  end

  test 'should create a full name for a user' do
    @user.first_name = 'Test'
    @user.last_name = 'User'
    assert @user.full_name, 'Test User'
  end

  test 'should determine if a user is an admin' do
    @user.admin = true
    assert @user.is_admin?
    @user.admin = false
    assert_not @user.is_admin?
  end

  test 'should find users by department' do
    assert_equal User.in_department('PHIL'), [@admin, @user]
  end

  test 'should find users wanting comment emails' do
    assert_equal User.wanting_comment_emails.to_a, [@admin]
  end

  test 'should find users wanting digest emails' do
    assert_equal User.wanting_digest.to_a, [@user]
  end

  test 'should determine if a user receives alerts for a department' do
    assert @user.show_alerts('PHIL')
  end

  test 'admin should receive alerts for all departments' do
    assert @admin.show_alerts('SINT')
    assert @admin.show_alerts('BIS')
    assert @admin.show_alerts('PHIL')
  end

  test 'updates the last_activity_check for a user' do
    previous_activity_check = @user.last_activity_check
    @user.checked_activities!
    assert_not_equal @user.reload.last_name, previous_activity_check
  end

  test 'user is invalid without a status' do
    @user.status = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:status]
  end

  test 'returns valid statuses for a User' do
    assert_equal User.statuses, 'active' => 0, 'archived' => 1
  end

  test "status defaults to 'active' for a new user" do
    test_user = User.new(first_name: 'Test', last_name: 'User', email: 'test@mail.com', username: 'tuser')
    assert_equal test_user.status, 'active'
  end

  test 'returns a list of keys from the available statuses' do
    assert_equal User.status_list, %w[active archived]
  end

  test 'updates user login status' do
    @user.update(last_sign_in_at: "2018-10-15 01:00:00")
    @user.update(current_sign_in_at: "2018-10-15 01:00:00")
    @user.update(sign_in_count: 1)
    old_updated_at = @user.updated_at
    request = Minitest::Mock.new
    request.expect :remote_ip, "127.0.0.1"
    travel_to Time.zone.local(2019, 1, 15, 3, 0, 0) do
      @user.update_login_stats!(request)
      assert_equal @user.last_sign_in_at, "2018-10-15 01:00:00"
      assert_equal @user.current_sign_in_at, "2019-01-15 03:00:00"
      assert_equal @user.sign_in_count, 2
      assert_includes @user.last_sign_in_ip, "127.0.0.1"
      assert_includes @user.current_sign_in_ip, "127.0.0.1"
      assert @user.active_session, true
      assert_equal @user.updated_at, old_updated_at
    end
  end
end
