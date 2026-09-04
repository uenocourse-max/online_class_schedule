require "application_system_test_case"

class SystemAuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: "system-admin@example.com", password: "password", role: "admin")
  end

  test "admin can sign in and see the dashboard" do
    visit login_path

    fill_in "Email address", with: @user.email
    fill_in "Password", with: "password"
    click_on "Sign in"

    assert_current_path admin_dashboard_path
    assert_text "Good morning, System-admin"
    assert_text "System overview"
  end
end
