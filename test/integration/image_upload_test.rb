require 'test_helper'

class ImageUploadTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:example)
  end

  test "image upload" do
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'input[type=file]'
    picture = fixture_file_upload('test/fixtures/files/NeverEver.jpg', 'image/png')
    # assert_difference 'Employee.count', 1 do
      patch employee_path(@employee), params: {employee: {picture: picture}}
    # end
    assert @employee.image.blank?

  end
end
