class AddNewUserToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :new_user, :boolean, :default => false
  end
end
