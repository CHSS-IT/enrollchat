require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @user = users(:two)
  end

  test 'Users navigation link should be available for admins' do
    login_as @admin
    get sections_url
    assert_select 'li', text: 'Users', count: 1
  end

  test 'Users navigation link should not be available for non-admins' do
    login_as @user
    get sections_url
    assert_select 'li', text: 'Users', count: 0
  end

  test "File upload interface should be available for admins" do
    login_as @admin
    get sections_url
    assert_select 'form', id: 'update-form', count: 1
  end

  test "File upload interface should not be available for non-admins" do
    login_as @user
    get sections_url
    assert_select 'form', id: 'update-form', count: 0
  end
end
