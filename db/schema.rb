# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20240215211302) do

  create_table "groups", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "join_token"
    t.integer "owner"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"

  create_table "quiz_sounds", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "sound_id"
  end

  add_index "quiz_sounds", ["quiz_id", "sound_id"], name: "index_quiz_sounds_on_quiz_id_and_sound_id", unique: true

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.integer  "user_id"
    t.string   "which_grbas_letter"
    t.text     "quiz_answers"
    t.integer  "difficulty"
    t.integer  "num_questions"
  end

  add_index "quizzes", ["user_id"], name: "index_quizzes_on_user_id"

  create_table "quizzes_responses", id: false, force: :cascade do |t|
    t.integer "quiz_id",     null: false
    t.integer "response_id", null: false
  end

  add_index "quizzes_responses", ["quiz_id", "response_id"], name: "index_quizzes_responses_on_quiz_id_and_response_id"

  create_table "quizzes_users", id: false, force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "user_id", null: false
  end

  add_index "quizzes_users", ["quiz_id", "user_id"], name: "index_quizzes_users_on_quiz_id_and_user_id"
  add_index "quizzes_users", ["user_id", "quiz_id"], name: "index_quizzes_users_on_user_id_and_quiz_id"

  create_table "responses", force: :cascade do |t|
    t.integer  "rating"
    t.text     "reasoning"
    t.text     "feedback"
    t.datetime "created_at"
    t.integer  "quiz_id"
    t.integer  "sound_id"
    t.integer  "user_id"
  end

  add_index "responses", ["quiz_id"], name: "index_responses_on_quiz_id"
  add_index "responses", ["sound_id"], name: "index_responses_on_sound_id"
  add_index "responses", ["user_id"], name: "index_responses_on_user_id"

  create_table "sounds", force: :cascade do |t|
    t.integer "sound_id"
    t.string  "db_file_name"
    t.text    "score_explanation"
    t.text    "hint"
    t.float   "g_rating"
    t.float   "r_rating"
    t.float   "b_rating"
    t.float   "a_rating"
    t.float   "s_rating"
    t.text    "audio_file_path"
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

end
