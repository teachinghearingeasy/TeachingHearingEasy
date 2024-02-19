class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.integer "sound_id"
      t.string "db_file_name"
      t.text "score_explanation"
      t.text "hint"
      t.integer "g_rating"
      t.integer "r_rating"
      t.integer "b_rating"
      t.integer "a_rating"
      t.integer "s_rating"
      t.text "audio_file_path"
    end
  end
end
