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

ActiveRecord::Schema[8.1].define(version: 2026_09_04_000001) do
  create_table "classrooms", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_classrooms_on_course_id"
    t.index ["teacher_id"], name: "index_classrooms_on_teacher_id"
    t.check_constraint "status IN ('active', 'inactive', 'completed')", name: "classrooms_status_valid"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "status IN ('active', 'inactive')", name: "courses_status_valid"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.date "enrolled_at", null: false
    t.string "status", default: "active", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_enrollments_on_classroom_id"
    t.index ["student_id", "classroom_id"], name: "index_active_enrollments_uniquely", unique: true, where: "status = 'active'"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
    t.check_constraint "status IN ('active', 'completed', 'dropped')", name: "enrollments_status_valid"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time", null: false
    t.string "meeting_link"
    t.string "room"
    t.date "schedule_date", null: false
    t.time "start_time", null: false
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_schedules_on_classroom_id"
    t.index ["teacher_id"], name: "index_schedules_on_teacher_id"
    t.check_constraint "end_time > start_time", name: "schedules_end_after_start"
  end

  create_table "student_progresses", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.text "note"
    t.date "progress_date", null: false
    t.decimal "score", precision: 5, scale: 2, null: false
    t.string "status", null: false
    t.integer "student_id", null: false
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_student_progresses_on_classroom_id"
    t.index ["student_id"], name: "index_student_progresses_on_student_id"
    t.index ["teacher_id"], name: "index_student_progresses_on_teacher_id"
    t.check_constraint "score >= 0 AND score <= 100", name: "student_progresses_score_valid"
    t.check_constraint "status IN ('excellent', 'good', 'needs_improvement', 'poor', 'completed')", name: "student_progresses_status_valid"
  end

  create_table "students", force: :cascade do |t|
    t.text "address"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.string "gender"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
    t.index ["user_id"], name: "index_students_on_user_id_unique", unique: true
    t.check_constraint "status IN ('active', 'inactive', 'graduated')", name: "students_status_valid"
  end

  create_table "teachers", force: :cascade do |t|
    t.text "address"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "specialization"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_teachers_on_user_id"
    t.index ["user_id"], name: "index_teachers_on_user_id_unique", unique: true
    t.check_constraint "status IN ('active', 'inactive')", name: "teachers_status_valid"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index "lower(email)", name: "index_users_on_lower_email", unique: true
    t.check_constraint "role IN ('admin', 'teacher', 'student')", name: "users_role_valid"
  end

  add_foreign_key "classrooms", "courses"
  add_foreign_key "classrooms", "teachers"
  add_foreign_key "enrollments", "classrooms"
  add_foreign_key "enrollments", "students"
  add_foreign_key "schedules", "classrooms"
  add_foreign_key "schedules", "teachers"
  add_foreign_key "student_progresses", "classrooms"
  add_foreign_key "student_progresses", "students"
  add_foreign_key "student_progresses", "teachers"
  add_foreign_key "students", "users"
  add_foreign_key "teachers", "users"
end
