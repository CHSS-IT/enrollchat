require 'test_helper'

class ReportsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    login_as @user
  end

end
