require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test 'should GET index' do
    login_as users(:one)
    get reports_url
    assert_response :success
  end
end
