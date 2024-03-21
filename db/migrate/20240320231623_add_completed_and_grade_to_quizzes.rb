class AddCompletedAndGradeToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :completed, :boolean
    add_column :quizzes, :num_right, :integer
  end
end
