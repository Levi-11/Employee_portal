class AddColumnsToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :fb_name, :string
    add_column :employees, :fb_birthday, :date
    add_column :employees, :fb_email, :string
    add_column :employees, :picture, :string
    add_column :employees, :home_town, :string
    add_column :employees, :fb_posts, :string
    add_column :employees, :fb_location, :string
  end
end
