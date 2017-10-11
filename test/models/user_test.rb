require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:two)
  end

  test "user is valid" do
    @user.save
    assert @user.valid?
  end

  test "user is invalid without a first name" do
    @user.first_name = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:first_name]
  end

  test "user is invalid without a last name" do
    @user.last_name = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:last_name]
  end

  test "user is invalid without an email" do
    @user.email = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:email]
  end

  test "user is invalid without an username" do
    @user.username = nil
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors.messages[:username]
  end

  test "admin defaults to false for a new user" do
    test_user = User.new(first_name: 'Test', last_name: 'User', email: 'test@mail.com', username: 'tuser')
    assert_not test_user.is_admin?
  end

  test "should create a full name for a user" do
    @user.first_name = 'Test'
    @user.last_name = 'User'
    assert @user.full_name == 'Test User'
  end

  test "should determine if a user is an admin" do
    @user.admin = true
    assert @user.is_admin?
    @user.admin = false
    assert_not @user.is_admin?
  end
end
