class CreateJoinTableQuizResponse < ActiveRecord::Migration
  def change
    create_join_table :quizzes, :responses do |t|
      t.index [:quiz_id, :response_id]
    end
  end
end
