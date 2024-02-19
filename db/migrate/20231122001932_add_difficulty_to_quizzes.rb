class AddDifficultyToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :difficulty, :integer
  end
end
