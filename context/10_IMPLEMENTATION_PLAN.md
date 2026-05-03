# Implementation Plan

## Guiding Principle

Build a complete usable demo before optimizing for enterprise-grade architecture.

Prioritize:

1. Student journey.
2. Activity feed.
3. Projects.
4. Builders.
5. Publishing to Project Page.
6. Faculty scoring and release.
7. Admin/invite management.
8. Offline caching.

## Phase 0 - Project Hygiene

Tasks:

- Verify Flutter project opens.
- Run `flutter pub get`.
- Fix Riverpod import if needed.
- Ensure `features/activities` is not empty.
- Run `dart format .`.
- Run `flutter analyze`.
- Run `flutter test`.

Acceptance:

- No analyzer errors.
- App launches.
- Bottom navigation works.

## Phase 1 - App Shell and Auth

Tasks:

- App theme.
- Bottom navigation.
- Horizontal sub-menu chips.
- Login screen.
- Signup screen.
- Invite route `/invite/:token`.
- Waiting-for-access screen.
- Demo seeded users.

Acceptance:

- User can login as demo student/faculty/manager/admin.
- Invite link screen displays role/scope.
- App routes based on auth state.

## Phase 2 - Institutions, Hubs, Members

Tasks:

- Institution model.
- Hub model.
- Membership model.
- Hub screen.
- Members directory.
- Groups placeholder/list.
- Events placeholder/list.

Acceptance:

- User can switch/select hub.
- Members appear with role/powers.
- Multi-hub user sees relevant feeds.

## Phase 3 - Activities

Tasks:

- `features/activities` reusable feed.
- Post composer.
- Post type selector.
- Feed filters.
- Kudos.
- Comments.
- Image attachment support.
- Home aggregate feed.
- Hub scoped feed.

Acceptance:

- Student can post manually.
- Post persists locally.
- Comments/kudos work.
- Filters work.
- Publishing Builder answer does not auto-post.

## Phase 4 - Projects

Tasks:

- Project list.
- Project creation.
- Project detail.
- Team members.
- Project Page public view.
- Project visibility.
- Project persistence.

Acceptance:

- Student creates project.
- Project appears after app restart.
- Team members visible.
- Other students can view Project Page but not drafts.

## Phase 5 - Builders

Tasks:

- Builder Path/Track/Builder models.
- Builder cards with progress dots.
- Builder detail and topic list.
- Lesson reader.
- Answer editor.
- Text/image answer support.
- Save draft.
- Publish.
- Published answer appears on Project Page.

Acceptance:

- User can complete a Builder flow end-to-end.
- Draft persists.
- Published answer appears in Project Page.
- One answer per project per Builder.
- Any project member can publish.

## Phase 6 - Offline Cache

Tasks:

- Hive boxes.
- Cache Builder content.
- Cache Builder progress.
- Cache answer drafts.
- Sync queue model.
- Pending sync UI.
- Disable publish while offline.

Acceptance:

- User can read cached lessons offline.
- User can save draft/progress offline.
- Draft persists after restart.
- Pending sync state appears.

## Phase 7 - Admin and Invites

Tasks:

- Admin panel.
- Institution management.
- Hub management.
- User search/manual add.
- Invite management.
- Generate 10 demo invite links.
- Builder management screen.
- Assign Builder Paths to hubs.

Acceptance:

- Admin creates institution/hub in demo state.
- Manager can invite/add faculty/student.
- Invite links redeem correctly.
- Builder assignments appear for students.

## Phase 8 - Faculty Scoring

Tasks:

- Faculty review queue.
- Answer score form.
- Project score form.
- Save draft/submitted scores.
- Release scores.
- Student score view.
- Notifications for release.

Acceptance:

- Faculty scores Builder answer and project.
- Student cannot see score before release.
- Authorized user releases score.
- Student sees released score/feedback.

## Phase 9 - Supabase Integration

Tasks:

- Create Supabase schema.
- Seed demo data.
- Implement profile auth sync.
- Implement RLS policies.
- Implement invite redemption function.
- Implement storage uploads.
- Replace local-only repo calls gradually.

Acceptance:

- Remote auth works.
- Basic remote data loads.
- RLS blocks unauthorized access.
- Invite redemption is transactional.

## Phase 10 - Polish

Tasks:

- Improve empty states.
- Loading/error states.
- Better responsive behavior.
- Search.
- Notifications screen.
- Basic analytics cards.
- QA pass.

Acceptance:

- Demo can be shown end-to-end without manual database editing.
- Common errors have clear UI feedback.
- App feels coherent and polished.

## Suggested First Codex Tasks

1. Run analyzer and fix compile errors.
2. Make `features/activities` complete and reusable.
3. Create or verify bottom navigation with sub-menu chips.
4. Verify project persistence.
5. Implement Builder answer images if missing.
6. Implement score release visibility correctly.
7. Add Supabase schema files and RLS comments.
8. Add demo invite seed file.
