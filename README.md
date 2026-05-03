# RebelBase Flutter Android Demo

This is a demo-grade Flutter Android app for a RebelBase-style platform: social activities, hubs, projects, guided Builders, published project pages, faculty scoring, score release, admin panels, and invite links.

The uploaded app details were used only as loose product inspiration; the implementation is a fresh Flutter demo scaffold.

## What is implemented

- Login, signup, and demo invite screens
- Bottom navigation: Home, Hub, Builders, Projects, Profile
- Expandable bottom sub-menu chips for Hub, Builders, Projects, and Profile
- Activity feed with post types: Post, Idea, Question, Resource, Announcement
- Manual post creation with comments and kudos
- Hub views: Activities, Groups, Events, Members
- Project list, project creation, project detail, team, published Builder answers, released scores
- Builder tracks, Builder cards, lesson reader, progress dots, shared project answer editor, publish flow
- Any project member can save/publish one shared answer per Builder
- Admin/faculty panel: users, invites, builder CMS, review queue, score release, analytics
- Hive-backed offline demo state and pending sync counter
- Supabase schema and seed SQL for productionizing the backend
- Android manifest with internet permission, media permissions, and `https://app.rebelbase.co/invite/...` app link intent filter

## Current implementation mode

The app runs in a local demo mode backed by `AppRepository` and Hive. Supabase credentials can be passed through Dart defines and the SQL schema is included under `supabase/`, but the UI currently uses the local repository so it is immediately usable as a demo without a backend.

## Run

```bash
flutter pub get
flutter run -d android
```

Optional Supabase config:

```bash
flutter run -d android \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY
```

## Supabase setup

1. Create a Supabase project.
2. Open the SQL editor.
3. Run `supabase/schema.sql`.
4. Run `supabase/seed_demo.sql`.
5. Create these storage buckets if you want real uploads:
   - `avatars`
   - `institution-logos`
   - `hub-logos`
   - `project-logos`
   - `activity-images`
   - `builder-answer-images`
   - `builder-content-images`

## Demo invite links

```text
https://app.rebelbase.co/invite/mgr-multi-8KQ2-BRACU-SOL
https://app.rebelbase.co/invite/mgr-bracu-4XP9-DEMO
https://app.rebelbase.co/invite/fac-bracu-H7LM-DEMO
https://app.rebelbase.co/invite/fac-solscore-P2VA-DEMO
https://app.rebelbase.co/invite/stu-bracu-A1F9-DEMO
https://app.rebelbase.co/invite/stu-bracu-B2G8-DEMO
https://app.rebelbase.co/invite/stu-sol-C3H7-DEMO
https://app.rebelbase.co/invite/stu-sol-D4J6-DEMO
https://app.rebelbase.co/invite/stu-builders-E5K5-DEMO
https://app.rebelbase.co/invite/stu-builders-F6L4-DEMO
```

## Recommended next production steps

1. Replace local `AppRepository` mutations with Supabase gateway calls.
2. Keep Hive as local cache and sync queue.
3. Add Supabase Storage uploads for post images, project logos, and Builder answer images.
4. Harden RLS policies with organization-specific edge cases.
5. Add push notifications after the in-app notification flow is stable.
