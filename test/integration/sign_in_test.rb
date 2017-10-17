require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest

  test "should redirect users who are not signed in to login page" do
    get sections_url
    assert_redirected_to new_user_session_url
  end

  test "should allow successfully signed in users to reach main sections page" do
    login_as users(:two)
    get sections_url
    assert_response :success
    assert_select "a", "EnrollChat"
  end

  test "should send unregistered users to unregistered page" do
    skip('need to figure out how to define an unregistered user')
    get sections_url
    assert_redirected_to unregistered_user_session
  end
end
