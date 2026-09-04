class Student::ClassesController < StudentController
  def index
    @classrooms = enrolled_classrooms.includes(:course, :teacher).order(:name)
  end

  def show
    @classroom = enrolled_classrooms.includes(:course, :teacher, :schedules).find(params[:id])
  end

  private

  def enrolled_classrooms
    current_student.classrooms.joins(:enrollments).where(enrollments: { status: "active", student_id: current_student.id }).distinct
  end
end
