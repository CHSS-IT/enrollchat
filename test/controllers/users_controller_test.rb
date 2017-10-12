require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:three)
  end

  test "should GET index for an admin user" do
    login_as users(:one)
    get users_url
    assert_response :success
  end

  test "should not GET index for a non-admin user" do
    login_as users(:two)
    get users_url
    assert_redirected_to root_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test "should GET new user for an admin user" do
    login_as users(:one)
    get new_user_url
    assert_response :success
  end

  test "should not GET new user for a non-admin user" do
    login_as users(:two)
    get new_user_url
    assert_redirected_to root_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test "should create new user with admin user" do
    login_as users(:one)
    assert_difference('User.count', + 1) do
      post users_path, params: { user: { first_name: 'Timothy', last_name: "McGee", email: "tmcgee@test.com", username: 'tmcgee', admin: false } }
    end
    assert_redirected_to users_url
    assert_equal 'User was succesfully created', flash[:notice]
  end

  test "invalid user should not be created" do
    login_as users(:one)
    assert_no_difference('User.count') do
      post users_path, params: { user: { first_name: 'Timothy', last_name: "McGee", email: "tmcgee@test.com", admin: false } }
    end
    assert_redirected_to new_user_url
    assert_equal 'Error: Could not create user', flash[:notice]
  end

  test "should not create a new user with non-admin user" do
    login_as users(:two)
    assert_no_difference('User.count') do
      post users_path, params: { user: { first_name: 'Timothy', last_name: "McGee", email: "tmcgee@test.com", username: 'tmcgee', admin: false } }
    end
    assert_redirected_to root_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test "should GET edit user" do
    login_as users(:one)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should not GET edit user with a non-admin user" do
    login_as users(:two)
    get edit_user_url(@user)
    assert_redirected_to root_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test "should update user" do
    login_as users(:one)
    patch user_url(@user), params: { user: { first_name: 'New', last_name: 'Name' } }
    assert_redirected_to users_url
    assert @user.first_name = 'New'
    assert_equal 'User was succesfully updated', flash[:notice]
  end

  test "should not update user with a non-admin user" do
    login_as users(:two)
    patch user_url(@user), params: { user: { first_name: 'New', last_name: 'Name' } }
    assert_redirected_to root_url
    assert @user.first_name = 'Timothy'
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test "should not allow a user to be made invalidated by update" do
    login_as users(:one)
    patch user_url(@user), params: { user: { first_name: 'New', last_name: nil } }
    assert_redirected_to edit_user_url(@user)
    assert_equal 'Error: Could not update user', flash[:notice]
  end

end
