require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should GET home" do
    get static_pages_home_url
    assert_response :success
  end

end
