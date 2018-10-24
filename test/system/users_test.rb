require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @admin = users(:one)
  end

  test 'admin visits the index' do
    login_as @admin
    visit users_path
    assert_selector 'h1', text: 'Users'
    assert page.has_css?('table tbody tr', count: 3)
  end
end
