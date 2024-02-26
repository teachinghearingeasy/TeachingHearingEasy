class AddIntegerArrayToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :quiz_answers, :text
  end
end
