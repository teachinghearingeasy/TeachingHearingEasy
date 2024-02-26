class CreateJoinTableQuizzesUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :quizzes, :users do |t|
      t.index [:quiz_id, :user_id]
      t.index [:user_id, :quiz_id]
    end
  end
end
