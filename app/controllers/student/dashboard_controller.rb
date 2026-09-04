class Student::DashboardController < StudentController
  def show
    unless current_student
      @classrooms = []
      @upcoming_schedules = []
      @progresses = StudentProgress.none
      @latest_progress = nil
      @average_score = nil
      return
    end

    @classrooms = enrolled_classrooms.includes(:course, :teacher).order(:name)
    @upcoming_schedules = enrolled_schedules.includes(:classroom, :teacher).where("schedule_date >= ?", Date.current).order(:schedule_date, :start_time).limit(5)
    @progresses = current_student.student_progresses.includes(:classroom, :teacher).order(progress_date: :desc, created_at: :desc)
    @latest_progress = @progresses.first
    @average_score = @progresses.average(:score)
  end

  private

  def enrolled_classrooms
    current_student.classrooms.joins(:enrollments).where(enrollments: { status: "active", student_id: current_student.id }).distinct
  end

  def enrolled_schedules
    Schedule.joins(classroom: :enrollments).where(enrollments: { student_id: current_student.id, status: "active" })
  end
end
