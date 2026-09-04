# Implementation Plan

## Status

Phase 1 complete. The repository now has the school-domain schema and model foundation. Execute the remaining phases in order and keep each phase green before starting the next.

### Phase 1 Gate Record

- Status: passed on 2026-09-04.
- Added bcrypt 3.1.22 for `has_secure_password`.
- Added the eight domain tables, foreign keys, indexes, check constraints, and active-enrollment partial uniqueness.
- Added Active Record associations, statuses, scopes, and cross-record validations.
- Verification: `bin/rails test` passed with 7 tests and 35 assertions; `bin/rails db:schema:load RAILS_ENV=test` passed; `bin/rubocop` passed; `bin/brakeman` reported zero warnings.

### Phase 2 and 3 Gate Record

- Status: passed on 2026-09-04.
- Added bcrypt-backed session login/logout, session reset on login/logout, normalized email lookup, role redirects, and centralized authentication/authorization concerns.
- Added root, login/logout, and role dashboard routes with server-side wrong-role denial.
- Added shared responsive layout with role-aware navigation, flash messages, reusable form-error and empty-state partials, dashboard shells, and application CSS using the existing Propshaft stack.
- Verification: focused authentication tests passed with 6 tests and 33 assertions; full suite passed with 13 tests and 68 assertions; `bin/rubocop` passed; `bin/brakeman` reported zero warnings.

### Current Implementation Notes

- Dashboard metrics and resource navigation targets are intentional placeholders until Phase 4 admin operations are implemented.
- Tailwind was not added because the generated project has no Tailwind setup; Phase 3 uses maintainable application CSS with Propshaft.

### Phase 4 Gate Record

- Status: passed on 2026-09-04.
- Added admin-only RESTful CRUD for students, teachers, courses, classrooms, schedules, and student progress.
- Added enrollment management with active enrollment creation and drop behavior.
- Added live admin dashboard counts, today's schedules, recent progress context, and students needing attention.
- Added admin search/status filtering, association-backed forms, validation feedback, empty states, and responsive tables.
- Verification: focused admin tests passed with 6 tests and 29 assertions; full suite passed with 19 tests and 97 assertions; `bin/rubocop` passed; Brakeman parsed 41 templates with zero errors and zero security warnings.

### Current Implementation Notes

- Teacher and student workflows remain for Phases 5 and 6.
- Admin navigation links for resources not yet implemented by their later phases remain intentionally inactive until those routes exist.

### Phase 5 Gate Record

- Status: passed on 2026-09-04.
- Added teacher-scoped dashboard, assigned classes, assigned students, schedules, and progress history pages.
- Added teacher progress creation and editing with ownership derived from the signed-in teacher and enrollment/classroom checks enforced by the model.
- Added server-side denial for other teachers' classes, students, and progress records.
- Connected teacher navigation to the implemented routes and replaced dashboard placeholders with live summaries.
- Verification: focused teacher tests passed with 5 tests and 24 assertions; full suite passed with 24 tests and 121 assertions; `bin/rubocop` passed; Brakeman parsed 51 templates with zero errors and zero security warnings.

### Current Implementation Notes

- Student-facing workflows remain for Phase 6.
- Teacher progress forms intentionally do not expose a teacher selector; the current teacher is assigned server-side.

### Phase 6 Gate Record

- Status: passed on 2026-09-04.
- Added student-scoped dashboard, enrolled classes, schedules, progress history, progress details, and profile pages.
- Added live average score, latest progress, class, and upcoming schedule summaries.
- Added profile editing limited to phone, address, birth date, and gender.
- Enforced privacy by deriving all student queries from `current_user.student`; progress has no student mutation routes.
- Verification: focused student tests passed with 5 tests and 28 assertions; full suite passed with 29 tests and 149 assertions; `bin/rubocop` passed; Brakeman parsed 58 templates with zero errors and zero security warnings.

### Current Implementation Notes

- Seed data and final UX polish remain for Phase 7.
- The student dashboard gracefully renders an empty workspace for a role account without a linked student profile.

### Phase 7 Gate Record

- Status: passed on 2026-09-04.
- Added idempotent development seeds for admin, teachers, students, courses, classes, enrollments, schedules, and dated progress history.
- Connected all admin, teacher, and student navigation items to implemented routes.
- Added setup, test, security, development-account, and seed-repeatability guidance to the README.
- Verification: `bin/rails db:seed` ran twice with identical record totals; full suite, RuboCop, and Brakeman remain green.

### Current Implementation Notes

- Seed runs against the existing development database and preserve unrelated records; reset the development database separately when a clean dataset is needed.
- Optional richer charting and weekly calendar presentation remain outside the completed core workflow.

### Phase 8 Gate Record

