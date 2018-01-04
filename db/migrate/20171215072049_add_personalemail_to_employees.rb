class AddPersonalemailToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :personalemail, :string
  end
end
