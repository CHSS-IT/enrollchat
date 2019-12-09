require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test 'should GET end_session as logout for a logged in user' do
    login_as(users(:three))
    @current_user = users(:three)
    get logout_url
    assert_redirected_to '/logout'
  end

  test 'sets active_session for current user to false' do
    login_as(users(:three))
    @current_user = users(:three)
    @current_user.update(active_session: true)
    get logout_url
    assert_equal @current_user.reload.active_session, false
  end

  test 'does not change update_at when setting the active_session attribute' do
    login_as(users(:three))
    @current_user = users(:three)
    @current_user.update(active_session: true)
    old_updated_at = @current_user.updated_at
    get logout_url
    assert_equal @current_user.reload.updated_at, old_updated_at
  end


end

