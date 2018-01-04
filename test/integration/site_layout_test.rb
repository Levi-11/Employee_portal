require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @employee = employees(:example)
  end
  
  test "layout links" do
    get root_path
    assert_template 'sessions/new'
  end

  # test "employees login link" do
  #   get login_path
  #   assert_template 'sessions/new'
  #   post login_path, params: { session: { email:    @employee.email,
  #                                         password: 'password' } }
  #   assert is_logged_in?
  #   assert_redirected_to home_path
  #   assert_select 'a[href=?]', edit_employee_path(@employee)
  # end

end
