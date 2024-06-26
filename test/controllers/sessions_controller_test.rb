require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:three))
  end

  test 'should GET end_session as logout for a logged in user' do
    get logout_url
    assert_redirected_to '/logout'
  end

  test 'sets active_session for current user to false' do
    @user = users(:three)
    @user.update(active_session: true)
    get logout_url
    assert_equal @user.reload.active_session, false
  end

  test 'does not change update_at when setting the active_session attribute' do
    @user = users(:three)
    @user.update(active_session: true)
    old_updated_at = @user.updated_at
    get logout_url
    assert_in_delta @user.reload.updated_at, old_updated_at, 1.second
  end

  test 'destroy action redirects to the root path' do
    get '/logout'
    assert_redirected_to root_path
  end
end
