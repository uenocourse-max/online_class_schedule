class Admin::EnrollmentsController < AdminController
  before_action :set_enrollment, only: %i[update destroy]

  def index
    @enrollments = Enrollment.includes(:student, :classroom).order(enrolled_at: :desc)
    @students = Student.active.order(:name)
    @classrooms = Classroom.active.order(:name)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to admin_enrollments_path, notice: "Student enrolled successfully."
    else
      redirect_to admin_enrollments_path, alert: @enrollment.errors.full_messages.to_sentence
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      redirect_to admin_enrollments_path, notice: "Enrollment was updated."
    else
      redirect_to admin_enrollments_path, alert: @enrollment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @enrollment.update!(status: "dropped")
    redirect_to admin_enrollments_path, notice: "Enrollment was dropped."
  end

  private
  def set_enrollment; @enrollment = Enrollment.find(params[:id]); end
  def enrollment_params; params.require(:enrollment).permit(:student_id, :classroom_id, :enrolled_at, :status); end
end
