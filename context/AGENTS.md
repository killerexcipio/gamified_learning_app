# AGENTS.md - Instructions for Codex and Coding Agents

## Mission

Build and maintain a demo-grade Flutter Android app that replicates the core RebelBase experience:

- Activity feeds where users can post freely.
- Institutions, hubs, members, groups, and events.
- Student projects and team collaboration.
- Guided coursework called Builders.
- Shared Builder answers that can be published to Project Pages.
- Faculty scoring at both Builder-answer and project level.
- Score release workflow.
- Admin and institution-manager tools.
- Supabase backend plan.
- Offline caching for Builder progress and drafts.

## Non-Negotiable Product Decisions

1. Backend target is **Supabase**, not Firebase.
2. The uploaded `.txt` notes are inspiration only, not source of truth.
3. Flutter target is Android first.
4. The app should stay demo-grade but usable.
5. Use a decently organized codebase, not a throwaway prototype.
6. Use bottom navigation, not a web-style sidebar.
7. Some bottom tabs have an upward arrow that reveals a horizontal sub-menu above the bottom bar.
8. Students manually post Activity updates. Publishing a Builder answer must **not** automatically create an Activity post.
9. Any project member can edit and publish the one shared answer for a Builder.
10. A project has exactly one answer per Builder.
11. Builder answers can contain text and images only.
12. Students can view other students' Project Pages, but not unpublished drafts or unreleased scores.
13. Faculty can see all relevant student contents and scores according to institution-manager-controlled scope.
14. Faculty scoring exists both per Builder answer and per whole project.
15. Scores are hidden until released by authorized faculty/manager/admin.
16. Generate demo invite links by role/position.
17. Use offline caching for Builder progress and drafts.

## Flutter Stack

Use the current project stack unless deliberately refactoring:

- `flutter_riverpod`
- `go_router`
- `supabase_flutter`
- `hive` / `hive_flutter`
- `image_picker`
- `uuid`
- `intl`

The existing demo used `ChangeNotifierProvider`. With Riverpod 3, import it from:

```dart
import 'package:flutter_riverpod/legacy.dart';
```

Do not reintroduce the incorrect import if the provider remains `ChangeNotifierProvider`.

## Required Verification Commands

After meaningful code changes, run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

If the environment cannot run Flutter, state that clearly and still perform static inspection.

## Architecture Rules

Use feature-first organization:

```text
lib/
  app/
  core/
  features/
    auth/
    home/
    activities/
    hub/
    builders/
    projects/
    admin/
    profile/
  widgets/
```

Keep responsibilities clear:

- `app/`: app shell, router, theme.
- `core/`: models, repository, services, permissions, cache.
- `features/*`: screen-specific UI and feature logic.
- `widgets/`: reusable UI components.

Avoid huge monolithic files when adding new behavior. Prefer extracting widgets and helper methods once a file grows past roughly 400-600 lines.

## UI Rules

Maintain the mobile RebelBase visual identity:

- Dark teal/nav shell.
- Light content surfaces.
- Teal/cyan accents.
- Rounded cards.
- Activity feed cards.
- Progress dots for Builders.
- Horizontal chip sub-menus above bottom navigation.

Bottom navigation:

```text
Home | Hub | Builders | Projects | Profile
```

Expandable sub-menu examples:

```text
Hub: Activities | Groups | Events | Members
Builders: Tracks | In Progress | Published | Scores
Projects: My Projects | Joined | Explore | Drafts
Profile: Profile | Settings | Invites | Admin Mode
```

## Backend Rules

Use Supabase tables and RLS aligned with `04_SUPABASE_SCHEMA_AND_RLS.md`.

Do not rely on a single `institution_id` on profiles as the membership source of truth. Users can belong to multiple institutions and hubs. Use membership tables.

Core membership tables:

```text
institution_members
hub_members
project_members
```

## Activity Feed Rules

Activities are central, not optional. Support these post types:

```text
post
idea
question
resource
announcement
```

Post interactions:

```text
kudos
comments
image attachments
filters
hub-specific feeds
home aggregate feed
```

Do not auto-create Activity posts when Builder answers are published.

## Builder Rules

Builder hierarchy:

```text
Builder Path
  -> Track
    -> Builder
      -> Topics
        -> Lessons
      -> Answer Prompt
```

Answer flow:

```text
Read lessons
Save progress
Write shared project answer
Attach images
Save draft
Publish
Published answer appears on Project Page
Faculty scores answer
Score is released later
```

## Admin Rules

Admin and manager tools must support:

- Create institutions.
- Assign managers to one or multiple institutions.
- Create hubs.
- Invite faculty and students.
- Add signed-up students to hubs/institutions.
- Create/edit Builder content.
- Assign Builder Paths to hubs.
- View student/project progress.
- Score and release scores.

## Safety Against Scope Creep

Do not build these in the first demo unless explicitly requested:

- Billing/subscriptions.
- Enterprise analytics dashboards beyond simple demo metrics.
- Full event competition judging system.
- Real-time collaborative rich text editing.
- Full offline social feed posting.
- Nested comment threads.
- Video/file/audio Builder answers.
- Public internet showcase with SEO.

## When Unsure

Prioritize:

1. Usable student flow.
2. Usable Builder flow.
3. Usable project page flow.
4. Usable admin/faculty review flow.
5. Clean architecture.
6. Demo reliability.
