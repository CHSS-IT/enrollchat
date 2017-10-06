require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    login_as users(:one)
  end

  test "should GET index" do
    get users_url
    assert_response :success
  end

  test "should GET new user" do
    get new_user_url
    assert_response :success
  end

  test "should create new user" do
    assert_difference('User.count') do
      post users_path, params: { user: { first_name: 'Timothy', last_name: "McGee", email: "tmcgee@test.com", username: 'tmcgee', admin: false } }
    end
    assert_redirected_to users_url
  end

  test "should GET edit user" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { first_name: 'New', last_name: 'Name' } }
    assert_redirected_to users_url
  end
end
