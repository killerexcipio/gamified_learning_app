# Invites and Access Control

## Invite Requirements

The app must support:

1. Invite links.
2. Invite codes.
3. Manual assignment of existing signed-up users.
4. Email-friendly generated links, even if email sending is not implemented in the demo.
5. Role/position-specific invite links.
6. Multi-institution manager invites.

## Demo Invite Links

Base format:

```text
https://app.rebelbase.co/invite/{token}
```

Generated demo links:

| # | Position | Scope | Max Uses | Demo Link |
|---:|---|---|---:|---|
| 1 | Institution Manager | Multi-institution manager | 1 | `https://app.rebelbase.co/invite/mgr-multi-8KQ2-BRACU-SOL` |
| 2 | Institution Manager | BRACU only | 1 | `https://app.rebelbase.co/invite/mgr-bracu-4XP9-DEMO` |
| 3 | Faculty | BRACU hub faculty | 1 | `https://app.rebelbase.co/invite/fac-bracu-H7LM-DEMO` |
| 4 | Faculty | SOL Happiness Index faculty reviewer | 1 | `https://app.rebelbase.co/invite/fac-solscore-P2VA-DEMO` |
| 5 | Student | BRACU hub student | 1 | `https://app.rebelbase.co/invite/stu-bracu-A1F9-DEMO` |
| 6 | Student | BRACU hub student | 1 | `https://app.rebelbase.co/invite/stu-bracu-B2G8-DEMO` |
| 7 | Student | SOL Happiness Index cohort | 1 | `https://app.rebelbase.co/invite/stu-sol-C3H7-DEMO` |
| 8 | Student | SOL Happiness Index cohort | 1 | `https://app.rebelbase.co/invite/stu-sol-D4J6-DEMO` |
| 9 | Student | Innovation Builders cohort | 1 | `https://app.rebelbase.co/invite/stu-builders-E5K5-DEMO` |
| 10 | Student | Innovation Builders cohort | 1 | `https://app.rebelbase.co/invite/stu-builders-F6L4-DEMO` |

## Invite Redemption Flow

```text
User opens invite link
-> Flutter route /invite/:token
-> if logged out, route to login/signup
-> after auth, token is redeemed
-> app validates token
-> app adds memberships based on token
-> app increments used_count
-> app creates invite_redemption record
-> app navigates user to correct screen
```

After redemption:

```text
student -> Home or assigned Hub
faculty -> Faculty review/dashboard
institution_manager -> Manager/Admin panel
```

## Invite Code Flow

```text
User signs up normally
-> sees Join Institution/Hub screen
-> enters invite code
-> app redeems token
-> user receives role/membership
```

## Waiting Access Flow

```text
User signs up with no invite
-> profile exists
-> no institution_members/hub_members row
-> app shows Waiting for access screen
-> manager/admin searches user
-> manager/admin adds user to institution/hub
-> user can enter app
```

## Manual Add Flow

Admin/manager can:

```text
Search signed-up users
Filter by email/name
Select institution/hub
Select role
Add user
```

This creates appropriate membership rows.

## Role Assignments

### Student invite

Creates:

```text
institution_members.role = student
hub_members.role = student, if hub scoped
```

### Faculty invite

Creates:

```text
institution_members.role = faculty
hub_members.role = faculty, if hub scoped
faculty_scopes row, if using scoped permissions
```

### Institution manager invite

Creates:

```text
institution_members.role = institution_manager
```

For multi-institution invites, it creates one row per scoped institution.

## Access Matrix

| Action | Admin | Institution Manager | Faculty | Student |
|---|---:|---:|---:|---:|
| Create institution | Yes | No | No | No |
| Assign managers | Yes | No | No | No |
| Manage assigned institution | Yes | Yes | No | No |
| Create hub | Yes | Yes | Maybe if delegated | No |
| Invite faculty | Yes | Yes | No | No |
| Invite students | Yes | Yes | Maybe if delegated | No |
| Add signed-up students | Yes | Yes | Maybe if delegated | No |
| Create project | Yes | Yes | Yes | Yes |
| Join/edit project | If member | If member | If member/mentor | If member |
| Publish Builder answer | If project member | If project member | If project member/mentor | If project member |
| View other Project Pages | Yes | Yes | Yes | Published only |
| View Builder drafts | Yes | Scoped | Scoped | Own projects only |
| Score Builder answer | Yes | Yes | Yes | No |
| Score project | Yes | Yes | Yes | No |
| Release scores | Yes | Yes | If permitted | No |
| View unreleased scores | Yes | Yes | Scoped | No |

## Important Implementation Notes

- Invite redemption should be server-side or transactional.
- Do not let clients self-assign roles by direct insert unless RLS/function validates invite token.
- Invite token should be random enough for real use; demo tokens are human-readable for demonstration only.
- Max uses and expiry must be enforced.
- Deactivated invites must not redeem.
- Already redeemed single-use invites should show a clear error.
