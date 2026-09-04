class Student::SchedulesController < StudentController
  def index
    @schedules = Schedule.joins(classroom: :enrollments).where(enrollments: { student_id: current_student.id, status: "active" }).includes(:classroom, :teacher).order(schedule_date: :asc, start_time: :asc)
  end
end
