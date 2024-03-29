# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_20_231623) do
  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "join_token"
    t.integer "owner"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
  end

  create_table "quiz_sounds", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "sound_id"
    t.index ["quiz_id", "sound_id"], name: "index_quiz_sounds_on_quiz_id_and_sound_id", unique: true
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "user_id"
    t.string "which_grbas_letter"
    t.text "quiz_answers"
    t.integer "difficulty"
    t.integer "num_questions"
    t.boolean "completed"
    t.integer "num_right"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "quizzes_responses", id: false, force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "response_id", null: false
    t.index ["quiz_id", "response_id"], name: "index_quizzes_responses_on_quiz_id_and_response_id"
  end

  create_table "quizzes_users", id: false, force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "user_id", null: false
    t.index ["quiz_id", "user_id"], name: "index_quizzes_users_on_quiz_id_and_user_id"
    t.index ["user_id", "quiz_id"], name: "index_quizzes_users_on_user_id_and_quiz_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "g_rating"
    t.text "reasoning"
    t.text "feedback"
    t.datetime "created_at"
    t.integer "quiz_id"
    t.integer "sound_id"
    t.integer "user_id"
    t.integer "r_rating"
    t.integer "b_rating"
    t.integer "a_rating"
    t.integer "s_rating"
    t.index ["quiz_id"], name: "index_responses_on_quiz_id"
    t.index ["sound_id"], name: "index_responses_on_sound_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "sounds", force: :cascade do |t|
    t.integer "sound_id"
    t.string "db_file_name"
    t.text "score_explanation"
    t.text "hint"
    t.float "g_rating"
    t.float "r_rating"
    t.float "b_rating"
    t.float "a_rating"
    t.float "s_rating"
    t.text "audio_file_path"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "music_experience"
    t.string "clinical_experience"
    t.string "general_education"
    t.string "session_token"
    t.string "access_level"
  end

  add_foreign_key "responses", "quizzes"
  add_foreign_key "responses", "sounds"
  add_foreign_key "responses", "users"
end
