require "test_helper"

class AdminOperationsTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(email: "phase4-admin@example.com", password: "password", role: "admin")
    @teacher_user = User.create!(email: "phase4-teacher@example.com", password: "password", role: "teacher")
    @student_user = User.create!(email: "phase4-student@example.com", password: "password", role: "student")
    @teacher = Teacher.create!(user: @teacher_user, name: "Tanaka", status: "active")
    @student = Student.create!(user: @student_user, name: "Budi", status: "active")
    @course = Course.create!(name: "Japanese N4", status: "active")
    @classroom = Classroom.create!(name: "N4 Morning", course: @course, teacher: @teacher, status: "active")
  end

  test "admin dashboard shows live counts" do
    sign_in(@admin)
    get admin_dashboard_path

    assert_response :success
    assert_select ".metric-card strong", text: "1", count: 3
  end

  test "admin can create a course" do
    sign_in(@admin)
    assert_difference("Course.count") do
      post admin_courses_path, params: { course: { name: "English Beginner", description: "Foundations", status: "active" } }
    end

    assert_redirected_to admin_course_path(Course.order(:created_at).last)
  end

  test "admin can create a student and login account" do
    sign_in(@admin)
    assert_difference([ "Student.count", "User.count" ]) do
      post admin_students_path, params: { student: { name: "Siti", status: "active", user_attributes: { email: "siti@example.com", password: "password", password_confirmation: "password" } } }
    end

    assert_redirected_to admin_student_path(Student.order(:created_at).last)
  end

  test "admin can enroll a student and add a progress record" do
    sign_in(@admin)
    post admin_enrollments_path, params: { enrollment: { student_id: @student.id, classroom_id: @classroom.id, enrolled_at: Date.current, status: "active" } }
    assert_redirected_to admin_enrollments_path

    assert_difference("StudentProgress.count") do
      post admin_student_progresses_path, params: { student_progress: { student_id: @student.id, classroom_id: @classroom.id, teacher_id: @teacher.id, progress_date: Date.current, score: 86, status: "excellent", note: "Good progress" } }
    end
    assert_redirected_to admin_student_progress_path(StudentProgress.order(:created_at).last)
  end

  test "admin cannot create a schedule with an invalid time" do
    sign_in(@admin)
    post admin_schedules_path, params: { schedule: { classroom_id: @classroom.id, teacher_id: @teacher.id, schedule_date: Date.current, start_time: "10:00", end_time: "09:00" } }

    assert_response :unprocessable_entity
    assert_select ".form-errors"
  end

  test "non-admin users are denied every admin resource" do
    sign_in(@student_user)
    get admin_students_path

    assert_redirected_to student_dashboard_path
    follow_redirect!
    assert_select ".flash-alert", "You are not authorized to access that page."
  end

  private

  def sign_in(user)
    post login_path, params: { email: user.email, password: "password" }
  end
end
