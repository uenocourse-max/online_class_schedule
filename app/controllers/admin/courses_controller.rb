class Admin::CoursesController < AdminController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    @courses = Course.includes(:classrooms).order(:name)
  end

  def show; end
  def new; @course = Course.new(status: "active"); end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to admin_course_path(@course), notice: "Course created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @course.update(course_params)
      redirect_to admin_course_path(@course), notice: "Course was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.update!(status: "inactive")
    redirect_to admin_courses_path, notice: "Course was deactivated."
  end

  private
  def set_course; @course = Course.find(params[:id]); end
  def course_params; params.require(:course).permit(:name, :description, :status); end
end
