# Supabase Schema and RLS Plan

## Backend Target

Use Supabase:

- Auth for login/signup.
- PostgreSQL for data.
- Row Level Security for access control.
- Storage for images.
- Postgres functions or Edge Functions for invite redemption and score release.

## Core Principles

1. Users can belong to multiple institutions.
2. Users can belong to multiple hubs.
3. Institution managers can manage multiple institutions.
4. Project membership is separate from hub membership.
5. Builder answers belong to a project and Builder, not to an individual student.
6. One answer per project per Builder.
7. Any project member can edit/publish the shared answer.
8. Students can only see published Project Page content of other projects.
9. Students cannot see unreleased scores.
10. Faculty/admin/manager permissions must be enforced by RLS, not only UI.

## Tables

### profiles

```sql
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  username text unique,
  avatar_url text,
  bio text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### institutions

```sql
create table institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  logo_url text,
  description text,
  created_by uuid references profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### institution_members

```sql
create table institution_members (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  role text not null check (role in (
    'admin',
    'institution_manager',
    'faculty',
    'student'
  )),
  status text not null default 'active' check (status in ('active', 'pending', 'disabled')),
  created_at timestamptz default now(),
  unique (institution_id, user_id, role)
);
```

### hubs

```sql
create table hubs (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id) on delete cascade,
  name text not null,
  slug text not null,
  description text,
  logo_url text,
  created_by uuid references profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (institution_id, slug)
);
```

### hub_members

```sql
create table hub_members (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid references hubs(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  role text not null check (role in ('manager', 'faculty', 'student')),
  status text not null default 'active' check (status in ('active', 'pending', 'disabled')),
  created_at timestamptz default now(),
  unique (hub_id, user_id)
);
```

### faculty_scopes

Optional table for variable faculty visibility.

```sql
create table faculty_scopes (
  id uuid primary key default gen_random_uuid(),
  faculty_user_id uuid references profiles(id) on delete cascade,
  institution_id uuid references institutions(id) on delete cascade,
  hub_id uuid references hubs(id) on delete cascade,
  can_view_projects boolean default true,
  can_view_answers boolean default true,
  can_score_answers boolean default true,
  can_score_projects boolean default true,
  can_release_scores boolean default false,
  assigned_by uuid references profiles(id),
  created_at timestamptz default now(),
  unique (faculty_user_id, institution_id, hub_id)
);
```

### projects

```sql
create table projects (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id),
  hub_id uuid references hubs(id),
  name text not null,
  tagline text,
  description text,
  logo_url text,
  category text,
  location text,
  visibility text not null default 'hub' check (visibility in (
    'private',
    'team',
    'hub',
    'institution'
  )),
  created_by uuid references profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### project_members

```sql
create table project_members (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  role text not null check (role in ('owner', 'member', 'faculty_mentor')),
  created_at timestamptz default now(),
  unique (project_id, user_id)
);
```

## Builder Tables

### builder_paths

```sql
create table builder_paths (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id),
  title text not null,
  description text,
  is_published boolean default false,
  created_by uuid references profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### builder_tracks

```sql
create table builder_tracks (
  id uuid primary key default gen_random_uuid(),
  path_id uuid references builder_paths(id) on delete cascade,
  title text not null,
  description text,
  sort_order int default 0
);
```

### builders

```sql
create table builders (
  id uuid primary key default gen_random_uuid(),
  track_id uuid references builder_tracks(id) on delete cascade,
  title text not null,
  description text,
  image_url text,
  answer_prompt text not null,
  sort_order int default 0,
  is_published boolean default false
);
```

### builder_topics

```sql
create table builder_topics (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid references builders(id) on delete cascade,
  title text not null,
  description text,
  sort_order int default 0
);
```

### builder_lessons

```sql
create table builder_lessons (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid references builder_topics(id) on delete cascade,
  title text not null,
  body text not null,
  sort_order int default 0
);
```

### builder_assignments

Assign Builder Paths to hubs.

```sql
create table builder_assignments (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid references hubs(id) on delete cascade,
  path_id uuid references builder_paths(id) on delete cascade,
  assigned_by uuid references profiles(id),
  created_at timestamptz default now(),
  unique (hub_id, path_id)
);
```

## Progress and Answers

### builder_progress

```sql
create table builder_progress (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  builder_id uuid references builders(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  completed_lesson_ids uuid[] default '{}',
  status text not null default 'not_started' check (status in (
    'not_started',
    'in_progress',
    'completed'
  )),
  updated_at timestamptz default now(),
  unique (project_id, builder_id, user_id)
);
```

### builder_answers

```sql
create table builder_answers (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  builder_id uuid references builders(id) on delete cascade,
  answer_text text,
  status text not null default 'draft' check (status in (
    'draft',
    'published',
    'updated_after_publish',
    'archived'
  )),
  version_number int default 1,
  created_by uuid references profiles(id),
  updated_by uuid references profiles(id),
  published_by uuid references profiles(id),
  published_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (project_id, builder_id)
);
```

### builder_answer_images

```sql
create table builder_answer_images (
  id uuid primary key default gen_random_uuid(),
  answer_id uuid references builder_answers(id) on delete cascade,
  image_url text not null,
  sort_order int default 0,
  uploaded_by uuid references profiles(id),
  created_at timestamptz default now()
);
```

