module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :dashboard_path_for
  end

  private

  def authenticate_user!
    return if current_user

    redirect_to login_path, alert: "Please log in to continue."
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def log_in(user)
    reset_session
    session[:user_id] = user.id
    @current_user = user
  end

  def log_out
    reset_session
    @current_user = nil
  end
end
