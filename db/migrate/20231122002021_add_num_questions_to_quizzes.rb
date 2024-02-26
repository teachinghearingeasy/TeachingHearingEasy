class AddNumQuestionsToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :num_questions, :integer
  end
end
