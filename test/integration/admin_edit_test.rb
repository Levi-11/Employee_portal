require 'test_helper'

class AdminEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = employees(:admin)
    @employee = employees(:example)
  end
  test "uncessfull" do
  get adminlogin_path
    post adminlogin_path, params: { session: { email: @admin.email,
                                          password: 'password' } }
    get adminedit_path(:id => @employee.id)
    assert_template 'admin/edit'
    patch adminedit_path(:id => @employee.id), params: { employee: { 
                                              email: "foo@invalid",
                                              designation:"foo",
                                              dateofjoin:"qwe",
                                              gender: "que",
                                              address: "invalid",
                                              active: "new" } }
  assert_redirected_to adminedit_path
  end
  test "sucessfull" do
    get adminlogin_path
      post adminlogin_path, params: { session: { email: @admin.email,
                                            password: 'password' } }
      get adminedit_path(:id => @employee.id)
      assert_template 'admin/edit'
      patch adminedit_path(:id => @employee.id), params: { employee: { 
                                                email: "foo@invalid.com",
                                                designation:"foobar",
                                                dateofjoin:"12/11/2017",
                                                gender: "male",
                                                address: "invalid, invalid city,invalid square",
                                                active: "true" } }
    assert_redirected_to adminemployee_path
    end
end
