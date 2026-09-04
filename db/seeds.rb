# Development seed data. Never use these credentials in production.

PASSWORD = "password"

admin = User.find_or_initialize_by(email: "admin@example.com")
admin.role = "admin"
admin.password = PASSWORD if admin.new_record?
admin.save!

teacher_records = [
  { email: "teacher@example.com", name: "Tanaka Sensei", specialization: "Japanese language", bio: "Focuses on practical conversation and listening." },
  { email: "suzuki@example.com", name: "Suzuki Sensei", specialization: "English language", bio: "Builds confidence through clear fundamentals." }
].map do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])
  user.role = "teacher"
  user.password = PASSWORD if user.new_record?
  user.save!
  teacher = Teacher.find_or_initialize_by(user: user)
  teacher.assign_attributes(attributes.except(:email))
  teacher.status = "active"
  teacher.save!
  teacher
end

student_records = [
  { email: "student@example.com", name: "Budi Santoso", phone: "0812-0001", address: "Jakarta", gender: "Male" },
  { email: "andi@example.com", name: "Andi Pratama", phone: "0812-0002", address: "Bandung", gender: "Male" },
  { email: "siti@example.com", name: "Siti Rahma", phone: "0812-0003", address: "Surabaya", gender: "Female" },
  { email: "rina@example.com", name: "Rina Putri", phone: "0812-0004", address: "Yogyakarta", gender: "Female" },
  { email: "dimas@example.com", name: "Dimas Wijaya", phone: "0812-0005", address: "Semarang", gender: "Male" },
  { email: "maya@example.com", name: "Maya Lestari", phone: "0812-0006", address: "Malang", gender: "Female" }
].map do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])
  user.role = "student"
  user.password = PASSWORD if user.new_record?
  user.save!
  student = Student.find_or_initialize_by(user: user)
  student.assign_attributes(attributes.except(:email))
  student.status = "active"
  student.save!
  student
end

courses = {
  "Japanese N5" => "A welcoming foundation in Japanese reading, vocabulary, and conversation.",
  "Japanese N4" => "Build practical intermediate Japanese through listening and kanji practice.",
  "English Beginner" => "A clear introduction to everyday English communication."
}.each_with_object({}) do |(name, description), records|
  records[name] = Course.find_or_initialize_by(name: name)
  records[name].assign_attributes(description: description, status: "active")
  records[name].save!
end

classrooms = [
  { name: "Japanese N4 Morning", course: courses["Japanese N4"], teacher: teacher_records[0], students: student_records.first(3) },
  { name: "Japanese N5 Evening", course: courses["Japanese N5"], teacher: teacher_records[0], students: student_records[3..4] },
  { name: "English Beginner", course: courses["English Beginner"], teacher: teacher_records[1], students: student_records[5..] }
].map do |attributes|
  classroom = Classroom.find_or_initialize_by(name: attributes[:name])
  classroom.assign_attributes(course: attributes[:course], teacher: attributes[:teacher], status: "active", description: "Development classroom")
  classroom.save!
  attributes[:students].each do |student|
    enrollment = Enrollment.find_or_initialize_by(student: student, classroom: classroom)
    enrollment.assign_attributes(enrolled_at: Date.current - 14.days, status: "active")
    enrollment.save!
  end
  classroom
end

schedule_data = [
  { classroom: classrooms[0], teacher: teacher_records[0], date: Date.current, start: "09:00", finish: "10:30", room: "A101" },
  { classroom: classrooms[1], teacher: teacher_records[0], date: Date.current + 1.day, start: "18:30", finish: "20:00", room: "Online" },
  { classroom: classrooms[2], teacher: teacher_records[1], date: Date.current + 2.days, start: "13:00", finish: "14:30", room: "B204" }
]
schedule_data.each do |attributes|
  schedule = Schedule.find_or_initialize_by(classroom: attributes[:classroom], schedule_date: attributes[:date], start_time: attributes[:start])
  schedule.assign_attributes(teacher: attributes[:teacher], end_time: attributes[:finish], room: attributes[:room], meeting_link: attributes[:room] == "Online" ? "https://example.com/online-school" : nil)
  schedule.save!
end

progress_data = [
  { student: student_records[0], classroom: classrooms[0], teacher: teacher_records[0], date: Date.current - 14.days, score: 70, status: "needs_improvement", note: "Needs more kanji practice." },
  { student: student_records[0], classroom: classrooms[0], teacher: teacher_records[0], date: Date.current - 7.days, score: 78, status: "good", note: "Listening has improved." },
  { student: student_records[0], classroom: classrooms[0], teacher: teacher_records[0], date: Date.current, score: 86, status: "excellent", note: "Good progress this week." },
  { student: student_records[1], classroom: classrooms[0], teacher: teacher_records[0], date: Date.current, score: 62, status: "needs_improvement", note: "Review vocabulary before the next session." },
  { student: student_records[3], classroom: classrooms[1], teacher: teacher_records[0], date: Date.current, score: 91, status: "excellent", note: "Strong reading comprehension." }
]
progress_data.each do |attributes|
  progress = StudentProgress.find_or_initialize_by(student: attributes[:student], classroom: attributes[:classroom], progress_date: attributes[:date])
  progress.assign_attributes(attributes.except(:student, :classroom, :date))
  progress.save!
end

puts "Seeded #{User.count} users, #{Student.count} students, #{Teacher.count} teachers, #{Course.count} courses, #{Classroom.count} classes, #{Enrollment.count} enrollments, #{Schedule.count} schedules, and #{StudentProgress.count} progress records."
