require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(email: "admin@example.com", password: "password", role: "admin")
    @teacher = User.create!(email: "teacher@example.com", password: "password", role: "teacher")
    @student = User.create!(email: "student@example.com", password: "password", role: "student")
  end

  test "anonymous users are redirected to login" do
    get root_path

    assert_redirected_to login_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "Welcome back"
  end

  test "valid credentials redirect to the role dashboard" do
    post login_path, params: { email: " ADMIN@example.com ", password: "password" }

    assert_redirected_to admin_dashboard_path
    follow_redirect!
    assert_response :success
    assert_select ".sidebar", count: 1
    assert_select ".sidebar-role strong", "Admin"
  end

  test "invalid credentials render an unprocessable login page" do
    post login_path, params: { email: @student.email, password: "incorrect" }

    assert_response :unprocessable_entity
    assert_select ".flash-alert", "Email or password is incorrect."
  end

  test "each role is redirected to its own dashboard" do
    post login_path, params: { email: @teacher.email, password: "password" }
    assert_redirected_to teacher_dashboard_path

    delete logout_path
    post login_path, params: { email: @student.email, password: "password" }
    assert_redirected_to student_dashboard_path
  end

  test "a user cannot access another role dashboard" do
    post login_path, params: { email: @student.email, password: "password" }
    get admin_dashboard_path

    assert_redirected_to student_dashboard_path
    follow_redirect!
    assert_select ".flash-alert", "You are not authorized to access that page."
  end

  test "logout clears the session" do
    post login_path, params: { email: @admin.email, password: "password" }
    delete logout_path

    assert_redirected_to login_path
    get root_path
    assert_redirected_to login_path
  end
end
