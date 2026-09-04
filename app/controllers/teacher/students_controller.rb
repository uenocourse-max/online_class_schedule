class Teacher::StudentsController < TeacherController
  def index
    @students = Student.joins(:classrooms).where(classrooms: { teacher_id: current_teacher.id }).distinct.includes(:user, :classrooms).order(:name)
  end

  def show
    @student = Student.joins(:classrooms).where(classrooms: { teacher_id: current_teacher.id }).find(params[:id])
    @classrooms = @student.classrooms.where(teacher_id: current_teacher.id)
    @progresses = @student.student_progresses.where(teacher_id: current_teacher.id).includes(:classroom).order(progress_date: :desc)
  end
end
