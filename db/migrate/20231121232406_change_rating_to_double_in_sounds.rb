class ChangeRatingToDoubleInSounds < ActiveRecord::Migration[7.1]
  def change
    change_column :sounds, :g_rating, :float
    change_column :sounds, :r_rating, :float
    change_column :sounds, :b_rating, :float
    change_column :sounds, :a_rating, :float
    change_column :sounds, :s_rating, :float
  end
end
