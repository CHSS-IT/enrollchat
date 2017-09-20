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

ActiveRecord::Schema.define(version: 20170920191526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "section_id"
    t.text "body"
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_comments_on_section_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "owner"
    t.integer "term"
    t.integer "section_id"
    t.string "department"
    t.string "cross_list_group"
    t.string "course_description"
    t.integer "section_number"
    t.string "title"
    t.integer "credits"
    t.string "level"
    t.string "status"
    t.integer "enrollment_limit"
    t.integer "actual_enrollment"
    t.integer "cross_list_enrollment"
    t.integer "waitlist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "sections"
  add_foreign_key "comments", "users"
end
