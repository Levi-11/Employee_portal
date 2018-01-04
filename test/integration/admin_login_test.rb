require 'test_helper'

class AdminLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin = employees(:admin)
  end

  test "login with invalid information" do
    get adminlogin_path
    assert_template 'adminsession/new'
    post adminlogin_path, params: { session: { email: "", password: "" } }
    assert_template 'adminsession/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get adminlogin_path
    assert_template 'adminsession/new'
    post adminlogin_path, params: { session: { email:    @admin.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to adminhome_path
    follow_redirect!
    assert_template 'admin/home'
    assert_select "a[href=?]", adminemployee_path
    assert_select "a[href=?]", adminproject_path
    assert_select "a[href=?]", adminlogout_path
    delete logout_path
    assert_not is_logged_in?      
  end
end
