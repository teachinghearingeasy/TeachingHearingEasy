class AddIntegerArrayToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :quiz_answers, :text
  end
end
