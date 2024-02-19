class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :music_experience
      t.string :clinical_experience
      t.string :general_education
      t.string :session_token
      t.string :access_level
    end
  end
end
