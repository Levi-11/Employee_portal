require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  def setup
    @employee = Employee.new(name: "Example User", email: "user@example.com",
                     designation:"tester",phone:"1234567890",gender:"male",
                     dateofjoin:"12/11/2017",address:"qwerty",active:"true",
                     username:"username",password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @employee.valid?
  end

  test "name should be present" do
    @employee.name = "     "
    assert_not @employee.valid?
  end

  test "email should be present" do
    @employee.email = "     "
    assert_not @employee.valid?
  end

  test "name should not be too long" do
    @employee.name = "a" * 51
    assert_not @employee.valid?
  end

  test "email should not be too long" do
    @employee.email = "a" * 244 + "@example.com"
    assert_not @employee.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @employee.email = valid_address
      assert @employee.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @employee.email = invalid_address
      assert_not @employee.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_employee = @employee.dup
    duplicate_employee.email = @employee.email.upcase
    @employee.save
    assert_not duplicate_employee.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @employee.email = mixed_case_email
    @employee.save
    assert_equal mixed_case_email.downcase, @employee.reload.email
  end

  

  test "authenticated? should return false for an employee with nil digest" do
    assert_not @employee.authenticated?('')
  end


end
