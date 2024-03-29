class AddQuizUserSoundIndexToResponse < ActiveRecord::Migration[7.1]
  def change
    add_reference :responses, :quiz, index: true, foreign_key: true
    add_reference :responses, :sound, index: true, foreign_key: true
    add_reference :responses, :user, index: true, foreign_key: true
  end
end
