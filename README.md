# Online School

Online School is a Rails application for managing students, teachers, courses, classes, enrollment, schedules, and student progress.

## Stack

- Ruby 4.0.6
- Rails 8.1.3.1
- SQLite3
- Hotwire with Turbo and Stimulus
- Importmap and Propshaft
- Minitest
- bcrypt password hashing

## Setup

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open `http://localhost:3000` and sign in. The health check is available at `http://localhost:3000/up`.

## Development Accounts

The seed data creates these development-only accounts. Every account uses the password `password`.

| Role | Email |
|---|---|
| Admin | `admin@example.com` |
| Teacher | `teacher@example.com` |
| Teacher | `suzuki@example.com` |
| Student | `student@example.com` |
| Student | `andi@example.com` |
| Student | `siti@example.com` |

Never use these credentials outside local development. Change or remove them before deploying.

## Test and Quality Checks

```sh
bin/rails test
bin/rubocop
bin/brakeman
bin/bundler-audit check --update
```

The seed file is idempotent and can be run repeatedly with `bin/rails db:seed`. It uses stable email, name, classroom, schedule, and progress-date keys to avoid duplicate development records.

## Main Routes

- `/login`: sign in
- `/admin/dashboard`: admin overview and school management
- `/teacher/dashboard`: assigned classes, students, schedules, and progress
- `/student/dashboard`: enrolled classes, schedule, progress, and profile
- `/up`: application health check

Schedule lists automatically label each entry as `Selesai`, `Hari ini`, or `Akan datang` based on its date. The status is calculated at display time and is not stored in the database.

## Documentation

Project requirements, architecture, data model, authorization rules, testing strategy, and phased delivery notes live in [docs/README.md](docs/README.md).

## Current Scope

Completed: database foundation, authentication, shared responsive shell, admin operations, teacher workflows, student workflows, automatic schedule status labels, and development seed data.

Remaining polish is intentionally lightweight: optional charting, richer weekly calendar presentation, and production deployment configuration can be added after the core workflows are reviewed.
