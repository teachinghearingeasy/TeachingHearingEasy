class AddIndexToQuizzesUserId < ActiveRecord::Migration
  def change
    add_index :quizzes, :user_id
  end
end
