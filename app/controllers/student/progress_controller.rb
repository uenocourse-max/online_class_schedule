class Student::ProgressController < StudentController
  def index
    @progresses = current_student.student_progresses.includes(:classroom, :teacher).order(progress_date: :desc, created_at: :desc)
    @average_score = @progresses.average(:score)
  end

  def show
    @progress = current_student.student_progresses.includes(:classroom, :teacher).find(params[:id])
  end
end
