class Admin::TeachersController < AdminController
  before_action :set_teacher, only: %i[show edit update destroy]

  def index
    @teachers = Teacher.includes(:user, :classrooms).order(:name)
    @teachers = @teachers.where(status: params[:status]) if Teacher::STATUSES.include?(params[:status])
    @teachers = @teachers.where("teachers.name LIKE ?", "%#{Teacher.sanitize_sql_like(params[:query])}%") if params[:query].present?
  end

  def show; end

  def new
    @teacher = Teacher.new(status: "active", user: User.new(role: "teacher"))
  end

  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.user.role = "teacher"
    if @teacher.save
      redirect_to admin_teacher_path(@teacher), notice: "Teacher created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @teacher.update(teacher_params)
      redirect_to admin_teacher_path(@teacher), notice: "Teacher was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @teacher.update!(status: "inactive")
    redirect_to admin_teachers_path, notice: "Teacher was deactivated."
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    params.require(:teacher).permit(:name, :phone, :address, :specialization, :status, :bio, user_attributes: %i[email password password_confirmation])
  end
end
