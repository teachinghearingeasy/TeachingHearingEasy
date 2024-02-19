class AddNumQuestionsToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :num_questions, :integer
  end
end
