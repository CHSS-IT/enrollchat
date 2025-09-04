require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @admin = users(:one)
    @user = users(:three)
  end

  teardown do
    logout
  end

  test 'admin visits the index' do
    login_as(@admin)
    visit users_url
    assert_selector 'h1', text: 'Users'
    assert page.has_css?('table tbody tr', count: 3)
  end

  test "admin updates user's email preference" do
    assert_equal @user.email_preference, 'No Emails'
    login_as(@admin)
    visit edit_user_url(@user)
    select 'Comments and Digest', from: 'user_email_preference'
    click_button 'Save'
    assert_selector 'table tbody tr td', text: 'Comments and Digest'
    assert_equal @user.reload.email_preference, 'Comments and Digest'
  end

  test 'user updates their own email preference' do
    assert_equal @user.email_preference, 'No Emails'
    login_as(@user)
    visit edit_user_url(@user)
    select 'Comments and Digest', from: 'user_email_preference'
    click_button 'Save'
    assert_equal @user.reload.email_preference, 'Comments and Digest'
  end

  test "admin updates user's departments" do
    assert_equal @user.departments, []
    login_as(@admin)
    visit edit_user_url(@user)
    select 'CRIM', from: 'user_departments'
    select 'SINT', from: 'user_departments'
    click_button 'Save'
    assert_selector 'table tbody tr td', text: 'CRIM, SINT'
    assert_equal @user.reload.departments, %w[CRIM SINT]
  end

  test 'user updates their own departments' do
    assert_equal @user.departments, []
    login_as(@user)
    visit edit_user_url(@user)
    select 'CRIM', from: 'user_departments'
    select 'SINT', from: 'user_departments'
    click_button 'Save'
    assert_equal @user.reload.departments, %w[CRIM SINT]
  end
end
