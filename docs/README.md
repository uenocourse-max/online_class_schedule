# Online School Documentation

This folder is the source of truth for the Online School Management System MVP.

## Documents

- [Product Requirements Document](prd.md): product goals, scope, workflows, and acceptance criteria.
- [Implementation Plan](implementation_plan.md): phased delivery plan, checkpoints, and commands.
- [Architecture](architecture.md): Rails structure, request flow, authorization boundaries, and UI approach.
- [Data Model](data_model.md): entities, relationships, constraints, and modeling decisions.
- [Authorization Matrix](authorization_matrix.md): server-side permissions by role and resource.
- [Testing Strategy](testing_strategy.md): Minitest coverage, security cases, and verification commands.

## Current Baseline

- Rails: 8.1.3.1 in the lockfile
- Ruby: 4.0.6 from `.ruby-version`
- Database: SQLite3 in `storage/`
- Frontend: Importmap, Turbo Rails, Stimulus Rails, and Propshaft
- Test framework: Rails default Minitest with Capybara and Selenium available
- Current application state: MVP implementation complete for local development; production deployment configuration remains separate

## Working Agreements

1. Keep authorization on the server; navigation visibility is not a security boundary.
2. Prefer Rails conventions and existing dependencies before adding gems.
3. Run the focused checks after each phase, then the full suite before declaring completion.
4. Treat seed credentials as development-only and never reuse them in production.
5. Update these documents when an implementation decision changes scope or behavior.
