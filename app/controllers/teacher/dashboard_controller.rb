class Teacher::DashboardController < TeacherController
  def show
    @classrooms = current_teacher.classrooms.includes(:course, :students).active.order(:name)
    @upcoming_schedules = current_teacher.schedules.includes(:classroom).where("schedule_date >= ?", Date.current).order(:schedule_date, :start_time).limit(5)
    @recent_progress = current_teacher.student_progresses.includes(:student, :classroom).order(progress_date: :desc).limit(5)
  end
end
