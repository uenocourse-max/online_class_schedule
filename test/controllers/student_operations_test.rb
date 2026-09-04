require "test_helper"

class StudentOperationsTest < ActionDispatch::IntegrationTest
  setup do
    @student_user = User.create!(email: "student-phase6@example.com", password: "password", role: "student")
    @other_student_user = User.create!(email: "other-student-phase6@example.com", password: "password", role: "student")
    @teacher_user = User.create!(email: "teacher-phase6@example.com", password: "password", role: "teacher")
    @student = Student.create!(user: @student_user, name: "Budi", phone: "111", status: "active")
    @other_student = Student.create!(user: @other_student_user, name: "Siti", status: "active")
    @teacher = Teacher.create!(user: @teacher_user, name: "Tanaka", status: "active")
    @course = Course.create!(name: "Japanese N4", status: "active")
    @classroom = Classroom.create!(name: "N4 Morning", course: @course, teacher: @teacher, status: "active")
    Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")
    @progress = StudentProgress.create!(student: @student, classroom: @classroom, teacher: @teacher, progress_date: Date.current, score: 86, status: "excellent", note: "Good progress")
  end

  test "student sees their dashboard, classes, schedule, and progress" do
    sign_in(@student_user)

    get student_dashboard_path
    assert_response :success
    assert_select "h1", "Your learning space"
    assert_select ".metric-card strong", text: "86.0", count: 1

    get student_classes_path
    assert_response :success
    assert_select "td", text: "N4 Morning"

    get student_progress_index_path
    assert_response :success
    assert_select "td", text: "Budi", count: 0
    assert_select "td", text: "86"
  end

  test "student can view progress notes but cannot modify progress" do
    sign_in(@student_user)

    get student_progress_path(@progress)
    assert_response :success
    assert_select "dd", text: "Good progress"

    patch student_progress_path(@progress), params: { progress: { score: 100 } }
    assert_response :not_found
    assert_equal 86, @progress.reload.score.to_i
  end

  test "student cannot access another student's private records" do
    sign_in(@student_user)

    get student_profile_path, params: { id: @other_student.id }
    assert_response :success
    assert_select "dd", text: "Siti", count: 0

    get student_class_path(@classroom)
    assert_response :success
    get student_progress_path(@progress)
    assert_response :success
  end

  test "student can update only allowed profile fields" do
    sign_in(@student_user)

    patch student_profile_path, params: { student: { phone: "222", address: "New address", name: "Changed name" } }

    assert_redirected_to student_profile_path
    assert_equal "222", @student.reload.phone
    assert_equal "Budi", @student.name
  end

  test "non-students are denied student routes" do
    sign_in(@teacher_user)
    get student_dashboard_path

    assert_redirected_to teacher_dashboard_path
  end

  private

  def sign_in(user)
    post login_path, params: { email: user.email, password: "password" }
  end
end
