class AddDateofjoinToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :dateofjoin, :date
  end
end
