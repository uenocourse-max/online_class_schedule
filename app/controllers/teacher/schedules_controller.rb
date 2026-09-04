class Teacher::SchedulesController < TeacherController
  def index
    @schedules = current_teacher.schedules.includes(:classroom).order(schedule_date: :asc, start_time: :asc)
  end
end
