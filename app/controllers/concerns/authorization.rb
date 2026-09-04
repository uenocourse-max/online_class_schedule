module Authorization
  extend ActiveSupport::Concern

  private

  def require_role!(*roles)
    return if current_user && roles.map(&:to_s).include?(current_user.role)

    redirect_to dashboard_path_for(current_user), alert: "You are not authorized to access that page."
  end

  def dashboard_path_for(user)
    return login_path unless user

    case user.role
    when "admin" then admin_dashboard_path
    when "teacher" then teacher_dashboard_path
    when "student" then student_dashboard_path
    else login_path
    end
  end
end
