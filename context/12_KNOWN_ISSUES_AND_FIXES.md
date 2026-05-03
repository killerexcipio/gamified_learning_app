# Known Issues and Fixes from Prior Generated App

## Context

A Flutter app zip was generated during the chat. The user then reported issues after running `flutter pub get`.

Original artifact:

```text
rebelbase_flutter_demo.zip
```

Fixed artifact:

```text
rebelbase_flutter_demo_fixed.zip
```

## Issue 1 - Empty `features/activities` Folder

### Problem

The `features/activities` folder existed but was empty.

This was wrong because Activities are a core feature.

### Fix

Added:

```text
lib/features/activities/activity_feed_view.dart
lib/features/activities/activities_screen.dart
```

### Expected Result

- Activities feature folder is not empty.
- Activity feed is reusable.
- Hub screen can use `ActivityFeedView`.
- Standalone `/activities` route exists.

## Issue 2 - Riverpod Provider Import Error

### Problem

In `app_repository.dart`, the provider looked like:

```dart
final appRepositoryProvider = ChangeNotifierProvider<AppRepository>((ref) {
  throw UnimplementedError('AppRepository is overridden in main.dart');
});
```

It appeared red in the user's editor.

The project used:

```yaml
flutter_riverpod: ^3.3.1
```

In Riverpod 3, `ChangeNotifierProvider` belongs to the legacy API import.

### Fix

Use:

```dart
import 'package:flutter_riverpod/legacy.dart';
```

instead of relying on:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

for `ChangeNotifierProvider`.

### Alternative Future Fix

Refactor away from `ChangeNotifierProvider` to modern Riverpod notifiers.

Do this later only if desired.

## Issue 3 - Hub Label on Posts

### Problem

Post cards could show the currently active hub name instead of the actual post hub.

### Fix

Added repository helper:

```dart
Hub hubById(String id)
```

Updated `ActivityPostCard` to resolve and show the post's actual hub.

## Issue 4 - Project Persistence

### Problem

Created projects were not saved to Hive/local cache.

### Fix

Added:

```dart
Project.toJson()
Project.fromJson()
```

Updated repository load/persist logic so created projects survive app restarts.

## Issue 5 - Verification Not Run in Environment

### Problem

The environment used to generate the zip did not have Flutter installed, so `flutter analyze` and APK compile could not be executed there.

### Required Local Verification

On local machine, run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

If VS Code still shows stale red underlines after replacing files:

```text
Dart: Restart Analysis Server
```

## Watchlist for Codex

Codex should specifically inspect:

```text
lib/core/app_repository.dart
lib/core/models.dart
lib/app/router.dart
lib/features/activities/
lib/features/hub/hub_screen.dart
lib/widgets/activity_post_card.dart
pubspec.yaml
```

## Do Not Regress

Do not accidentally:

- Remove `features/activities` implementation.
- Reintroduce incorrect Riverpod import.
- Break project persistence.
- Auto-create Activity posts when Builder answers publish.
- Allow students to see unreleased scores.
- Allow non-project members to edit/publish Builder answers.
