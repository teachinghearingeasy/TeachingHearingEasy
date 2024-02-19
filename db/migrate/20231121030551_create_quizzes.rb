class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.timestamp "created_at", null: false
      t.integer "user_id"
      t.string "which_grbas_letter"
    end
  end
end
