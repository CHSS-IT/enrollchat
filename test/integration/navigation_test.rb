require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @user = users(:two)
  end

  teardown do
    logout
  end

  test 'Users navigation link should be available for admins' do
    login_as(@admin)
    get sections_url
    assert_select 'li', text: 'Users', count: 1
  end

  test 'Users navigation link should not be available for non-admins' do
    @section = sections(:one)
    login_as(@user)
    get sections_url
    assert_select 'li', text: 'Users', count: 0
  end

  test 'Preferences navigation link should be available for non-admin' do
    login_as(@user)
    get sections_url
    assert_select 'li', text: 'Preferences', count: 1
  end

  test 'Preferences navigation link should not show for admins' do
    login_as(@admin)
    get sections_url
    assert_select 'li', text: 'Preferences', count: 0
  end
end
