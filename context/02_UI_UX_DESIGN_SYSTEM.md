# UI/UX Design System - Android RebelBase Demo

## Design Direction

The Android app should feel like a mobile adaptation of the RebelBase web app:

- Dark teal/nav shell.
- Light content canvas.
- Teal/cyan active accents.
- Card-based layout.
- Social feed similar to Instagram/LinkedIn.
- Builder progress dots.
- Project Page sections.
- Admin/faculty review screens.

## Color Tokens

```text
primaryDark:        #1D3030
navDark:            #172928
primaryTeal:        #00A7B5
accentCyan:         #00BCD4
backgroundLight:    #F4F6F8
surfaceWhite:       #FFFFFF
surfaceMuted:       #EEF2F4
textPrimary:        #1E2A2A
textSecondary:      #6B7777
textOnDark:         #FFFFFF
success:            #20A36B
warning:            #F5A524
danger:             #E55353
borderLight:        #D9E0E3
inactiveGrey:       #AAB4B7
```

## Typography

Use Flutter Material typography, customized if desired.

Recommended scale:

```text
App title:       22-24sp, weight 700
Screen title:    20-22sp, weight 700
Section title:   16-18sp, weight 700
Card title:      15-17sp, weight 600
Body:            14-16sp, weight 400
Caption/meta:    11-13sp, weight 400/500
Button:          14sp, weight 600
```

## App Shell

### Top App Bar

Student mode:

```text
Left: current section or RebelBase wordmark
Center/left: optional search field or title
Right: search icon, notifications, avatar
```

Admin mode:

```text
Left: Admin / Manager / Faculty context
Right: filters, search, profile
```

### Bottom Navigation

Primary nav:

```text
Home | Hub | Builders | Projects | Profile
```

Each item includes:

- Icon.
- Label.
- Active teal color.
- Inactive grey/white on dark nav.
- Optional upward arrow for tabs with sub-menus.

### Expandable Sub-Menu

A horizontal chip bar appears above bottom nav when the arrow is tapped.

Behavior:

- Slides up with fade.
- Horizontal scroll if needed.
- Active chip is teal-filled or teal-outlined.
- Dismisses when user taps another nav item or the arrow again.

Examples:

```text
Hub: Activities | Groups | Events | Members
Builders: Tracks | In Progress | Published | Scores
Projects: My Projects | Joined | Explore | Drafts
Profile: Profile | Settings | Invites | Admin Mode
```

## Screens

### 1. Home Screen

Purpose: aggregate feed across user's hubs and relevant announcements.

Components:

- Welcome header.
- Composer card:
  - Avatar.
  - `Share something...` placeholder.
  - Quick chips: Post, Idea, Question, Resource.
- Filter chips:
  - All
  - Announcements
  - Posts
  - Ideas
  - Questions
  - Resources
- Activity feed cards.
- Pull-to-refresh.

### 2. Activity Post Card

Fields:

- Author avatar.
- Author display name.
- Hub name.
- Timestamp.
- Post type badge.
- Body text.
- Optional image.
- Kudos count.
- Comment count.
- Action row.

Post type styling:

```text
post: normal teal/grey badge
idea: amber bulb badge
question: cyan question badge
resource: purple/blue attachment badge
announcement: dark teal/primary badge
```

### 3. Create Post Sheet

Use bottom sheet or full-screen composer.

Fields:

- Post type selector.
- Hub selector.
- Optional project selector.
- Multiline text input.
- Image picker.
- Visibility selector.
- Submit button.

Demo visibility options:

```text
Hub
Project Team
Institution
```

### 4. Hub Screen

Default sub-view: Activities.

Sub-views:

```text
Activities
Groups
Events
Members
```

Hub header:

- Hub logo.
- Hub name.
- Institution name.
- Member count.
- Optional switcher for users in multiple hubs.

Members view:

- Search by name or power.
- Member cards with avatar, role, skills/powers.

Groups view:

- Group cards with name, active status, projects count, member count, manager count.

Events view:

- Event cards with title, date, role, status.

### 5. Builders Screen

Purpose: show Builder Paths/Tracks available to the selected project.

Top:

- Project selector dropdown.
- Overall Builder completion card.
- Track completion progress.

Builder card:

- Icon/image.
- Title.
- Subtitle prompt.
- Progress count.
- Progress dots.
- Publish state.
- Feather/action icon.

Progress dots:

```text
empty: grey outlined circle
complete: teal filled circle
current: teal outline with light fill
```

### 6. Builder Detail Screen

Header:

- Back to all Builders.
- Builder image.
- Builder title.
- Description.
- Progress label.

Content:

- Intro section.
- Topic cards.
- Each topic has title, description, progress dots/count.

Footer:

- Review + Publish card/button.
- Disabled until required answer/progress exists.

### 7. Lesson Reader

Mobile replacement for web right-hand table of contents.

Layout:

- Top app bar with title and progress.
- Reading content card/white surface.
- Floating `Table of contents` button opens bottom sheet.
- `Skip to answer` action.
- `Got it, next` button.

### 8. Answer Editor

Fields:

- Builder prompt.
- Shared project answer text area.
- Image attachments.
- Save draft.
- Preview.
- Publish.

State labels:

```text
draft
published
updated after publish
pending sync
```

### 9. Projects Screen

Sub-views:

```text
My Projects
Joined
Explore
Drafts
```

Project card:

- Logo.
- Project name.
- Tagline.
- Hub/institution.
- Team avatars.
- Builder progress.
- Last updated.

### 10. Project Detail / Project Page

Tabs:

```text
Overview
Team
Published Answers
Scores
Activity
```

Project Page visible to other students should include:

- Project header.
- Team.
- Published Builder answers only.
- Released scores only where permitted.

Do not show unpublished drafts to non-members.

### 11. Profile Screen

Sections:

- User profile.
- Institutions.
- Hubs.
- Projects.
- Powers/skills.
- Invites.
- Settings.
- Admin Mode, if user has admin/manager/faculty permissions.

### 12. Admin Panel

Admin panel is accessible from Profile or an Admin Mode chip.

Admin sections:

```text
Institutions
Hubs
Users
Invites
Builders
Projects
Answers
Scores
Analytics
```

Use mobile cards, filters, and bottom sheets rather than dense tables.

### 13. Faculty Review Queue

Filters:

- Institution.
- Hub.
- Project.
- Builder.
- Student.
- Score status.

Answer review card:

- Project name.
- Builder title.
- Published status.
- Last updated.
- Score status.
- CTA: Review.

Review screen:

- Answer text/images.
- Project shortcut.
- Builder answer score.
- Builder feedback.
- Overall project score.
- Project feedback.
- Save draft.
- Submit.
- Release, if permitted.

## Component Library

Recommended reusable widgets:

```text
AppScaffold
BottomNavWithSubmenu
RBCard
RBChip
RBPrimaryButton
RBSecondaryButton
RBAvatar
PostComposerCard
ActivityPostCard
ProjectCard
BuilderCard
ProgressDots
RoleBadge
StatusBadge
EmptyState
SearchField
FilterBar
```

## Motion

Use small, fast animations:

- Sub-menu slide/fade: 180-220ms.
- Card tap scale: subtle.
- Bottom sheets: standard Material motion.
- Progress update: small dot fill animation.

## Accessibility

- Minimum tap target: 48dp.
- Sufficient contrast on teal buttons.
- Semantic labels for icon-only buttons.
- Text scaling should not break cards.
- Do not rely on color alone for status; include labels.
