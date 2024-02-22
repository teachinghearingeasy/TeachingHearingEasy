class ChangeResponsesForGrbasRating < ActiveRecord::Migration[7.1]
  def change
    rename_column :responses, :rating, :g_rating
    add_column :responses, :r_rating, :integer
    add_column :responses, :b_rating, :integer
    add_column :responses, :a_rating, :integer
    add_column :responses, :s_rating, :integer
  end
end
