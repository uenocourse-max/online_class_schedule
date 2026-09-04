class Admin::ClassroomsController < AdminController
  before_action :set_classroom, only: %i[show edit update destroy]

  def index
    @classrooms = Classroom.includes(:course, :teacher, :students).order(:name)
  end

  def show; end
  def new
    @classroom = Classroom.new(status: "active")
    load_options
  end

  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      redirect_to admin_classroom_path(@classroom), notice: "Class was created successfully."
    else
      load_options
      render :new, status: :unprocessable_entity
    end
  end

  def edit; load_options; end

  def update
    if @classroom.update(classroom_params)
      redirect_to admin_classroom_path(@classroom), notice: "Class was successfully updated."
    else
      load_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.update!(status: "inactive")
    redirect_to admin_classrooms_path, notice: "Class was deactivated."
  end

  private
  def set_classroom; @classroom = Classroom.find(params[:id]); end
  def load_options
    @courses = Course.active.order(:name)
    @teachers = Teacher.active.order(:name)
  end
  def classroom_params; params.require(:classroom).permit(:name, :course_id, :teacher_id, :status, :description); end
end
