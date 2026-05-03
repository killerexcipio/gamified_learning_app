# Demo Data Seed Plan

## Purpose

Seed enough data to demonstrate the full product without requiring enterprise setup.

## Demo Institution

```text
Name: BRACU
Slug: bracu
Description: Demo institution for RebelBase-style project building.
```

Optional second institution for multi-manager demo:

```text
Name: SOL Institute
Slug: sol-institute
```

## Demo Hubs

```text
BRACU Innovation Hub
SOL Happiness Index Cohort
Innovation Builders Cohort
```

## Demo Users

### Admin

```text
Name: Admin User
Role: admin
```

### Institution Manager

```text
Name: Md. Rezaur Rahman
Role: institution_manager
Institutions: BRACU, SOL Institute
```

### Faculty

```text
Name: BRACU Faculty Reviewer
Role: faculty
Scope: BRACU Innovation Hub
Can score answers: yes
Can score projects: yes
Can release scores: optional/no depending demo
```

### Students

Example students:

```text
Rafsan Monsur
Rehnuma Majba
Md. Sameer Sakib
Jonah Mae Santorum
Ahlan Tazbi
Alexa Creavey
Alejandro Crawford
```

## Demo Projects

### SOL Happiness Index

```text
Institution: BRACU
Hub: SOL Happiness Index Cohort
Category: Energy / Organizational Wellbeing
Location: Dhaka, Bangladesh
Team:
  - Md. Rezaur Rahman: Project Owner
  - Rafsan Monsur: Project Member
  - Rehnuma Majba: Project Member
  - Md. Sameer Sakib: Project Member
```

### FacePet

```text
Location: New York, NY, USA
Category: Animal Services
```

### Reaching Presence

```text
Location: Dhaka, Bangladesh
Category: Automotive
```

### The Music Note

```text
Location: New Haven, CT, USA
Category: Education
```

## Demo Builder Path

```text
Title: Innovation Foundations
Description: Guided project-building path for early-stage innovation teams.
```

### Track: Ideation

Builders:

```text
Problem
Solution
Core Team
Designing Your Organization's Role in Tackling Climate Change
```

### Track: Validation

Builders:

```text
Target and Market
Prototesting
Ecosystem
Competitive Landscape
```

## Demo Builder: Target and Market

Description:

```text
Who is your solution for and where would you sell it?
```

Topics:

```text
Intro to Target and Market
Target Market
Market Category
Users vs Customers
Segmentation
```

Answer prompt:

```text
Who are you targeting with your solution? Who are the segments and which would adopt your solution first?
```

## Demo Published Answers

### Why Statement

Use a short realistic project statement about workplace happiness, employee feedback, psychological safety, and organizational innovation.

### Target Market

Use a draft/published answer about:

- HR departments.
- Mid-sized Bangladeshi organizations.
- Employee experience teams.
- Managers looking to reduce burnout.

## Demo Scores

### Released Builder Score

```text
Project: SOL Happiness Index
Builder: Why Statement
Score: 8.5 / 10
Feedback: Strong motivation and problem framing. Add clearer evidence from interviews.
Released: yes
```

### Unreleased Builder Score

```text
Project: SOL Happiness Index
Builder: Target and Market
Score: 7.5 / 10
Feedback: Good segmentation. Needs clearer early adopter selection.
Released: no
```

### Project Score

```text
Project: SOL Happiness Index
Score: 8.0 / 10
Feedback: Strong concept and social impact angle. Needs stronger validation data.
Released: no initially
```

## Demo Activity Posts

Seed post types:

```text
Announcement: Welcome to the BRACU Innovation Hub.
Post: Sharing our team's latest reflection.
Idea: Could we build a happiness index for university staff?
Question: How should we validate workplace wellbeing?
Resource: Useful article about employee engagement.
```

Include at least:

- One post with image.
- One post with comments.
- One post with kudos.

## Demo Invites

Seed these tokens:

```text
mgr-multi-8KQ2-BRACU-SOL
mgr-bracu-4XP9-DEMO
fac-bracu-H7LM-DEMO
fac-solscore-P2VA-DEMO
stu-bracu-A1F9-DEMO
stu-bracu-B2G8-DEMO
stu-sol-C3H7-DEMO
stu-sol-D4J6-DEMO
stu-builders-E5K5-DEMO
stu-builders-F6L4-DEMO
```

## Demo Flow to Validate

```text
Admin logs in
-> shows institutions and invites
Manager logs in
-> sees BRACU and SOL Institute
Student logs in
-> posts Activity
Student opens SOL Happiness Index project
-> completes Target and Market Builder
-> publishes answer
Faculty logs in
-> scores answer and project
Manager releases scores
Student sees released score
```
