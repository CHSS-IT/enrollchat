require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting = settings(:one)
  end

  test 'should GET home' do
    get home_url
    assert_response :success
  end

  test 'should GET unregistered' do
    get unregistered_url
    assert_response :success
  end
end
