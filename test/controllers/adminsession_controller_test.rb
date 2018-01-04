require 'test_helper'

class AdminsessionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get adminlogin_path
    assert_response :success
  end
end
