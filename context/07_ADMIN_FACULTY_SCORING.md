# Admin, Faculty, and Scoring Workflows

## Final Scoring Decisions

The user locked these decisions:

1. Faculty scoring is both per Builder answer and per project.
2. Scores are not visible immediately.
3. Scores must be released before students can see them.
4. All project members can edit the shared Builder draft.
5. One answer per project per Builder.
6. Any project member can publish.

## Score Types

### Builder Answer Score

A score attached to one published Builder answer.

Example:

```text
Project: SOL Happiness Index
Builder: Target and Market
Score: 8.5 / 10
Feedback: Clear segmentation, but add more interview evidence.
```

### Project Score

Overall score for the whole project.

Example:

```text
Project: SOL Happiness Index
Score: 8.0 / 10
Feedback: Strong problem framing, needs stronger validation.
```

## Score Lifecycle

```text
draft
-> submitted
-> released
```

Optional state:

```text
needs_revision
```

## Faculty Review Flow

```text
Faculty logs in
-> opens Review Queue
-> filters by institution/hub/project/builder/status
-> opens Builder answer
-> reviews text/images
-> enters score out of 10
-> writes feedback
-> saves draft or submits
```

## Score Release Flow

```text
Faculty/manager/admin opens Scores
-> filters unreleased scores
-> reviews submitted scores
-> taps Release
-> released_by and released_at are set
-> student receives notification
-> score becomes visible in student's Project Score tab
```

## Student Score Flow

Before release:

```text
Score pending
Your faculty feedback has not been released yet.
```

After release:

```text
Target Market
8.5 / 10
Feedback: Your segmentation is clear. Add more evidence from interviews.
Released on: Apr 20, 2026
```

## Faculty Review Queue UI

Filters:

```text
Institution
Hub
Project
Student
Builder
Status: Published, Unscored, Scored, Unreleased, Released
```

Card fields:

```text
Project name
Builder title
Published by
Last updated
Answer status
Score status
CTA: Review
```

## Review Screen UI

Sections:

```text
Project header
Builder title
Published answer text
Attached images
Project Page shortcut

Builder Answer Score
- Score input: 0-10
- Feedback input
- Save Draft
- Submit Score

Project Score
- Score input: 0-10
- Feedback input
- Save Draft
- Submit Score

Release Controls
- Release Answer Score
- Release Project Score
```

Release buttons only appear if user has release permission.

## Manager/Admin Score Dashboard

Views:

```text
Unreleased Scores
Released Scores
Needs Revision
By Project
By Builder
By Faculty
By Hub
```

Metrics:

```text
Total published answers
Unscored answers
Submitted but unreleased scores
Released scores
Average project score
Average Builder answer score
```

## Database Mapping

Use:

```text
answer_scores
project_scores
```

Both tables include:

```text
score
feedback
status
is_released
released_by
released_at
scored_by
created_at
updated_at
```

## RLS Requirements

Students:

- Can read released scores for their own projects.
- Cannot read unreleased scores.
- Cannot insert/update score rows.

Faculty:

- Can read answers and scores in scoped institutions/hubs.
- Can create/update their own score drafts/submissions.
- Can release only if `can_release_scores = true` or equivalent role permission.

Institution managers:

- Can read and release scores in assigned institutions.

Admins:

- Can read and release all scores.

## Demo Simplification

Use score out of 10 plus written feedback.

Do not build complex rubrics in first demo.

Future rubric fields:

```text
Clarity
Originality
Evidence
Feasibility
Impact
Presentation
```

## Notifications

Create notification when:

```text
Score released
Feedback released
Answer marked needs revision
Project score released
```

Notification examples:

```text
Your Target Market score has been released.
Your SOL Happiness Index project score has been released.
Faculty requested revision on your Problem answer.
```
