class DashboardController < ApplicationController
  def show
    redirect_to dashboard_path_for(current_user)
  end
end
