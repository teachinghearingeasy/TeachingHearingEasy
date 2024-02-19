class CreateQuizSounds < ActiveRecord::Migration
  def change
    create_table :quiz_sounds do |t|
      t.integer :quiz_id
      t.integer :sound_id
    end

    add_index :quiz_sounds, [:quiz_id, :sound_id], unique: true
  end
end
