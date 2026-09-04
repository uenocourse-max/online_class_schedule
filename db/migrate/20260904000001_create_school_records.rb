class CreateSchoolRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |table|
      table.references :user, null: false, foreign_key: true
      table.string :name, null: false
      table.string :phone
      table.text :address
      table.date :birth_date
      table.string :gender
      table.string :status, null: false, default: "active"
      table.text :notes
      table.timestamps
    end
    add_index :students, :user_id, unique: true, name: "index_students_on_user_id_unique"
    add_check_constraint :students, "status IN ('active', 'inactive', 'graduated')", name: "students_status_valid"

    create_table :teachers do |table|
      table.references :user, null: false, foreign_key: true
      table.string :name, null: false
      table.string :phone
      table.text :address
      table.string :specialization
      table.string :status, null: false, default: "active"
      table.text :bio
      table.timestamps
    end
    add_index :teachers, :user_id, unique: true, name: "index_teachers_on_user_id_unique"
    add_check_constraint :teachers, "status IN ('active', 'inactive')", name: "teachers_status_valid"

    create_table :courses do |table|
      table.string :name, null: false
      table.text :description
      table.string :status, null: false, default: "active"
      table.timestamps
    end
    add_check_constraint :courses, "status IN ('active', 'inactive')", name: "courses_status_valid"

    create_table :classrooms do |table|
      table.string :name, null: false
      table.references :course, null: false, foreign_key: true
      table.references :teacher, null: false, foreign_key: true
      table.string :status, null: false, default: "active"
      table.text :description
      table.timestamps
    end
    add_check_constraint :classrooms, "status IN ('active', 'inactive', 'completed')", name: "classrooms_status_valid"

    create_table :enrollments do |table|
      table.references :student, null: false, foreign_key: true
      table.references :classroom, null: false, foreign_key: true
      table.date :enrolled_at, null: false
      table.string :status, null: false, default: "active"
      table.timestamps
    end
    add_index :enrollments, [ :student_id, :classroom_id ], where: "status = 'active'", unique: true, name: "index_active_enrollments_uniquely"
    add_check_constraint :enrollments, "status IN ('active', 'completed', 'dropped')", name: "enrollments_status_valid"

    create_table :schedules do |table|
      table.references :classroom, null: false, foreign_key: true
      table.references :teacher, null: false, foreign_key: true
      table.date :schedule_date, null: false
      table.time :start_time, null: false
      table.time :end_time, null: false
      table.string :room
      table.string :meeting_link
      table.timestamps
    end
    add_check_constraint :schedules, "end_time > start_time", name: "schedules_end_after_start"

    create_table :student_progresses do |table|
      table.references :student, null: false, foreign_key: true
      table.references :classroom, null: false, foreign_key: true
      table.references :teacher, null: false, foreign_key: true
      table.date :progress_date, null: false
      table.decimal :score, precision: 5, scale: 2, null: false
      table.string :status, null: false
      table.text :note
      table.timestamps
    end
    add_check_constraint :student_progresses, "score >= 0 AND score <= 100", name: "student_progresses_score_valid"
    add_check_constraint :student_progresses, "status IN ('excellent', 'good', 'needs_improvement', 'poor', 'completed')", name: "student_progresses_status_valid"
  end
end
