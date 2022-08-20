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

ActiveRecord::Schema[7.0].define(version: 2022_08_20_203515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "section_id"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["section_id"], name: "index_comments_on_section_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "section_id"
    t.string "department"
    t.integer "term"
    t.integer "enrollment_limit", default: 0
    t.integer "actual_enrollment", default: 0
    t.integer "cross_list_enrollment", default: 0
    t.integer "waitlist", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["section_id"], name: "index_enrollments_on_section_id"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "canceled_at", precision: nil
    t.datetime "delete_at", precision: nil
    t.integer "enrollment_limit_yesterday", limit: 2, default: 0, null: false
    t.integer "actual_enrollment_yesterday", limit: 2, default: 0, null: false
    t.integer "cross_list_enrollment_yesterday", limit: 2, default: 0, null: false
    t.integer "waitlist_yesterday", limit: 2, default: 0, null: false
    t.boolean "resolved_section", default: false
    t.string "chssweb_title"
    t.boolean "description_present"
    t.boolean "syllabus_present"
    t.boolean "image_present"
    t.boolean "youtube_present"
    t.string "modality"
    t.string "modality_description"
    t.string "print_flag"
    t.string "instructor_name"
    t.string "second_instructor_name"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "current_term"
    t.integer "singleton_guard", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "graduate_enrollment_threshold", default: 10
    t.integer "undergraduate_enrollment_threshold", default: 15
    t.integer "email_delivery", default: 0
    t.string "data_feed_uri"
    t.index ["singleton_guard"], name: "index_settings_on_singleton_guard", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "username", null: false
    t.boolean "admin", default: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.datetime "last_activity_check", precision: nil, default: -> { "now()" }
    t.string "email_preference"
    t.text "departments", default: [], array: true
    t.boolean "no_weekly_report", default: false, null: false
    t.integer "status", default: 0, null: false
    t.boolean "active_session", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
