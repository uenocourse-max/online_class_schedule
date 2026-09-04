# Product Requirements Document

## 1. Product

**Online School** is a role-aware Rails application for managing students, teachers, courses, classes, enrollment, schedules, and historical student progress.

## 2. Problem

School staff need one reliable place to manage class membership and schedules while teachers record progress and students see only their own learning information.

## 3. Goals

- Give admins complete operational control over school data.
- Give teachers a focused view of assigned classes and their students.
- Give students private access to their profile, classes, schedules, progress, and intended notes.
- Preserve progress as dated history rather than overwriting a current value.
- Provide a responsive, accessible interface for desktop, tablet, and mobile use.

## 4. Roles

- **Admin:** manages users and all school resources.
- **Teacher:** views assigned classes and students, schedules, and creates or edits their own progress records.
- **Student:** views their own learning data and edits only allowed profile fields.

## 5. MVP Scope

### Authentication

- Email/password login and logout using secure password hashing.
- Session-based authentication.
- Role-based redirect to `/admin/dashboard`, `/teacher/dashboard`, or `/student/dashboard`.
- Unauthenticated requests redirect to login; unauthorized requests are rejected with a friendly response.

### Admin workflows

- Dashboard metrics: students, teachers, courses, active classes, today's schedules, recent progress, and students needing attention.
- CRUD/deactivation for students, teachers, courses, and classrooms.
- Assign teachers to classrooms.
- Enroll and remove students from classrooms without allowing duplicate active enrollment.
- CRUD schedules and progress records.
- Search/filter students and operational lists.

### Teacher workflows

- Dashboard for assigned classrooms.
- View assigned class details, students, and schedules.
- Create and edit progress only for students enrolled in an assigned classroom.
- View progress history and teaching notes for assigned students.

### Student workflows

- Dashboard with enrolled classes, upcoming schedules, latest progress, and average score.
- View own profile, enrolled classes, teachers, schedules, progress history, and teacher notes.
- Edit only explicitly permitted profile fields.
- No access to another student's records and no progress/note mutation.

## 6. Non-goals for MVP

- Payment, invoicing, attendance, grading rubrics, messaging, file uploads, video hosting, notifications, and public course catalog.
- A separate JSON API or mobile client.
- A heavy charting dependency; a small server-rendered summary or lightweight Stimulus visualization is sufficient.

## 7. Business Rules

- A user has one role: `admin`, `teacher`, or `student`.
- Student and teacher profiles belong one-to-one to users of the matching role.
- A classroom belongs to one course and one teacher.
- A student may have at most one active enrollment per classroom; completed or dropped history is retained.
- A schedule belongs to a classroom and teacher; the teacher normally matches the classroom teacher.
- Schedule end time must be after start time.
- Schedule status is derived automatically from `schedule_date`: `Selesai` for past dates, `Hari ini` for today's date, and `Akan datang` for future dates. It is presentation state, not a stored database field.
- Progress belongs to a student, classroom, and teacher, and is appendable history. Teachers may edit their own records only.
- Progress score is numeric and within 0..100.
- Students may read only their own data.

## 8. UX Requirements

- Shared authenticated layout with role-specific sidebar navigation and top bar.
- Semantic labels, keyboard-accessible controls, sufficient color contrast, and clear validation errors.
- Tables include search/filter controls, empty states, and responsive handling.
- Schedule lists show the automatic Indonesian status label and distinguish each state visually with accessible contrast.
- Forms preserve submitted values and show actionable flash messages.
- Turbo frames/streams may improve CRUD interactions where they reduce page complexity, but full-page fallbacks remain valid.

## 9. MVP Acceptance Criteria

- All three roles can log in, log out, and reach the correct dashboard.
- Admin CRUD, enrollment, schedule, and progress workflows work end to end.
- Teachers cannot access or mutate unassigned classes or unrelated students.
- Students cannot access another student's profile, schedule, progress, or notes.
- Model constraints, foreign keys, indexes, and validation tests pass.
- Seed data is idempotent and clearly marked for development.
- Admin, teacher, and student schedule pages consistently show `Selesai`, `Hari ini`, or `Akan datang` based on the current date.
- `bin/rails test`, security checks, migrations, and a production-style boot check succeed.
