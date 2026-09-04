module ApplicationHelper
  def navigation_items
    case current_user&.role
    when "admin"
      [ [ "Dashboard", admin_dashboard_path ], [ "Students", admin_students_path ], [ "Teachers", admin_teachers_path ], [ "Courses", admin_courses_path ], [ "Classes", admin_classrooms_path ], [ "Enrollments", admin_enrollments_path ], [ "Schedules", admin_schedules_path ], [ "Progress", admin_student_progresses_path ] ]
    when "teacher"
      [ [ "Dashboard", teacher_dashboard_path ], [ "My Classes", teacher_classes_path ], [ "My Students", teacher_students_path ], [ "Schedules", teacher_schedules_path ], [ "Student Progress", teacher_student_progresses_path ] ]
    when "student"
      [ [ "Dashboard", student_dashboard_path ], [ "My Classes", student_classes_path ], [ "My Schedule", student_schedules_path ], [ "My Progress", student_progress_index_path ], [ "Profile", student_profile_path ] ]
    else
      []
    end
  end

  def role_label(role)
    role.to_s.capitalize
  end

  def schedule_status(schedule)
    if schedule.schedule_date < Date.current
      "Selesai"
    elsif schedule.schedule_date == Date.current
      "Hari ini"
    else
      "Akan datang"
    end
  end

  def schedule_status_class(schedule)
    schedule_status(schedule).parameterize
  end
end
