# Testing Strategy

The project already uses Rails default Minitest. Keep tests close to the behavior they protect and add system tests only for critical end-to-end workflows.

## Model Tests

Cover:

- User email normalization, uniqueness, password presence/verification, and valid roles.
- Student/Teacher required fields, profile role compatibility, statuses, and relationships.
- Course/Classroom required associations and statuses.
- Enrollment associations, valid statuses, and duplicate active enrollment prevention at model and database levels.
- Schedule required fields, end-after-start validation, and teacher/classroom consistency.
- StudentProgress required associations, valid statuses, numeric score, 0..100 boundaries, and history behavior.

## Request/Controller Tests

Cover:

- Login success/failure, session creation, logout, and role redirects.
- Anonymous redirect and wrong-role denial.
- Admin CRUD for each managed resource.
- Teacher scoping to assigned classrooms and students.
- Student scoping to the current student's records.
- Validation failure responses and flash messages.
- Enrollment, schedule, and progress workflows.
- Schedule status presentation for past, current, and future dates, including CSS class mapping.

## System Tests

Use Capybara/Selenium for a small number of high-value flows:

1. Admin logs in, creates a classroom, enrolls a student, and adds a schedule.
2. Teacher logs in and records progress for an assigned student.
3. Student logs in and sees the enrolled class, schedule, and progress note.
4. Student sees an authorization response when attempting another student's URL.

## Security and Quality Checks

Run:

```sh
bin/rails test
bin/rubocop
bin/brakeman
bin/bundler-audit check --update
```

Use `bin/rails db:prepare` before tests in a clean environment. Add regression tests whenever an authorization bug or data-integrity bug is fixed.

## Test Data

Prefer fixtures or factories only after the project establishes a convention. Seed data is for development/manual verification, not an implicit test dependency. Tests must create only the records needed for the behavior under test and must not depend on record ids.

## Definition of Green

The suite is green when model, request/controller, system, security, lint, migration, and boot checks pass, with no known authorization boundary uncovered by tests.
