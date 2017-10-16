require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @user = users(:two)
  end

  test 'Users navigation link should be available for admins' do
    login_as @admin
    get root_url
    assert_select "li", text: "Users", count: 1
  end

  test 'Users navigation link should not be available for non-admins' do
    login_as @user
    get root_url
    assert_select 'li', text: 'Users', count: 0
  end
end
