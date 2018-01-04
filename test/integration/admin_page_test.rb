require 'test_helper'

class AdminPageTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:example)
  end
  test "paginate" do
    log_in_as(@employee)
    get adminemployee_path
    assert_template 'admin/index'
    assert_select 'div.pagination'
    Employee.paginate(page: 1, per_page: 2).each do |employee|
      assert_select 'a[href=?]', showemployee_path(:id => employee.id), text: employee.name if employee.admin.nil?
    end
  end
end
