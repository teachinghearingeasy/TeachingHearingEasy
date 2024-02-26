class AddDifficultyToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :difficulty, :integer
  end
end
