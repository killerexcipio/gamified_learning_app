# Complete Chat Context - RebelBase Flutter Android Demo

## 1. Initial Goal

The user first requested a detailed technical report of the `app.rebelbase.co` website and how it functions, including all features and how they work together.

A deep research process was initiated, but the user then provided direct screenshots from their logged-in experience. The screenshots became the practical basis for the product and UI analysis.

## 2. Screenshots Observed

The provided screenshots showed the following RebelBase web app areas after login:

### Dashboard / Home

- Left sidebar with RebelBase logo and navigation.
- Top search bar.
- User profile area.
- Notification bell.
- Project and Hub navigation.
- Activity feed for BRACU hub.
- Composer input: `Add your thoughts`.
- Feed filters:
  - All
  - Announcements
  - Posts
  - Q+A
- Feed card example: `MY GAME RESULT` with image/chart content.
- Posts can include text and media.

### Notifications / Explore Projects

- Explore project cards with:
  - Project icon/logo.
  - Location.
  - Category/industry.
- Notification panel with items such as:
  - Posts since last visit.
  - Replies to answers.
  - Kudos on posts.
- `Mark all as read` action.

### Project Builders Overview

- Project: `SOL Happiness Index`.
- Header: `Project Builders`.
- Track completion progress.
- Track sections such as:
  - Ideation
  - Validation
- Builder cards such as:
  - Problem
  - Solution
  - Core Team
  - Designing Your Organization's Role in Tackling Climate Change
  - Target and Market
  - Prototesting
  - Ecosystem
  - Competitive Landscape
- Cards show progress, dot indicators, and publish state.

### Project Page

- Project profile header with:
  - Logo.
  - Name.
  - Description.
  - Location.
  - Industry.
- Editable sections.
- Sidebar anchor menu with sections:
  - Brief
  - About
  - Team
  - Business Case
- Team members with roles:
  - Project Owner
  - Project Member
- Published Builder answers appear in the Project Page.

### Hub Members

- BRACU Hub Members page.
- Search by name or power.
- Member cards with:
  - Name.
  - Avatar.
  - Role labels.
  - Powers/skills tags.

### Groups

- BRACU Groups page.
- Search groups.
- Group card with:
  - Name.
  - Active status.
  - Project thumbnails/count.
  - Member thumbnails/count.
  - Manager thumbnails/count.

### Builder Detail / Lessons

- Builder card opens a Builder detail screen.
- Example Builder: `Target and Market`.
- Topics such as:
  - Target Market
  - Market Category
- Topic cards show progress counts and dots.
- Review + Publish is disabled until at least one topic is answered.
- Lesson reader shows reading content and a right-hand table of contents on web.
- `skip to answer` link.
- Answer page includes a text editor.
- After publish, the written answer appears on Project Page.

## 3. Uploaded Text File Constraint

The user uploaded `app_deets(1).txt` and explicitly said:

- The details may not be fully accurate.
- Do not use the codebase or code plan from the text directly.
- Only take a bit of inspiration about how the Android app may look.

This is critical. The text file is not authoritative. It is loose inspiration only.

## 4. User's Backend and Product Direction

The user then clarified the target implementation:

- Flutter Android app.
- Supabase for database/backend.
- Offline caching for progress and related state.
- Product is basically Instagram plus projects plus guided coursework called Builders.
- Demo product, not enterprise-grade.
- Must be perfectly usable with a decently organized codebase.

## 5. Product Model Established

The app is a demo-grade mobile version of RebelBase:

```text
Instagram-like social feed
+ institutions and hubs
+ projects and teams
+ guided Builders/coursework
+ project pages
+ faculty/admin review and scoring
+ invite-based access
+ offline progress caching
```

## 6. Questions Asked and User Answers

### Q1. Main demo goal

User answer: `4`.

Meaning: build a full end-to-end experience with social learning community, project platform, and institution management.

### Q2. Roles and institution managers

User answer: Admin can assign multiple institutions to a manager.

Final roles:

```text
admin
institution_manager
faculty
student
```

### Q3. Multi-institution membership

User answer: Multi.

Users can belong to multiple institutions.

### Q4. Multiple hubs

User answer: Yes.

Students can belong to multiple hubs.

### Q5. Signup flow

User answer: `3`.

Use hybrid signup:

- User signs up normally and waits to be added.
- User signs up through invite link/code.
- Admin/manager can manually add already signed-up users.

### Q6. Invite flow

User answer: `4`.

Use all invite approaches:

- Email invite / link.
- Invite code.
- Manual assignment.
- Add already signed-up user.

For the first demo, final decision became: generate 10 demo invite links by role/position.

### Q7. Institution / hub model

