# Architecture

## System Shape

A server-rendered Rails monolith using MVC, Active Record, session authentication, and namespaced controllers. HTML is the primary interface. Turbo handles navigation and focused partial updates; Stimulus is reserved for small client-side interactions such as filters, toggles, and optional progress visualization.

## Layers

- **Models:** associations, validations, scopes, enums/inclusion rules, and domain-level authorization predicates where useful.
- **Controllers:** authenticate, authorize, load scoped resources, and choose responses. Controllers do not decide ownership from untrusted ids.
- **Views/partials:** role-specific pages with shared layout, navigation, forms, errors, flash messages, and empty states.
- **Helpers:** navigation labels, role-aware links, formatting, and presentation-only calculations such as deriving schedule status from the current date.
- **Services:** introduce only for genuinely multi-record workflows that would otherwise make a controller unclear, such as enrollment changes if the transaction grows.
- **Jobs:** not required for the MVP.

## Request Flow

1. Request enters an application or role namespace.
2. Authentication concern loads the session user or redirects to login.
3. Authorization concern verifies the required role.
4. Controller queries through the current user's permitted association.
5. Model validations and database constraints protect writes.
6. HTML/Turbo response renders the result and flash feedback.

## Namespaces and Routes

- `Admin`: dashboard and complete resource management.
- `Teacher`: dashboard, assigned classes/students/schedules, and scoped progress.
- `Student`: dashboard, own profile/classes/schedules/progress.
- `SessionsController`: login/logout.

Use RESTful resources where a resource is managed. Keep dashboard and role-specific read-only pages as explicit collection/member routes.

## Schedule Status Presentation

Schedule state is intentionally derived at render time through `ApplicationHelper#schedule_status`:

- Past `schedule_date`: `Selesai`
- Current `schedule_date`: `Hari ini`
- Future `schedule_date`: `Akan datang`

The status is not persisted, so it changes automatically when the calendar date changes and cannot become stale. `schedule_status_class` maps the same value to a CSS-safe class for consistent visual treatment across admin, teacher, and student schedule lists.

## Authorization Boundary

Authorization is implemented in controller concerns/helpers and enforced before resource loading. The resource query itself is scoped:

- Admin uses unrestricted school collections.
- Teacher starts from `current_user.teacher.classrooms` or enrolled students in those classrooms.
- Student starts from `current_user.student` and its associations.

A hidden link or sidebar item is never considered authorization. Unauthorized access returns a redirect with a flash message or an appropriate 404-style response where revealing existence would expose private data.

## Frontend Direction

Use the existing Rails asset stack. The initial generated project does not include Tailwind configuration, so styling should begin with maintainable application CSS. Add Tailwind only after confirming the setup and package strategy; it is not needed to satisfy the core server-rendered MVP. Keep layouts dense and scan-friendly: sidebar, top navigation, metrics, tables, forms, and clear mobile behavior.

## Operational Baseline

- SQLite databases are stored under `storage/` per `config/database.yml`.
- Rails health endpoint is `/up`.
- Production uses separate SQLite databases for primary, cache, queue, and cable as configured.
- Security checks use Brakeman and Bundler Audit already present in development/test dependencies.
