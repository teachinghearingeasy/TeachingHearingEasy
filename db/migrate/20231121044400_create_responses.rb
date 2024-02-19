class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :rating
      t.text :reasoning
      t.text :feedback
      t.timestamp :created_at
    end
  end
end
