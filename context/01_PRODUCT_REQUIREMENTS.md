# Product Requirements - RebelBase Flutter Android Demo

## Product One-Liner

A Flutter Android demo app that combines an Instagram-style institutional activity feed with student project workspaces, guided Builder coursework, project pages, faculty scoring, and admin-controlled invite-based access.

## Product Type

Demo-grade B2B2C education/innovation platform.

Not an enterprise SaaS build, but should be coherent, usable, and organized.

## Target Users

### Admin

Platform-level or demo owner user.

Can:

- Create institutions.
- Assign institution managers.
- Assign one manager to multiple institutions.
- Generate role-based invite links.
- Add already signed-up users.
- Manage global Builder templates.
- View all institutions, hubs, projects, answers, and scores.
- Release scores.

### Institution Manager

Institution-level manager. Can manage one or more assigned institutions.

Can:

- Create hubs under assigned institutions.
- Invite faculty.
- Invite students.
- Add signed-up students to hubs/institutions.
- Manage faculty access scope.
- Assign Builder Paths to hubs.
- View all projects and progress in assigned institutions/hubs.
- Release scores.

### Faculty

Reviewer/instructor role with variable scope controlled by the institution manager.

Can:

- View assigned institutions/hubs/students/projects depending on scope.
- See relevant student Builder answers and project contents.
- Score Builder answers.
- Score whole projects.
- Leave feedback.
- Submit scores.
- Potentially release scores if given permission.

### Student

Main app participant.

Can:

- Sign up.
- Join institutions and hubs via invite or manual assignment.
- View Home feed.
- View Hub feed, groups, events, and members.
- Create posts, ideas, questions, resources.
- Comment and kudos.
- Create or join projects.
- Edit shared project Builder drafts.
- Publish Builder answers.
- View other students' Project Pages.
- View released scores only.

Cannot:

- See other projects' unpublished Builder drafts.
- See unreleased scores.
- Invite institution users.
- Manage institutions/hubs.
- Score other students.

## Core Information Architecture

```text
Institution
  -> Managers
  -> Hubs
    -> Faculty
    -> Students
    -> Activity Posts
    -> Groups
    -> Events
    -> Projects
    -> Assigned Builder Paths

Project
  -> Project Members
  -> Project Page
  -> Builder Answers
  -> Answer Scores
  -> Project Scores

Builder Path
  -> Tracks
    -> Builders
      -> Topics
        -> Lessons
      -> Shared Project Answer
```

## Primary Mobile Navigation

Bottom navigation:

```text
Home | Hub | Builders | Projects | Profile
```

Sub-menu chips appear above bottom nav when tapping the upward arrow on eligible tabs.

Examples:

```text
Hub: Activities | Groups | Events | Members
Builders: Tracks | In Progress | Published | Scores
Projects: My Projects | Joined | Explore | Drafts
Profile: Profile | Settings | Invites | Admin Mode
```

## MVP Feature Set

### Authentication and Onboarding

- Login.
- Sign up.
- Invite link redemption.
- Invite code redemption.
- Waiting-for-access state for unassigned users.
- Demo role switching may be allowed for demo users only.

### Institutions and Hubs

- Multi-institution membership.
- Multi-hub membership.
- Admin creates institution.
- Admin assigns manager to one or multiple institutions.
- Manager creates hubs.
- Manager invites or manually adds faculty/students.
- Faculty scope can vary by institution/hub.

### Activities

- Home aggregate feed.
- Hub-specific feed.
- Post types:
  - Post
  - Idea
  - Question
  - Resource
  - Announcement
- Manual posting only.
- Comments.
- Kudos.
- Image attachments.
- Filters.
- Notifications for comments, kudos, invites, score release, and announcements.

### Projects

- Students and staff can create projects.
- Projects belong to an institution and hub.
- Projects have multiple members.
- Roles:
  - Project Owner
  - Project Member
  - Faculty Mentor
- Any project member can publish Builder answers.
- Project Page shows only public/published information to other students.

### Builders

- Builder Paths assigned to hubs.
- Builder cards show progress dots.
- Builder detail screen shows topics.
- Lesson reader.
- Answer editor supporting text and images only.
- Offline progress and drafts.
- One shared answer per project per Builder.
- All project members can edit the shared draft.
- Any project member can publish.
- Published answers appear on Project Page.

### Scoring

- Faculty scoring per Builder answer.
- Faculty scoring per whole project.
- Scores have draft/submitted/released states.
- Students see only released scores.
- Manager/admin/faculty with permission can release scores.

### Admin Panel

Admin panel lives inside the Flutter Android app.

Sections:

- Institutions.
- Hubs.
- Users.
- Invites.
- Builders.
- Learning paths.
- Projects.
- Answers.
- Scores.
- Basic analytics.

## Acceptance Criteria

### Student Journey

A student should be able to:

1. Sign up or use an invite link.
2. Join a hub.
3. See Home and Hub feeds.
4. Create an Activity post.
5. Create a project.
6. Add/join team members.
7. Open Builders for their project.
8. Read lessons.
9. Save progress offline.
10. Draft a Builder answer with text/images.
11. Publish the answer.
12. See it on Project Page.
13. See released faculty scores.

### Faculty Journey

A faculty user should be able to:

1. Login through invite.
2. See assigned institutions/hubs.
3. View student projects.
4. Open Builder answers.
5. Score Builder answers.
6. Score whole projects.
7. Save feedback.
8. Submit or release scores based on permission.

### Manager Journey

An institution manager should be able to:

1. Login through manager invite.
2. Manage assigned institutions.
3. Create a hub.
4. Generate student/faculty invites.
5. Add existing users to hubs.
6. Assign Builder Paths.
7. View progress and scores.
8. Release scores.

### Admin Journey

An admin should be able to:

1. Create institutions.
2. Assign managers to multiple institutions.
3. Generate all demo invite links.
4. Manage Builder content.
5. See and manage all demo data.

## Non-Goals for First Demo

Do not build unless explicitly requested:

- Enterprise billing.
- True multi-plan SaaS subscriptions.
- Production-grade event competition management.
- Investor marketplace.
- Full public SEO project showcase.
- Full offline social posting.
- Nested comments.
- Real-time collaborative editing.
- Video/audio/file Builder answer uploads.
- Complex rubrics beyond score + feedback.
