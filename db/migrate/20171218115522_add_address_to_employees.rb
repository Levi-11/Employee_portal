class AddAddressToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :address, :string
  end
end
