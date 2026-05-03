# RebelBase Flutter Demo - Codex Context Pack

This folder contains the context and implementation guidance for building, fixing, and extending the RebelBase-style Flutter Android demo app.

## Current Source of Truth

Use these Markdown files as the project source of truth when working with Codex or any coding agent.

The uploaded `app_deets(1).txt` file was explicitly marked by the product owner as **not fully accurate** and must be treated only as loose UI/product inspiration. Do **not** copy any codebase plan, architecture, or code directly from that text. The current source of truth is this context pack plus the current Flutter project.

## Current Backend Decision

The current backend decision is **Supabase**, not Firebase.

Use:

- Supabase Auth
- Supabase PostgreSQL
- Supabase Row Level Security
- Supabase Storage
- Supabase Edge Functions or Postgres functions where useful
- Hive-style local caching for the demo

Firebase appeared in earlier brainstorming material, but it is not the current implementation target.

## Suggested Reading Order for Codex

1. `AGENTS.md` - repository-level instructions for coding agents.
2. `00_CHAT_CONTEXT.md` - full chat context and locked decisions.
3. `01_PRODUCT_REQUIREMENTS.md` - final product requirements and user-role behavior.
4. `02_UI_UX_DESIGN_SYSTEM.md` - mobile UI design system and screen structure.
5. `03_FLUTTER_IMPLEMENTATION_GUIDE.md` - architecture, packages, folder structure, and routing.
6. `04_SUPABASE_SCHEMA_AND_RLS.md` - database schema and access-control plan.
7. `05_OFFLINE_SYNC_AND_LOCAL_CACHE.md` - offline caching and sync rules.
8. `06_INVITES_AND_ACCESS_CONTROL.md` - invite-link, membership, and RBAC flows.
9. `07_ADMIN_FACULTY_SCORING.md` - admin, faculty, scoring, and score-release workflows.
10. `08_BUILDERS_AND_PROJECTS_DOMAIN.md` - Builders, project pages, publishing, and shared answer rules.
11. `09_ACTIVITY_FEED_SPEC.md` - Instagram-like Activities system.
12. `10_IMPLEMENTATION_PLAN.md` - phased build plan.
13. `11_TESTING_QA_PLAN.md` - test and verification plan.
14. `12_KNOWN_ISSUES_AND_FIXES.md` - previous issues and required fixes.
15. `13_DEMO_DATA_SEED_PLAN.md` - demo institutions, users, projects, Builders, and invite data.

## Current Latest App Artifact Mentioned in Chat

The latest corrected app package created during the chat was:

```text
rebelbase_flutter_demo_fixed.zip
```

A previous package had issues, including an empty `features/activities` folder and a Riverpod provider import problem. Those issues are documented in `12_KNOWN_ISSUES_AND_FIXES.md`.

## App Summary

The app is a demo-grade Flutter Android implementation of a RebelBase-like product:

> Instagram-like social feed + institution/hub management + project workspaces + guided coursework called Builders + project pages + faculty scoring + score release + invite links + offline progress caching.

The demo should be fully usable and cleanly organized, but it is not expected to be enterprise-grade.