## Scoring Tables

### answer_scores

```sql
create table answer_scores (
  id uuid primary key default gen_random_uuid(),
  answer_id uuid references builder_answers(id) on delete cascade,
  project_id uuid references projects(id) on delete cascade,
  builder_id uuid references builders(id) on delete cascade,
  scored_by uuid references profiles(id),
  score numeric(4,2),
  feedback text,
  status text not null default 'draft' check (status in (
    'draft',
    'submitted',
    'released',
    'needs_revision'
  )),
  is_released boolean default false,
  released_by uuid references profiles(id),
  released_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### project_scores

```sql
create table project_scores (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  scored_by uuid references profiles(id),
  score numeric(4,2),
  feedback text,
  status text not null default 'draft' check (status in (
    'draft',
    'submitted',
    'released',
    'needs_revision'
  )),
  is_released boolean default false,
  released_by uuid references profiles(id),
  released_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

## Activity Tables

### activity_posts

```sql
create table activity_posts (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id),
  hub_id uuid references hubs(id),
  project_id uuid references projects(id),
  author_id uuid references profiles(id),
  type text not null check (type in (
    'post',
    'idea',
    'question',
    'resource',
    'announcement'
  )),
  body text not null,
  visibility text not null default 'hub' check (visibility in (
    'project_team',
    'hub',
    'institution'
  )),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### activity_post_images

```sql
create table activity_post_images (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references activity_posts(id) on delete cascade,
  image_url text not null,
  sort_order int default 0,
  created_at timestamptz default now()
);
```

### activity_comments

```sql
create table activity_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references activity_posts(id) on delete cascade,
  author_id uuid references profiles(id),
  body text not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

### post_kudos

```sql
create table post_kudos (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references activity_posts(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  created_at timestamptz default now(),
  unique (post_id, user_id)
);
```

## Invites

### invites

```sql
create table invites (
  id uuid primary key default gen_random_uuid(),
  token text unique not null,
  role text not null check (role in (
    'institution_manager',
    'faculty',
    'student'
  )),
  institution_id uuid references institutions(id),
  hub_id uuid references hubs(id),
  scope_type text not null check (scope_type in (
    'institution',
    'hub',
    'multiple_institutions'
  )),
  max_uses int not null default 1,
  used_count int not null default 0,
  expires_at timestamptz,
  is_active boolean default true,
  created_by uuid references profiles(id),
  created_at timestamptz default now()
);
```

### invite_institution_scopes

```sql
create table invite_institution_scopes (
  id uuid primary key default gen_random_uuid(),
  invite_id uuid references invites(id) on delete cascade,
  institution_id uuid references institutions(id) on delete cascade,
  unique (invite_id, institution_id)
);
```

### invite_redemptions

```sql
create table invite_redemptions (
  id uuid primary key default gen_random_uuid(),
  invite_id uuid references invites(id) on delete cascade,
  redeemed_by uuid references profiles(id),
  redeemed_at timestamptz default now(),
  unique (invite_id, redeemed_by)
);
```

## Notifications

```sql
create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade,
  type text not null,
  title text not null,
  body text,
  entity_type text,
  entity_id uuid,
  is_read boolean default false,
  created_at timestamptz default now()
);
```

## Storage Buckets

```text
avatars
institution-logos
hub-logos
project-logos
activity-images
builder-answer-images
builder-content-images
```

## Helper Functions Needed

Implement Postgres functions or Edge Functions:

```text
redeem_invite(token text)
release_answer_score(score_id uuid)
release_project_score(score_id uuid)
user_can_manage_institution(user_id uuid, institution_id uuid)
user_can_manage_hub(user_id uuid, hub_id uuid)
user_can_score_project(user_id uuid, project_id uuid)
user_is_project_member(user_id uuid, project_id uuid)
```

## RLS Policy Concepts

### profiles

- Users can read profiles visible through shared institutions/hubs/projects.
- Users can update their own profile.

### institutions

- Members can read their institutions.
- Admins can read/manage all.
- Institution managers can update assigned institutions.

### hubs

- Hub members can read hubs.
- Managers can manage hubs under assigned institutions.

### projects

Read:

- Project members can read full project.
- Hub members can read projects with `hub` visibility.
- Institution members can read projects with `institution` visibility.

Write:

- Project members can update project content depending on role.
- Creator can manage project initially.

### builder_answers

Read:

- Project members can read drafts and published answers.
- Students outside project can read only published answers through Project Page.
- Faculty/managers can read answers for their scoped hubs/institutions.

Write:

- Project members can insert/update/publish one answer per project per Builder.

### scores

Read:

- Students can read only released scores for their project.
- Faculty/manager/admin can read scores in their scope.

Write:

- Faculty/manager/admin with score permission can score.
- Release requires release permission.

### activity_posts

Read:

- Hub members can read hub posts.
- Project team can read project-team posts.
- Institution members can read institution posts.

Write:

- Members can create posts in hubs they belong to.
- Announcements require faculty/manager/admin role.

## Important Security Notes

- UI hiding is not enough. Enforce with RLS.
- Never let client directly set `released_by` unless checked by function/RLS.
- Invite redemption should be transactional.
- Scores should default to hidden.
- Students must not be able to query unreleased scores by guessing IDs.
