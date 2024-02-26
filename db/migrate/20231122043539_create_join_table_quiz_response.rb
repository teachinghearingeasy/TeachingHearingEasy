class CreateJoinTableQuizResponse < ActiveRecord::Migration[7.1]
  def change
    create_join_table :quizzes, :responses do |t|
      t.index [:quiz_id, :response_id]
    end
  end
end
