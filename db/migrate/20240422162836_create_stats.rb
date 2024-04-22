class CreateStats < ActiveRecord::Migration[7.1]
  def change
    create_table :stats do |t|
      t.belongs_to :user
      t.string :progress_level, :default => "beginner"
      t.string :total_answers, :default => "0/0"
      t.timestamps
    end
  end
end
