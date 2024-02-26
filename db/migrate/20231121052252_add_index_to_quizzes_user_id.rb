class AddIndexToQuizzesUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :quizzes, :user_id
  end
end
