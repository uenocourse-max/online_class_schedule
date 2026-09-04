class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    redirect_to dashboard_path_for(current_user) if current_user
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to dashboard_path_for(user), notice: "Welcome back."
    else
      flash.now[:alert] = "Email or password is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to login_path, notice: "You have been logged out."
  end
end
