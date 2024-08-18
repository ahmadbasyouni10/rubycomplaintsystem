class AddIsUserCreatedToComplaints < ActiveRecord::Migration[7.2]
  def change
    add_column :complaints, :is_user_created, :boolean, default: false, null: false
    add_index :complaints, :is_user_created
  end
end