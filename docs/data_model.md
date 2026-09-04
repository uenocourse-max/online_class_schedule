# Data Model

## Entities

### User

Fields: `email`, `password_digest`, `role`, timestamps.

Associations: optional one-to-one `student` and `teacher` profiles. Email is normalized and unique. Role is restricted to `admin`, `teacher`, or `student`.

### Student

Fields: `user_id`, `name`, `phone`, `address`, `birth_date`, `gender`, `status`, `notes`, timestamps.

Associations: belongs to User; has many Enrollments, Classrooms through Enrollments, and StudentProgresses. Status is `active`, `inactive`, or `graduated`.

### Teacher

Fields: `user_id`, `name`, `phone`, `address`, `specialization`, `status`, `bio`, timestamps.

Associations: belongs to User; has many Classrooms, Schedules, and StudentProgresses. Status is `active` or `inactive`.

### Course

Fields: `name`, `description`, `status`, timestamps.

Associations: has many Classrooms. Status is `active` or `inactive`.

### Classroom

Fields: `name`, `course_id`, `teacher_id`, `status`, `description`, timestamps.

Associations: belongs to Course and Teacher; has many Enrollments, Students through Enrollments, Schedules, and StudentProgresses. Status is `active`, `inactive`, or `completed`.

### Enrollment

Fields: `student_id`, `classroom_id`, `enrolled_at`, `status`, timestamps.

Associations: belongs to Student and Classroom. Status is `active`, `completed`, or `dropped`.

Constraint: unique `(student_id, classroom_id, status)` is too strict for retained history. Prefer a database-supported partial unique index on `(student_id, classroom_id)` where `status = 'active'`, plus model validation and a transaction for reactivation/race handling.

### Schedule

Fields: `classroom_id`, `teacher_id`, `schedule_date`, `start_time`, `end_time`, `room`, `meeting_link`, timestamps.

Associations: belongs to Classroom and Teacher. Validate required fields, end after start, and teacher/classroom consistency.

### StudentProgress

Fields: `student_id`, `classroom_id`, `teacher_id`, `progress_date`, `score`, `status`, `note`, timestamps.

Associations: belongs to Student, Classroom, and Teacher. Status is `excellent`, `good`, `needs_improvement`, `poor`, or `completed`.

Constraint: score is decimal/numeric from 0 to 100. A progress row is immutable history in meaning even when the authoring teacher may edit their own row.

## Integrity Rules

- Add foreign keys for every reference.
- Add indexes on all foreign keys and unique user email.
- Add unique indexes for one-to-one profile `user_id` values.
- Add check constraints where SQLite/Rails support is reliable for the chosen column representation.
- Validate cross-association ownership in models and controllers.
- Use dependent behavior deliberately; do not cascade-delete progress history accidentally. Prefer deactivation or restricted deletion for records with history.

## Query Scopes

Provide named scopes for `active` on Student, Teacher, Course, Classroom, and Enrollment. Add date/status scopes for Schedule and StudentProgress only when used by more than one workflow.

## Derived Dashboard Data

Calculate active counts, today's schedules, recent progress, and attention-needed students from queries/scopes. Do not add duplicated counter fields to the MVP models.
