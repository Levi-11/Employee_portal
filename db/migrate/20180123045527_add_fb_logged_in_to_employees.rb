class AddFbLoggedInToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :fb_logged_in, :boolean
  end
end
