require 'test_helper'

class EmployeesSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get addemployee_path
    assert_no_difference 'Employee.count' do
      post addemployee_path, params: { employee: { name:  "",
                                         email: "user@invalid",
                                         designation:"qaz",
                                         phone:"123aw12902",
                                         gender:"m",
                                         dateofjoin:"12/11/2017",
                                         address:"qwerty",
                                         active:"j",
                                         username:"user",
                                         password:"foo",
                                         password_confirmation:"bar" } }
    end
    assert_redirected_to addemployee_path
  end

  test "valid signup information" do
    get addemployee_path
    assert_difference 'Employee.count', 1 do
    post addemployee_path, params: { employee: { name:  "Example User",
                                        email: "user@example.com",
                                        designation:"tester",
                                        phone:"1234567890",
                                        gender:"male",
                                        dateofjoin:"12/11/2017",
                                        address:"qwerty",
                                        active:"true",
                                        username:"username",
                                        password:"password",
                                        password_confirmation:"password" } }
    end
    follow_redirect!
    assert_template 'admin/index'
    assert is_logged_in?
  end
end