- Status: passed on 2026-09-04.
- Verified database preparation, Rails boot, routes, seed data, automated tests, lint, dependency audit, and security scan.
- Live smoke test passed: `/login` rendered, `/up` returned HTTP 200, admin login returned HTTP 302, and the authenticated admin dashboard rendered.
- Verification: 29 tests and 149 assertions passed; RuboCop reported no offenses; Brakeman reported zero warnings; Bundler Audit found no vulnerabilities.

### Release Readiness

- MVP is ready for local development and manual workflow review.
- Production deployment still requires production credentials/secrets, environment configuration, and operational infrastructure review.

### Schedule Status Update

- Added automatic schedule labels: `Selesai`, `Hari ini`, and `Akan datang`.
- Labels are derived from the current date and displayed consistently on admin, teacher, and student schedule lists.
- Added helper tests covering past, current, and future dates plus CSS class mapping.
- Verification: focused helper tests passed with 2 tests and 4 assertions; full suite passed with 31 tests and 153 assertions; RuboCop and Brakeman remained clean.

### System Test CI Fix

- Added `ApplicationSystemTestCase` and a login/dashboard smoke test under `test/system/`, fixing Rails' missing `test/system` load path error.
- Configured Selenium to honor `CHROME_BIN` and added explicit Chromium installation to the GitHub Actions system-test job.
- Local system-test execution requires Chrome/Chromium; the repository's non-browser suite remains independent of that binary.

## Phase 1: Foundation and database

1. Confirm runtime and dependency baseline.
2. Add `bcrypt` only if required by `has_secure_password` and bundle it.
3. Create migrations and models for User, Student, Teacher, Course, Classroom, Enrollment, Schedule, and StudentProgress.
4. Add enums or inclusion validations, associations, scopes, foreign keys, indexes, and the active-enrollment uniqueness constraint.
5. Implement cross-record validations for schedule ownership and progress enrollment.
6. Run `bin/rails db:migrate` and model tests.

**Gate:** schema loads cleanly; model and constraint tests pass.

## Phase 2: Authentication and authorization

1. Add session-based login/logout with `has_secure_password`.
2. Add authentication and role authorization concerns to `ApplicationController`.
3. Define role-aware redirects and unauthorized handling.
4. Add routes and request/controller tests for authentication and access boundaries.

**Gate:** unauthenticated, wrong-role, and valid-role cases pass server-side.

## Phase 3: Shared application shell

1. Add application layout, flash messages, navigation, and responsive styles.
2. Add role-aware navigation helpers.
3. Add reusable form error and empty-state partials.
4. Use the existing Propshaft/importmap/Turbo/Stimulus stack; avoid adding Tailwind unless the current Rails setup is deliberately extended and verified.

**Gate:** each role can render its shell on desktop and narrow viewport system tests.

## Phase 4: Admin operations

1. Add namespaced RESTful controllers and routes for students, teachers, courses, classrooms, enrollments, schedules, and progress.
2. Add dashboard queries and views.
3. Implement search/filter behavior using scoped Active Record queries.
4. Add CRUD forms, validation feedback, deactivation, enrollment management, and schedule/progress workflows.

**Gate:** admin CRUD and authorization integration tests pass.

## Phase 5: Teacher workflows

1. Add teacher dashboard, assigned classes, students, and schedules.
2. Scope every query through the current teacher's assignments.
3. Add progress create/edit/history views with enrollment checks.
4. Add teacher-focused request/system tests, including cross-class access denial.

**Gate:** a teacher can manage only their own assigned classroom progress.

## Phase 6: Student workflows

1. Add student dashboard, profile, classes, schedules, and progress pages.
2. Scope records through `current_user.student` and never accept a student id for ownership decisions.
3. Expose teacher notes through the student's own progress records.
4. Add privacy and mutation-denial tests.

**Gate:** a student can read only their own information and cannot mutate progress or notes.

## Phase 7: Seeds and polish

1. Make development seeds idempotent using stable email/name keys.
2. Add the documented admin, teacher, and student development accounts.
3. Improve empty states, responsive tables, accessible labels, and flash messages.
4. Add a lightweight progress summary/chart only if it improves the core workflow.

**Gate:** `bin/rails db:seed` can run repeatedly without duplicates.

## Phase 8: Verification and handoff

Run, in order:

```sh
bin/rails db:prepare
bin/rails test
bin/rubocop
bin/brakeman
bin/bundler-audit check --update
bin/rails runner 'puts Rails.application.routes.url_helpers.root_path'
```

Then manually verify login/logout, all dashboards, admin CRUD, enrollment, schedules, progress history, privacy boundaries, responsive layouts, and empty/validation states.

## Delivery Risks and Mitigations

- **Password hashing dependency:** verify the locked bcrypt version and platform support before implementing auth.
- **SQLite concurrency:** keep writes simple and enforce uniqueness in both model validation and the database.
- **Authorization drift:** centralize role checks and add denial tests beside each controller family.
- **Scope creep:** defer non-MVP features listed in the PRD until core workflows are stable.
