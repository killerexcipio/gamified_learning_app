# Offline Sync and Local Cache Plan

## Goal

Support offline usability for Builder content, progress, and drafts without overbuilding a full enterprise offline-first system.

## Chosen Demo Approach

Use Hive-style local caching because it is easy, quick, and sufficient for the demo.

Drift/SQLite would be stronger for a production app, but Hive is acceptable for this demo.

## Offline Scope

### Supported Offline

```text
View cached Builder Paths, Tracks, Builders, Topics, and Lessons
Read previously cached lessons
Mark lesson progress locally
Write and edit Builder answer drafts
Attach local image references for Builder answers
Create pending sync queue entries
Show pending sync state
View cached projects and Project Pages
```

### Not Supported in First Demo

```text
Full offline Activity posting
Offline comments
Offline kudos
Offline admin actions
Complex image upload retries
Multi-user merge UI beyond warning/last-write behavior
```

## Hive Boxes

Recommended boxes:

```text
session
profiles
institutions
hubs
projects
project_members
builder_content
builder_progress
builder_answers
builder_answer_images
activity_posts
activity_comments
notifications
sync_queue
```

## Local Entity Strategy

Use remote UUIDs when available.

For local-only records, generate temporary IDs:

```text
local_<uuid>
```

When synced, replace or map local ID to remote ID.

## Sync Queue Model

Each pending action should be represented as a queue item.

```json
{
  "id": "local_queue_id",
  "entityType": "builder_progress",
  "entityId": "...",
  "operation": "upsert",
  "payload": {},
  "status": "pending",
  "attemptCount": 0,
  "lastError": null,
  "createdAt": "...",
  "updatedAt": "..."
}
```

Supported operations:

```text
upsert_builder_progress
upsert_builder_answer
publish_builder_answer
upload_builder_answer_image
```

## Builder Progress Offline Flow

```text
User opens cached Builder
-> reads lesson
-> taps Got it/Next
-> app updates local builder_progress
-> app adds sync_queue item
-> UI shows Pending sync if offline
-> when online, sync service pushes update
-> queue item marked synced
```

## Builder Draft Offline Flow

```text
User opens Answer Editor
-> edits shared answer
-> local answer saved immediately
-> sync_queue item created/updated
-> UI shows Draft saved locally
-> sync runs when online
```

## Publish Offline Flow

Publishing while offline is risky because published content becomes visible to others.

Recommended demo behavior:

```text
If offline:
  Allow Save Draft only.
  Disable Publish button.
  Show: "Connect to the internet to publish this answer."
```

Alternative later:

```text
Queue publish action and mark as pending publication.
```

For demo reliability, use the first approach.

## Conflict Handling

Since all project members can edit the same Builder answer, conflicts can occur.

Each `builder_answers` row should have:

```text
version_number
updated_at
updated_by
```

Client should store the version it last edited.

When syncing:

```text
If local base version == remote version:
  update remote
else:
  conflict detected
```

Demo conflict strategy:

```text
Show warning:
"Another project member updated this answer. Review before syncing."

Options:
- Use latest remote
- Keep my local version
```

Do not build complex manual merge unless requested.

## Image Attachments Offline

For demo:

- Store local image path while offline.
- Show image preview locally.
- Upload to Supabase Storage only when online.
- After upload, replace local path with storage URL.

If upload fails:

- Keep local image.
- Show pending upload badge.
- Allow retry.

## Online/Offline Detection

Use connectivity checks if package is available, but do not trust connectivity alone. A network request can still fail.

Recommended behavior:

```text
Try sync.
If fails, keep queue item pending and show subtle error.
```

## UI Indicators

Use small status labels:

```text
Saved locally
Pending sync
Synced
Sync failed
Conflict detected
```

## Sync Service Lifecycle

Run sync:

- On app start.
- When app resumes.
- After successful login.
- After a local Builder progress/draft update.
- When user manually taps `Sync now`.

## Data Retention

For demo:

- Keep cached Builder content indefinitely.
- Keep local drafts indefinitely until synced or deleted.
- Keep sync queue until operation succeeds or user discards.

## Testing Offline

Required scenarios:

1. Open Builder online, cache content, go offline, read lessons.
2. Save Builder progress offline, restart app, progress remains.
3. Save draft offline, restart app, draft remains.
4. Go online, sync progress.
5. Simulate conflict by editing same answer from two users/devices.
6. Verify publish is disabled offline.
