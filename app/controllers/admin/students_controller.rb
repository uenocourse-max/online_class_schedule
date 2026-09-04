class Admin::StudentsController < AdminController
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @students = Student.includes(:user, :classrooms).order(:name)
    @students = @students.where(status: params[:status]) if Student::STATUSES.include?(params[:status])
    @students = @students.where("students.name LIKE ?", "%#{Student.sanitize_sql_like(params[:query])}%") if params[:query].present?
  end

  def show; end

  def new
    @student = Student.new(status: "active", user: User.new(role: "student"))
  end

  def create
    @student = Student.new(student_params)
    @student.user.role = "student"
    if @student.save
      redirect_to admin_student_path(@student), notice: "Student created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @student.update(student_params)
      redirect_to admin_student_path(@student), notice: "Student was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.update!(status: "inactive")
    redirect_to admin_students_path, notice: "Student was deactivated."
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :phone, :address, :birth_date, :gender, :status, :notes, user_attributes: %i[email password password_confirmation])
  end
end
