# Builders and Projects Domain Specification

## Project Model

A Project is the central workspace and showcase entity.

Projects belong to:

```text
Institution
Hub
Team members
Builder answers
Scores
Activity context
```

## Project Roles

```text
Project Owner
Project Member
Faculty Mentor
```

Important rule:

> Any project member can publish Builder answers.

The Project Owner mainly controls team/settings/deletion, not exclusive publishing.

## Project Creation

Allowed creators:

```text
Students
Faculty
Institution managers
Admins
```

Project creation fields:

```text
Project name
Short tagline
Description
Logo/image
Institution
Hub
Category/industry
Location
Visibility
Initial team members
```

## Project Visibility

Recommended demo options:

```text
private
team
hub
institution
```

Student viewing rule:

- Students can view other students' Project Pages if visible/published.
- Students cannot see unpublished Builder drafts.
- Students cannot see unreleased scores.

## Project Page

The Project Page is the public/published version of the project.

Sections:

```text
Overview
About
Team
Published Builder Answers
Scores
Activity/Updates
```

Published Builder answer cards include:

```text
Builder title
Answer text
Answer images
Published by
Published date
Last updated
```

## Builder Domain

Builders are guided coursework modules.

Hierarchy:

```text
Builder Path
  -> Track
    -> Builder
      -> Topics
        -> Lessons
      -> Answer Prompt
```

Example:

```text
Builder Path: Innovation Foundations
Track: Validation
Builder: Target and Market
Topics:
  - Intro to Target Market
  - Target Market
  - Market Category
  - Users vs Customers
  - Segmentation
Answer Prompt:
  Who are you targeting with your solution?
```

## Builder Card

Fields:

```text
Image/icon
Title
Description
Progress count
Progress dots
Publish status
```

Example:

```text
Target and Market
Who is your solution for and where would you sell it?
Progress 0/2
○ ○
```

## Builder Flow

```text
Select Project
-> Open Builders tab
-> View Tracks
-> Tap Builder card
-> View Builder detail/topics
-> Read lessons
-> Mark progress
-> Open answer editor
-> Save shared draft
-> Attach images
-> Publish
-> Answer appears on Project Page
-> Faculty scores
-> Score is released later
```

## Shared Builder Answer Rules

1. One answer per project per Builder.
2. Answer belongs to `project_id + builder_id`.
3. All project members can edit the shared draft.
4. Any project member can publish.
5. Answer supports text and images only.
6. Published answer appears on Project Page.
7. Editing after publish should mark status as `updated_after_publish` or republish as needed.

## Answer States

```text
draft
published
updated_after_publish
archived
```

## Versioning

Use:

```text
version_number
created_by
updated_by
published_by
published_at
updated_at
```

Versioning supports conflict warning when multiple project members edit offline or from different devices.

## Progress Tracking

Progress can be per user, project, and Builder:

```text
project_id
builder_id
user_id
completed_lesson_ids
status
updated_at
```

Status:

```text
not_started
in_progress
completed
```

## Publishing Requirements

Minimum demo requirement:

- At least one answer text or image exists.
- User is project member.
- User is online.

Optional:

- Required lessons/topics completed.
- Review step confirmation.

## No Automatic Activity Post

Publishing does **not** auto-create an Activity post.

User may manually post:

```text
We just published our Target Market section for SOL Happiness Index!
```

## Project Page Publishing Examples

Builder answer published:

```text
Section: Business Case
Subsection: Why Statement
Content: Student's Builder answer
```

Another example:

```text
Section: Validation
Subsection: Target Market
Content: Shared project answer with images
```

## Future Enhancements

Do not prioritize for first demo:

- Multiple answer versions visible to faculty.
- Approval required before Project Page publication.
- Rubric scoring per Builder criterion.
- Rich text editor with complex formatting.
- Real-time multi-user co-editing.
- Video/file attachments.
