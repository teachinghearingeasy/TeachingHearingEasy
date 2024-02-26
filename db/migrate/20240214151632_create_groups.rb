class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :join_token
      t.integer :owner
    end
  end
end
