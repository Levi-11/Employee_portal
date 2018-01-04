class AddDateofbirthToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :dateofbirth, :date
  end
end
