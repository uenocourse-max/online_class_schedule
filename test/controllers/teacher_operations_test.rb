require "test_helper"

class TeacherOperationsTest < ActionDispatch::IntegrationTest
  setup do
    @teacher_user = User.create!(email: "teacher-phase5@example.com", password: "password", role: "teacher")
    @other_teacher_user = User.create!(email: "other-teacher-phase5@example.com", password: "password", role: "teacher")
    @student_user = User.create!(email: "student-phase5@example.com", password: "password", role: "student")
    @other_student_user = User.create!(email: "other-student-phase5@example.com", password: "password", role: "student")
    @teacher = Teacher.create!(user: @teacher_user, name: "Tanaka", status: "active")
    @other_teacher = Teacher.create!(user: @other_teacher_user, name: "Suzuki", status: "active")
    @student = Student.create!(user: @student_user, name: "Budi", status: "active")
    @other_student = Student.create!(user: @other_student_user, name: "Siti", status: "active")
    @course = Course.create!(name: "Japanese N4", status: "active")
    @other_course = Course.create!(name: "English", status: "active")
    @classroom = Classroom.create!(name: "N4 Morning", course: @course, teacher: @teacher, status: "active")
    @other_classroom = Classroom.create!(name: "English Evening", course: @other_course, teacher: @other_teacher, status: "active")
    Enrollment.create!(student: @student, classroom: @classroom, enrolled_at: Date.current, status: "active")
    Enrollment.create!(student: @other_student, classroom: @other_classroom, enrolled_at: Date.current, status: "active")
  end

  test "teacher sees only assigned classes and students" do
    sign_in(@teacher_user)

    get teacher_classes_path
    assert_response :success
    assert_select "td", text: "N4 Morning"
    assert_select "td", text: "English Evening", count: 0

    get teacher_students_path
    assert_response :success
    assert_select "td", text: "Budi"
    assert_select "td", text: "Siti", count: 0
  end

  test "teacher can create progress for an enrolled student in an assigned class" do
    sign_in(@teacher_user)

    assert_difference("StudentProgress.count") do
      post teacher_student_progresses_path, params: { student_progress: { student_id: @student.id, classroom_id: @classroom.id, progress_date: Date.current, score: 82, status: "good", note: "Vocabulary improved" } }
    end

    assert_redirected_to teacher_student_progress_path(StudentProgress.order(:created_at).last)
  end

  test "teacher cannot create progress for another teacher's class" do
    sign_in(@teacher_user)

    assert_no_difference("StudentProgress.count") do
      post teacher_student_progresses_path, params: { student_progress: { student_id: @other_student.id, classroom_id: @other_classroom.id, progress_date: Date.current, score: 70, status: "needs_improvement" } }
    end

    assert_response :unprocessable_entity
    assert_select ".form-errors"
  end

  test "teacher cannot read another teacher's class or student" do
    sign_in(@teacher_user)

    get teacher_class_path(@other_classroom)
    assert_response :not_found

    get teacher_student_path(@other_student)
    assert_response :not_found
  end

  test "teacher can edit only their own progress records" do
    progress = StudentProgress.create!(student: @student, classroom: @classroom, teacher: @teacher, progress_date: Date.current, score: 70, status: "needs_improvement")
    sign_in(@teacher_user)

    patch teacher_student_progress_path(progress), params: { student_progress: { score: 88, status: "good" } }

    assert_redirected_to teacher_student_progress_path(progress)
    assert_equal 88, progress.reload.score.to_i
  end

  private

  def sign_in(user)
    post login_path, params: { email: user.email, password: "password" }
  end
end
