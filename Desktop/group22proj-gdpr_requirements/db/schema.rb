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

ActiveRecord::Schema.define(version: 2020_05_25_190128) do

  create_table "contests", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.integer "payout_amount", default: 0
    t.datetime "start_date"
    t.datetime "ending_date"
    t.boolean "is_student_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "first_prize"
    t.integer "second_prize"
    t.integer "third_prize"
    t.integer "first_place"
    t.integer "second_place"
    t.integer "third_place"
    t.boolean "paid_for", default: false
    t.boolean "evaluated", default: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "contest_id"
    t.float "share_of_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "username"
    t.boolean "is_student"
    t.string "student_email"
    t.integer "contests_won", default: 0, null: false
    t.integer "contests_entered", default: 0, null: false
    t.string "stripe_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "link"
    t.string "title"
    t.datetime "published_at"
    t.integer "likes"
    t.integer "dislikes"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contest_id"
    t.index ["uid"], name: "index_videos_on_uid"
  end

  create_table "yt_users", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_yt_users_on_uid", unique: true
  end

end
