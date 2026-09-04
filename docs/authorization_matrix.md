# Authorization Matrix

All permissions are enforced server-side. The UI may hide unavailable links, but it must not be the only protection.

| Resource/action | Admin | Teacher | Student |
|---|---|---|---|
| Login/logout | Own account | Own account | Own account |
| Admin dashboard | Full | Deny | Deny |
| Manage users | Full | Deny | Deny |
| Manage students | Full | Read assigned-class students | Read self only |
| Manage teachers | Full | Read assigned teacher context only | Read assigned teachers |
| Manage courses | Full | Read through assigned classes | Read through enrolled classes |
| Manage classrooms | Full | Read assigned classes | Read enrolled classes |
| Manage enrollments | Full | Read assigned class membership | Read own enrollment |
| Manage schedules | Full | Read assigned classes | Read enrolled classes |
| Create progress | Full | Assigned classes/students only | Deny |
| Edit progress | Full, subject to policy | Own progress records in assigned classes | Deny |
| Read progress/notes | Full | Assigned classes/students only | Own records only |
| Edit own profile | Allowed profile fields | Allowed profile fields | Allowed profile fields |

## Enforcement Rules

- Load `current_user` from the session, never from a request parameter.
- Require authentication for every non-public route.
- Require exact role for namespaced routes.
- For teachers, scope classroom and student queries through the current teacher's classrooms and verify enrollment before progress writes.
- For students, scope every query through `current_user.student`; do not accept an arbitrary student id for student-facing resources.
- Treat inactive/deactivated users and profiles as unable to perform operational writes.
- Return a friendly unauthorized response without revealing unrelated records.

## Required Security Tests

1. Anonymous user is redirected to login.
2. Student cannot open admin or teacher routes.
3. Teacher cannot open admin routes or another teacher's class.
4. Teacher cannot create/edit progress for an unassigned class or unenrolled student.
5. Student cannot read another student's profile, class, schedule, progress, or notes.
6. Student cannot POST/PATCH/DELETE progress or notes.
7. Non-admin users cannot change roles or administer users.
