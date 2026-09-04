class Teacher::ClassesController < TeacherController
  def index
    @classrooms = current_teacher.classrooms.includes(:course, :students).order(:name)
  end

  def show
    @classroom = current_teacher.classrooms.includes(:course, :students, :schedules).find(params[:id])
  end
end