User answer: Yes.

Use this model:

```text
Institution
  -> Hubs
    -> Members
    -> Projects
    -> Activity Feed
    -> Assigned Builder Paths
```

### Q8. Faculty access

User answer:

- Variable access, managed by institution manager.
- Faculties can score and see contents and scores of all relevant students.
- Students can only see each other's Project Pages.
- If Builder answer is published, it appears on Project Page.
- Answer can contain images and text only.

### Q9. Bottom navigation

User answer:

```text
Home | Hub | Builders | Projects | Profile
```

### Q10. Bottom sub-menu idea

User liked the idea.

Use upward arrow on bottom tabs where necessary. Tapping it shows a horizontal sub-menu above the bottom bar.

### Q11-Q14. Activity feed and posting

User answer: Yes.

Final Activity features:

- Post types:
  - Post
  - Idea
  - Question
  - Resource
  - Announcement
- Users can create posts.
- Hub and Home feeds.
- Comments.
- Kudos.
- Image posts.
- Filters.

### Q15. Auto-post on Builder publish

User answer: No.

Publishing a Builder answer must **not** automatically create an Activity post. Students manually post if they want to share.

### Q16. Who can create projects

User answer: `3`.

Both students and faculty/managers/admin can create projects.

### Q17. Multiple students per project

User answer: Yes.

Projects support teams.

### Q18. Project Page

User answer: Yes.

Project Page includes basic profile, team, published Builder answers, and scores/feedback where released.

### Q19-Q24. Builders/offline/progress

User answer: Yes.

Builders should include:

- Tracks.
- Topics.
- Lessons/readings.
- Answer prompts.
- Progress tracking.
- Drafts.
- Publishing.
- Offline caching.

### Q25. Local cache database

User answer: Whichever is easy.

Final assistant recommendation: Hive-style local caching for the demo.

### Q26-Q42. Architecture, Supabase, RLS, Flutter packages

User answer: All yes.

Final choices:

- Supabase.
- RLS.
- Flutter.
- Riverpod.
- GoRouter.
- Feature-first architecture.
- Admin panel inside Android app.

### Final project rule clarification

User added:

> For the projects, any members can publish.

So any project member can publish the shared Builder answer.

## 7. Final Scoring Clarifications

The user answered the remaining questions:

### Should faculty scoring be per Builder answer, per project, or both?

Answer: Both.

### Should students see scores immediately or only after release?

Answer: Release.

Scores are hidden until released.

### Should Builder drafts be editable by all project members?

Answer: All members.

### Should a project have one answer per Builder or each student own answer?

Answer: One per Builder.

### Invites?

Answer: Generate 10 demo invite links by position.

## 8. Locked Rules

The locked product rules are:

1. Full end-to-end demo.
2. Flutter Android.
3. Supabase backend.
4. Offline caching for Builder progress and drafts.
5. Users can be in multiple institutions and hubs.
6. Admin can assign one manager to multiple institutions.
7. Institution manager can invite faculty and students.
8. Admin and institution manager can invite or add students to hubs/institutions.
9. Faculty access is variable and manager-controlled.
10. Faculty can score and view relevant student content/scores.
11. Students can only see other students' Project Pages, not private drafts or unreleased scores.
12. Students manually post Activities.
13. Publishing a Builder answer does not auto-post.
14. Any project member can edit Builder drafts.
15. Any project member can publish a Builder answer.
16. One answer per project per Builder.
17. Builder answers support text and images only.
18. Faculty scoring is both per Builder answer and per overall project.
19. Scores require release before students see them.
20. Demo invite links should be generated by role/position.

## 9. App Generated During Chat

The user asked for the final complete Android app in Flutter.

An app zip was generated:

```text
rebelbase_flutter_demo.zip
```

Then the user reported issues:

- `features/activities` folder was empty.
- A code line came up red in `app_repository.dart` around `ChangeNotifierProvider<AppRepository>`.
- User ran `flutter pub get`.

A fixed zip was then generated:

```text
rebelbase_flutter_demo_fixed.zip
```

Known fixes included:

- Importing `ChangeNotifierProvider` from `package:flutter_riverpod/legacy.dart` because the project used Riverpod 3.
- Adding actual `features/activities` files.
- Adding route `/activities`.
- Updating Hub Activities to use reusable `ActivityFeedView`.
- Fixing post card hub labels to use the actual post's hub.
- Adding project persistence using `Project.toJson()` and `Project.fromJson()`.

## 10. Current Desired Output of This Step

The user asked:

> Provide the complete context of this chat in an md file for my codex. Suggest other .md files I may need for the codex to work best, and fill em up.

This context pack was generated for Codex/coding-agent use.
