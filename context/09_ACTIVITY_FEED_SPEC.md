# Activity Feed Specification

## Importance

The Activities system is central. The product is explicitly described as:

```text
Instagram with added projects and guided coursework called Builders.
```

So posting, browsing, kudos, comments, and community interaction must feel first-class.

## Activity Surfaces

### Home Feed

Aggregated feed from:

- All hubs the user belongs to.
- Institution-wide announcements.
- Project-team posts where relevant.

### Hub Feed

Feed scoped to one hub.

### Project Activity

Optional project-specific updates/comments.

## Post Types

Implement these post types:

```text
post
idea
question
resource
announcement
```

### Post

General status update/reflection.

### Idea

A new concept, suggestion, or possible project direction.

### Question

Help request or discussion prompt.

### Resource

Link, article, image, document reference, or tool recommendation.

For the demo, resource can be text + optional image/link text.

### Announcement

Admin/faculty/manager post type. Should visually stand out and can be pinned later.

## Post Creation UI

Use a bottom sheet or full-screen composer.

Fields:

```text
Post type selector
Hub selector
Optional project selector
Body text
Image attachment
Visibility selector
Submit button
```

Default visibility:

```text
hub
```

Other demo options:

```text
project_team
institution
```

## Composer Card

At top of Home and Hub Activities:

```text
Avatar + "Share something..."
Quick chips: Post | Idea | Question | Resource
```

Tapping card opens composer.

## Post Card UI

Post card should display:

```text
Author avatar
Author name
Hub name
Timestamp
Type badge
Body text
Image preview if attached
Kudos count
Comment count
Comment preview optional
Actions: Kudos, Comment
```

## Feed Filters

Horizontal chips:

```text
All
Announcements
Posts
Ideas
Questions
Resources
```

## Kudos

Rules:

- One kudos per user per post.
- Tapping again removes kudos.
- Show count.
- Notify author if appropriate.

Database:

```text
post_kudos(post_id, user_id)
```

## Comments

Rules:

- Simple flat comments.
- No nested comments in first demo.
- Users can delete their own comments.
- Admin/manager can moderate comments if needed.

Database:

```text
activity_comments
```

## Images

Posts support image attachments.

Demo rule:

- One image per post is enough.

Future:

- Multiple images.
- Link previews.
- File resources.

Storage bucket:

```text
activity-images
```

## Notifications

Create notifications for:

```text
comment_on_your_post
kudos_on_your_post
announcement_in_hub
mention_later_optional
```

Notification example:

```text
Md. Sameer Sakib gave kudos to your Post in the BRACU hub.
```

## Manual Posting Rule

Publishing a Builder answer must not automatically create an Activity post.

Correct flow:

```text
Project member publishes Builder answer
-> answer appears on Project Page
-> user manually creates Activity post if desired
```

## Admin Moderation

Admin/manager/faculty with permission can:

```text
Hide post
Delete post
Pin announcement
Filter flagged content
```

For first demo, hiding/deleting is optional.

## Database Fields

### activity_posts

```text
id
institution_id
hub_id
project_id nullable
author_id
type
body
visibility
created_at
updated_at
```

### activity_post_images

```text
id
post_id
image_url
sort_order
created_at
```

### activity_comments

```text
id
post_id
author_id
body
created_at
updated_at
```

### post_kudos

```text
id
post_id
user_id
created_at
```

## Feed Query Logic

Home feed:

```text
posts where hub_id in user's hubs
OR institution_id in user's institutions and visibility = institution
OR project_team visibility for user's projects
ORDER BY created_at DESC
```

Hub feed:

```text
posts where hub_id = selected_hub_id
AND user is hub member
ORDER BY created_at DESC
```

Project team feed:

```text
posts where project_id = selected_project_id
AND visibility = project_team
AND user is project member
```

## Acceptance Criteria

A student can:

1. Open Home feed.
2. Open Hub Activities.
3. Create a Post.
4. Create an Idea.
5. Create a Question.
6. Create a Resource.
7. Attach an image.
8. Filter feed by type.
9. Add kudos.
10. Comment.
11. See notifications for engagement.

An admin/faculty can:

1. Create an Announcement.
2. See hub-level posts.
3. Optionally moderate posts.
