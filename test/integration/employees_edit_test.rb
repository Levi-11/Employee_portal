require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:example)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :personalemail => 'lvaguez@gmail.com',
      :dateofbirth => '17/04/1993'
      # etc.
    })
  end

  test "unsuccessful edit" do    
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]', auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    patch employee_path(@employee), params: { employee: { 
                                              email: "foo@invalid",
                                              designation:"foo",
                                              dateofjoin:"qwe",
                                              dateofbirth:"tyu",
                                              personalemail:"foo@invalid",
                                              username:"user" } }
 
    assert @employee
  end

  test "successful edit" do  
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]', auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    email = "foo@bar.com"
    designation="developer",
    dateofjoin="12/11/2017",
    dateofbirth="10/12/1994",
    personalemail="foo@bar.com"
    username="foobar"
    patch employee_path(@employee), params: { employee: { 
                                              email: email,
                                              designation:designation,
                                              dateofjoin:dateofjoin,
                                              dateofbirth:dateofbirth,
                                              personalemail:personalemail,
                                              username:username } }
    assert_not flash.empty?
    assert_redirected_to home_path
    @employee.reload 
  end
end