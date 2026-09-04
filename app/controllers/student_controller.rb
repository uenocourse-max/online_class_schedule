class StudentController < ApplicationController
  before_action -> { require_role!("student") }

  helper_method :current_student

  private

  def current_student
    current_user.student
  end
end
