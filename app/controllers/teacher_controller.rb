class TeacherController < ApplicationController
  before_action -> { require_role!("teacher") }

  helper_method :current_teacher

  private

  def current_teacher
    current_user.teacher
  end
end
