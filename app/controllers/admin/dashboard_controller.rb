class Admin::DashboardController < AdminController
  def show
    @student_count = Student.count
    @active_student_count = Student.active.count
    @teacher_count = Teacher.count
    @course_count = Course.count
    @active_classroom_count = Classroom.active.count
    @todays_schedules = Schedule.includes(:classroom, :teacher).where(schedule_date: Date.current).order(:start_time)
    @recent_progress = StudentProgress.includes(:student, :classroom, :teacher).order(progress_date: :desc, created_at: :desc).limit(8)
    @students_needing_attention = StudentProgress.includes(:student).where(status: %w[needs_improvement poor]).order(progress_date: :desc).limit(5)
  end
end
