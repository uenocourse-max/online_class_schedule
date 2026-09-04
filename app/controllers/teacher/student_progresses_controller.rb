class Teacher::StudentProgressesController < TeacherController
  before_action :set_progress, only: %i[show edit update]
  before_action :load_options, only: %i[new edit create update]

  def index
    @progresses = current_teacher.student_progresses.includes(:student, :classroom).order(progress_date: :desc)
  end

  def show; end

  def new
    @progress = current_teacher.student_progresses.new(progress_date: Date.current)
  end

  def create
    @progress = current_teacher.student_progresses.new(progress_params)
    if @progress.save
      redirect_to teacher_student_progress_path(@progress), notice: "Progress record created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @progress.update(progress_params)
      redirect_to teacher_student_progress_path(@progress), notice: "Progress record was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_progress
    @progress = current_teacher.student_progresses.includes(:student, :classroom).find(params[:id])
  end

  def load_options
    @classrooms = current_teacher.classrooms.active.order(:name)
    @students = Student.joins(:classrooms).where(classrooms: { teacher_id: current_teacher.id }).distinct.active.order(:name)
  end

  def progress_params
    params.require(:student_progress).permit(:student_id, :classroom_id, :progress_date, :score, :status, :note).merge(teacher: current_teacher)
  end
end
