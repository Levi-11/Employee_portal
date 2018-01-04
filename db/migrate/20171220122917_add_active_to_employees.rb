class AddActiveToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :active, :boolean
  end
end
