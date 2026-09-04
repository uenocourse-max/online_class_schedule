require "test_helper"

class SchoolModelsTest < ActiveSupport::TestCase
  setup do
    @admin = User.create!(email: "admin@example.com", password: "password", role: "admin")
    @teacher_user = User.create!(email: "teacher@example.com", password: "password", role: "teacher")
    @student_user = User.create!(email: "student@example.com", password: "password", role: "student")
    @teacher = Teacher.create!(user: @teacher_user, name: "Tanaka", status: "active")
    @student = Student.create!(user: @student_user, name: "Budi", status: "active")
    @course = Course.create!(name: "Japanese N4", status: "active")
    @classroom = Classroom.create!(name: "N4 Morning", course: @course, teacher: @teacher, status: "active")
  end

  test "user authenticates with a secure password and normalizes email" do
    assert_equal "admin@example.com", @admin.email
    assert_equal @admin, @admin.authenticate("password")
    assert_not @admin.authenticate("wrong-password")
  end

  test "profiles belong to users and classrooms connect students through enrollments" do
    enrollment = Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")

    assert_equal @student, enrollment.student
    assert_includes @classroom.students, @student
    assert_includes @student.classrooms, @classroom
    assert_includes @teacher.classrooms, @classroom
  end

  test "active enrollment is unique for a student and classroom" do
    Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")
    duplicate = Enrollment.new(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:base], "student is already actively enrolled in this classroom"
  end

  test "a completed enrollment can follow an active enrollment" do
    Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "completed")
    active_enrollment = Enrollment.new(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")

    assert active_enrollment.valid?
  end

  test "schedule requires an end time after the start time and the classroom teacher" do
    schedule = Schedule.new(
      classroom: @classroom,
      teacher: @teacher,
      schedule_date: Date.current,
      start_time: "10:00",
      end_time: "09:00"
    )

    assert_not schedule.valid?
    assert_includes schedule.errors[:end_time], "must be after start time"

    other_teacher_user = User.create!(email: "other-teacher@example.com", password: "password", role: "teacher")
    other_teacher = Teacher.create!(user: other_teacher_user, name: "Suzuki", status: "active")
    schedule.teacher = other_teacher
    schedule.start_time = "09:00"
    schedule.end_time = "10:00"

    assert_not schedule.valid?
    assert_includes schedule.errors[:teacher], "must match the classroom teacher"
  end

  test "progress requires enrollment and keeps score within bounds" do
    progress = StudentProgress.new(
      student: @student,
      classroom: @classroom,
      teacher: @teacher,
      progress_date: Date.current,
      score: 101,
      status: "excellent"
    )

    assert_not progress.valid?
    assert progress.errors[:score].any? { |error| error.include?("in 0..100") }
    assert_includes progress.errors[:student], "must be enrolled in the classroom"

    Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")
    progress.score = 86

    assert progress.valid?, progress.errors.full_messages.to_sentence
  end

  test "active scopes return active records" do
    inactive_student = Student.create!(user: User.create!(email: "inactive@example.com", password: "password", role: "student"), name: "Inactive", status: "inactive")

    assert_includes Student.active, @student
    assert_not_includes Student.active, inactive_student
    assert_includes Teacher.active, @teacher
    assert_includes Course.active, @course
    assert_includes Classroom.active, @classroom
  end
end
