class Admin::StudentProgressesController < AdminController
  before_action :set_progress, only: %i[show edit update destroy]

  def index
    @progresses = StudentProgress.includes(:student, :classroom, :teacher).order(progress_date: :desc)
  end

  def show; end
  def new
    @progress = StudentProgress.new(progress_date: Date.current)
    load_options
  end

  def create
    @progress = StudentProgress.new(progress_params)
    if @progress.save
      redirect_to admin_student_progress_path(@progress), notice: "Progress record created successfully."
    else
      load_options
      render :new, status: :unprocessable_entity
    end
  end

  def edit; load_options; end

  def update
    if @progress.update(progress_params)
      redirect_to admin_student_progress_path(@progress), notice: "Progress record was updated."
    else
      load_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @progress.destroy!
    redirect_to admin_student_progresses_path, notice: "Progress record was deleted."
  end

  private
  def set_progress; @progress = StudentProgress.find(params[:id]); end
  def load_options
    @students = Student.active.order(:name)
    @classrooms = Classroom.active.order(:name)
    @teachers = Teacher.active.order(:name)
  end
  def progress_params; params.require(:student_progress).permit(:student_id, :classroom_id, :teacher_id, :progress_date, :score, :status, :note); end
end
