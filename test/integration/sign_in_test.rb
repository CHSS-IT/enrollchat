require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest

  test "should redirect users who are not signed in to login page" do
    get root_url
    assert_redirected_to new_user_session_url
  end

  test "should allow successfully signed in users to reach home page" do
    login_as users(:two)
    get root_url
    assert_response :success
    assert_select "a", "EnrollChat"
  end

  test "should send unregistered users to unregistered page" do
    skip('may be better to send all logged out users to a landing page - see task in asana')
  end
end
