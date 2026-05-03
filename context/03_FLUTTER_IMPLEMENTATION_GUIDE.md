# Flutter Implementation Guide

## Target

Flutter Android demo app.

The app should remain web-capable in architecture if convenient, but Android is the priority.

## Recommended Stack

```yaml
flutter_riverpod: state management
go_router: routing and auth redirects
supabase_flutter: Supabase Auth/API/Storage client
hive: simple local cache
hive_flutter: Flutter integration for Hive
image_picker: post and answer image selection
uuid: client-side demo IDs
intl: date/time formatting
```

## Current Project Note

The previous generated app used:

```yaml
flutter_riverpod: ^3.3.1
```

If using `ChangeNotifierProvider`, import from:

```dart
import 'package:flutter_riverpod/legacy.dart';
```

Not:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

unless the provider is refactored away from `ChangeNotifierProvider`.

## Folder Structure

Recommended structure:

```text
lib/
  main.dart
  app/
    app.dart
    router.dart
    theme.dart
  core/
    app_repository.dart
    models.dart
    permissions.dart
    supabase_service.dart
    cache_service.dart
    sync_service.dart
    constants/
      app_colors.dart
  features/
    auth/
      login_screen.dart
      signup_screen.dart
      invite_screen.dart
    home/
      home_screen.dart
    activities/
      activity_feed_view.dart
      activities_screen.dart
    hub/
      hub_screen.dart
      groups_view.dart
      events_view.dart
      members_view.dart
    builders/
      builders_screen.dart
      builder_detail_screen.dart
      builder_reader_screen.dart
      answer_editor_screen.dart
    projects/
      projects_screen.dart
      project_detail_screen.dart
      project_page_view.dart
    admin/
      admin_screen.dart
      review_queue_screen.dart
      builder_editor_screen.dart
      invite_manager_screen.dart
    profile/
      profile_screen.dart
  widgets/
    common_widgets.dart
    activity_post_card.dart
    create_post_sheet.dart
    bottom_nav_with_submenu.dart
    progress_dots.dart
```

## State Management

For the demo, a single `AppRepository` can be acceptable if organized, but avoid letting it become unmaintainable.

Current/simple approach:

```text
AppRepository extends ChangeNotifier
Provider exposes AppRepository
Screens call repo methods
Repo persists to Hive
Repo optionally syncs with Supabase
```

Better future approach:

```text
Feature repositories
Feature controllers/notifiers
Immutable models
Supabase data sources
Local cache data sources
```

## Route Map

Recommended `go_router` paths:

```text
/login
/signup
/invite/:token
/home
/activities
/hub
/hub/groups
/hub/events
/hub/members
/builders
/builders/:builderId
/builders/:builderId/read/:lessonId
/builders/:builderId/answer
/projects
/projects/:projectId
/projects/:projectId/page
/projects/:projectId/scores
/profile
/admin
/admin/users
/admin/invites
/admin/builders
/admin/reviews
/admin/scores
```

## Model Overview

Core models:

```text
Profile
Institution
InstitutionMember
Hub
HubMember
Project
ProjectMember
BuilderPath
BuilderTrack
Builder
BuilderTopic
BuilderLesson
BuilderProgress
BuilderAnswer
BuilderAnswerImage
AnswerScore
ProjectScore
ActivityPost
ActivityComment
PostKudos
Notification
Invite
```

Each persisted model should implement:

```dart
toJson()
fromJson()
copyWith()
```

For demo speed, hand-written JSON serialization is acceptable. For a larger app, consider `freezed` and `json_serializable`.

## Repository Responsibilities

The repository should expose methods such as:

```dart
// Auth/session
loginDemoUser(...)
signUp(...)
redeemInvite(...)
logout()

// Activities
createPost(...)
updatePost(...)
deletePost(...)
addComment(...)
toggleKudos(...)
postsForHome()
postsForHub(hubId)

// Projects
createProject(...)
addProjectMember(...)
removeProjectMember(...)
projectsForCurrentUser()
visibleProjectsForHub(hubId)

// Builders
builderPathsForHub(hubId)
buildersForProject(projectId)
markLessonComplete(...)
saveBuilderAnswerDraft(...)
publishBuilderAnswer(...)

// Scores
scoreBuilderAnswer(...)
scoreProject(...)
releaseScore(...)
releasedScoresForProject(...)

// Admin
createInstitution(...)
assignInstitutionManager(...)
createHub(...)
inviteUser(...)
addUserToHub(...)
createBuilderPath(...)
assignBuilderPathToHub(...)
```

## Supabase Integration Strategy

For the demo, the app can run in local seeded mode if Supabase credentials are missing.

Suggested behavior:

```text
If SUPABASE_URL and SUPABASE_ANON_KEY exist:
  initialize Supabase
  use remote APIs where implemented
else:
  use local demo data and Hive persistence
```

Define with:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_KEY
```

## Offline Cache Strategy

Use Hive boxes:

```text
session
profiles
institutions
hubs
projects
builder_content
builder_progress
builder_answers
activity_posts
notifications
sync_queue
```

See `05_OFFLINE_SYNC_AND_LOCAL_CACHE.md`.

## Error Handling

Use user-friendly error messages.

Examples:

```text
Invite expired.
You do not have access to this hub.
This score has not been released yet.
Another project member updated this answer. Please review before syncing.
```

## Formatting and Quality

Use:

```bash
dart format .
flutter analyze
flutter test
```

Avoid:

- Business logic inside large widget build methods.
- Repeated hardcoded colors.
- Repeated card layouts when reusable widgets exist.
- Incorrect access checks in UI only. UI checks are not a substitute for RLS.

## Android Notes

Android manifest should support invite/deep links, for example:

```text
https://app.rebelbase.co/invite/{token}
```

The app can also support a custom scheme for local demo testing:

```text
rebelbase://invite/{token}
```

## Productionization Later

To move beyond demo:

- Split repository by feature.
- Add generated models.
- Add API/data source layer.
- Add robust Supabase Edge Functions.
- Add RLS test suite.
- Add integration tests.
- Add proper image upload retry handling.
- Add push notifications.
