# Testing and QA Plan

## Required Local Commands

Run after code changes:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

If Android emulator/device is available:

```bash
flutter run -d android
```

## Static Checks

Verify:

- No analyzer errors.
- No missing imports.
- No empty feature folders that are referenced by routes.
- No use of incorrect Riverpod imports for `ChangeNotifierProvider`.
- All models used in Hive persistence have `toJson/fromJson` or equivalent.
- Routes compile and screen constructors match.

## Smoke Test Checklist

### App Launch

- App opens.
- Theme loads.
- No crash on startup.
- Bottom navigation visible.

### Auth

- Login screen works.
- Signup screen works.
- Invite screen route works.
- Invalid invite shows clear error.
- Used/expired invite shows clear error.

### Navigation

- Home tab opens.
- Hub tab opens.
- Builders tab opens.
- Projects tab opens.
- Profile tab opens.
- Sub-menu arrow opens horizontal chip bar.
- Sub-menu chips switch views.

### Activities

- Home feed shows posts.
- Hub feed shows hub-specific posts.
- Create post works.
- Create idea works.
- Create question works.
- Create resource works.
- Announcement restricted to staff/admin where implemented.
- Kudos toggles on/off.
- Comments can be added.
- Post persists after app restart.

### Projects

- Create project.
- Project appears in My Projects.
- Project persists after restart.
- Project detail opens.
- Team tab shows members.
- Project Page shows published answers only.

### Builders

- Builder list shows tracks/cards.
- Progress dots render correctly.
- Builder detail opens.
- Lesson reader opens.
- Mark lesson complete updates progress.
- Answer editor opens.
- Save draft works.
- Draft persists after restart.
- Publish works online.
- Published answer appears on Project Page.
- One answer per project per Builder is enforced.

### Offline Cache

- Cached lessons available offline.
- Progress saves offline.
- Draft saves offline.
- Publish is disabled offline.
- Pending sync indicator appears.

### Scoring

- Faculty opens review queue.
- Faculty scores Builder answer.
- Faculty scores whole project.
- Student cannot see unreleased score.
- Authorized user releases score.
- Student can see released score.

### Admin/Manager

- Admin creates institution.
- Admin assigns manager to multiple institutions.
- Manager creates hub.
- Manager invites faculty/student.
- Manager manually adds signed-up user.
- Builder Path can be assigned to hub.

## RLS Tests for Supabase

Test with different users:

### Student

Should pass:

- Read own profile.
- Read own hubs.
- Read hub posts.
- Create post in own hub.
- Read Project Page of visible project.
- Edit own project Builder answer if project member.
- Read released scores for own project.

Should fail:

- Read unreleased scores.
- Read other project drafts.
- Manage institution.
- Insert score.
- Create institution.

### Faculty

Should pass:

- Read assigned hub students/projects.
- Read Builder answers in scope.
- Insert/update scores in scope.

Should fail:

- Score outside assigned scope.
- Create institution unless also manager/admin.

### Institution Manager

Should pass:

- Manage assigned institutions.
- Create hubs.
- Add users.
- Generate invites.
- Release scores in assigned institutions.

Should fail:

- Manage unassigned institutions.

### Admin

Should pass:

- Manage all.

## Edge Cases

- User belongs to multiple institutions.
- User belongs to multiple hubs.
- Manager assigned to multiple institutions.
- Student signs up without invite.
- Invite max uses reached.
- Project member edits answer while another member edited remotely.
- Score exists but unreleased.
- Project has no published answers.
- Hub has no posts.
- Builder has no topics.
- Image upload fails.

## Demo Readiness Checklist

Before demo:

- Seed at least one admin, manager, faculty, and several students.
- Seed BRACU institution.
- Seed BRACU hub.
- Seed SOL Happiness Index project.
- Seed Activity posts.
- Seed Builder Path with at least one track and several Builders.
- Seed one draft answer.
- Seed one published answer.
- Seed one unreleased score.
- Seed one released score.
- Seed 10 invite links.

## Manual QA Script

Use this story:

```text
1. Login as admin.
2. Show institutions and invite links.
3. Login as manager.
4. Create or open BRACU hub.
5. Show faculty/students.
6. Login as student.
7. Create Activity post.
8. Create/open project.
9. Open Builders.
10. Read Target and Market lesson.
11. Save/publish answer.
12. Show answer on Project Page.
13. Login as faculty.
14. Score answer and project.
15. Login as manager/admin.
16. Release score.
17. Login as student.
18. View released score.
```
