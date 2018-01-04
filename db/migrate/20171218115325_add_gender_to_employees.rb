class AddGenderToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :gender, :string
  end
end
