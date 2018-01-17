require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @employee = employees(:example)
    @admin = employees (:admin)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :personalemail => 'lvaguez@gmail.com',
      :dateofbirth => '17/04/1993'
      # etc.
    })
  end
  
  test "layout links" do
    get root_path
    assert_template 'sessions/new'
  end

  test "employees login link" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to home_path
    get home_path
    assert_select 'a[href=?]', edit_employee_path(@employee)
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', home_path
    get edit_employee_path(@employee)
    assert_select 'a[href=?]', auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
  end
  test "admin login link" do
    get adminlogin_path
    assert_template 'adminsession/new'
    post adminlogin_path, params: { session: { email:    @admin.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert is_admin_logged_in?(@admin)
    assert_redirected_to adminhome_path
    get adminhome_path
    assert_select 'a[href=?]', adminemployee_path
    assert_select 'a[href=?]', adminhome_path
    assert_select 'a[href=?]', adminproject_path
    assert_select 'a[href=?]', adminlogout_path
    assert_select 'a[href=?]', adminhome_path
  end

end
