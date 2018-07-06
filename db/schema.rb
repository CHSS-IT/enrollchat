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

ActiveRecord::Schema.define(version: 2018_07_03_052526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "section_id"
    t.text "body"
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
    t.string "section_number"
    t.string "title"
    t.integer "credits"
    t.string "level"
    t.string "status"
    t.integer "enrollment_limit", default: 0
    t.integer "actual_enrollment", default: 0
    t.integer "cross_list_enrollment", default: 0
    t.integer "waitlist", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "canceled_at"
    t.datetime "delete_at"
    t.integer "enrollment_limit_yesterday", limit: 2, default: 0, null: false
    t.integer "actual_enrollment_yesterday", limit: 2, default: 0, null: false
    t.integer "cross_list_enrollment_yesterday", limit: 2, default: 0, null: false
    t.integer "waitlist_yesterday", limit: 2, default: 0, null: false
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
    t.boolean "admin", default: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.datetime "last_activity_check", default: -> { "now()" }
    t.string "email_preference"
    t.text "departments", default: [], array: true
    t.boolean "no_weekly_report", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
