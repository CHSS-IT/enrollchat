require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:three)
  end

  test 'should GET index for an admin user' do
    login_as users(:one)
    get users_url
    assert_response :success
  end

  test 'should not GET index for a non-admin user' do
    login_as users(:two)
    get users_url
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should GET new user for an admin user' do
    login_as users(:one)
    get new_user_url
    assert_response :success
  end

  test 'should not GET new user for a non-admin user' do
    login_as users(:two)
    get new_user_url
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should create new user with admin user' do
    login_as users(:one)
    assert_difference('User.count', + 1) do
      post users_path, params: { user: { first_name: 'Timothy', last_name: "McGee", email: 'tmcgee@test.com', username: 'tmcgee', admin: false } }
    end
    assert_redirected_to users_url
    assert_equal 'User was succesfully created', flash[:notice]
  end

  test 'should not create a new user with non-admin user' do
    login_as users(:two)
    assert_no_difference('User.count') do
      post users_path, params: { user: { first_name: 'Timothy', last_name: 'McGee', email: 'tmcgee@test.com', username: 'tmcgee', admin: false } }
    end
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should GET edit user for an admin user' do
    login_as users(:one)
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should not GET edit for a different user with a non-admin user' do
    login_as users(:two)
    get edit_user_url(@user)
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should GET edit for a non-admin user editing themself' do
    login_as users(:three)
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user for an admin user' do
    login_as users(:one)
    patch user_url(@user), params: { user: { first_name: 'New', last_name: 'Name' } }
    assert_redirected_to users_url
    assert_equal @user.reload.first_name, 'New'
    assert_equal @user.reload.last_name, 'Name'
    assert_equal 'User was succesfully updated', flash[:notice]
  end

  test 'should update the admin parameter for admin users' do
    login_as users(:one)
    patch user_url(@user), params: { user: { admin: true } }
    assert_redirected_to users_url
    assert_equal @user.reload.admin, true
    assert_equal 'User was succesfully updated', flash[:notice]
  end

  test 'should not update a different user with a non-admin user' do
    login_as users(:two)
    patch user_url(@user), params: { user: { first_name: 'New', last_name: 'Name' } }
    assert_redirected_to sections_url
    assert_not_equal @user.reload.first_name, 'New'
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should update when a non-admin user edits themself' do
    login_as users(:three)
    patch user_url(@user), params: { user: { email_preference: 'No Emails', first_name: 'New' } }
    assert_redirected_to sections_path
    assert_equal @user.reload.email_preference, 'No Emails'
    assert_equal @user.reload.first_name, 'New' # not available to the user through the UI
    assert_equal 'Preferences updated', flash[:notice]
  end

  test 'should not UPDATE admin for a user editing themselves' do
    login_as @user
    patch user_url(@user), params: { user: { admin: true } }
    assert_redirected_to sections_path
    assert_equal @user.reload.admin, false
  end

  test 'should post to checked_activities' do
    login_as @user
    post checked_activities_user_url(@user)
    assert_response :ok
  end

  test 'should not get archive for a non-admin user' do
    login_as users(:two)
    get archive_user_url(@user)
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page', flash[:notice]
  end

  test 'should get archive for an admin user' do
    login_as users(:one)
    get archive_user_url(@user)
    assert_redirected_to users_url
  end

  test 'should not update user_attributes for a non-admin user trying to archive a user' do
    login_as users(:two)
    @user.departments << 'HIST'
    @user.update_attributes(email_preference: 'Daily Digest')
    get archive_user_url(@user)
    assert_equal @user.reload.email_preference, 'Daily Digest'
    assert_equal @user.reload.no_weekly_report, false
    assert_equal @user.reload.status, 'active'
    assert_equal @user.reload.departments, ['HIST']
  end

  test 'should update user attributes when user is archived' do
    login_as users(:one)
    @user.departments << 'HIST'
    get archive_user_url(@user)
    assert_equal @user.reload.email_preference, 'No Emails'
    assert_equal @user.reload.no_weekly_report, true
    assert_equal @user.reload.status, 'archived'
    assert_equal @user.reload.departments, []
  end

  test 'should set remove admin status when archiving' do
    login_as users(:one)
    @user.admin = true
    get archive_user_url(@user)
    assert_equal @user.reload.admin, false
  end

  test 'should display the proper flash notice after archiving a user' do
    login_as users(:one)
    get archive_user_url(@user)
    assert_redirected_to users_url
    assert_equal 'User has been archived', flash[:notice]
  end

end
