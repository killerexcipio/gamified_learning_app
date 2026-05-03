-- RebelBase Flutter Demo - Supabase schema
-- Run in Supabase SQL Editor after creating a project.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  username text unique,
  avatar_url text,
  bio text,
  powers text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  logo_url text,
  description text,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.institution_members (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  role text not null check (role in ('admin','institution_manager','faculty','student')),
  status text not null default 'active',
  created_at timestamptz default now(),
  unique (institution_id, user_id, role)
);

create table if not exists public.hubs (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id) on delete cascade,
  name text not null,
  slug text not null,
  description text,
  logo_url text,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (institution_id, slug)
);

create table if not exists public.hub_members (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid references public.hubs(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  role text not null check (role in ('manager','faculty','student')),
  status text not null default 'active',
  created_at timestamptz default now(),
  unique (hub_id, user_id)
);

create table if not exists public.invites (
  id uuid primary key default gen_random_uuid(),
  token text unique not null,
  role text not null check (role in ('institution_manager','faculty','student')),
  institution_id uuid references public.institutions(id),
  hub_id uuid references public.hubs(id),
  scope_type text not null default 'hub' check (scope_type in ('institution','hub','multiple_institutions')),
  max_uses int not null default 1,
  used_count int not null default 0,
  expires_at timestamptz,
  is_active boolean not null default true,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

create table if not exists public.invite_institution_scopes (
  id uuid primary key default gen_random_uuid(),
  invite_id uuid references public.invites(id) on delete cascade,
  institution_id uuid references public.institutions(id) on delete cascade,
  unique (invite_id, institution_id)
);

create table if not exists public.invite_redemptions (
  id uuid primary key default gen_random_uuid(),
  invite_id uuid references public.invites(id) on delete cascade,
  redeemed_by uuid references public.profiles(id),
  redeemed_at timestamptz default now(),
  unique (invite_id, redeemed_by)
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id),
  hub_id uuid references public.hubs(id),
  name text not null,
  tagline text,
  description text,
  logo_url text,
  category text,
  location text,
  visibility text not null default 'hub' check (visibility in ('private','team','hub','institution')),
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.project_members (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  role text not null check (role in ('owner','member','faculty_mentor')),
  created_at timestamptz default now(),
  unique (project_id, user_id)
);

create table if not exists public.builder_paths (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id),
  title text not null,
  description text,
  is_published boolean default false,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.builder_tracks (
  id uuid primary key default gen_random_uuid(),
  path_id uuid references public.builder_paths(id) on delete cascade,
  title text not null,
  description text,
  sort_order int default 0
);

create table if not exists public.builders (
  id uuid primary key default gen_random_uuid(),
  track_id uuid references public.builder_tracks(id) on delete cascade,
  title text not null,
  description text,
  image_url text,
  answer_prompt text not null,
  sort_order int default 0,
  is_published boolean default false
);

create table if not exists public.builder_topics (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid references public.builders(id) on delete cascade,
  title text not null,
  description text,
  sort_order int default 0
);

create table if not exists public.builder_lessons (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid references public.builder_topics(id) on delete cascade,
  title text not null,
  body text not null,
  sort_order int default 0
);

create table if not exists public.builder_assignments (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid references public.hubs(id) on delete cascade,
  path_id uuid references public.builder_paths(id) on delete cascade,
  assigned_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  unique (hub_id, path_id)
);

create table if not exists public.builder_progress (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  builder_id uuid references public.builders(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  completed_lesson_ids uuid[] default '{}',
  status text not null default 'not_started' check (status in ('not_started','in_progress','completed')),
  updated_at timestamptz default now(),
  unique (project_id, builder_id, user_id)
);

create table if not exists public.builder_answers (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  builder_id uuid references public.builders(id) on delete cascade,
  answer_text text,
  status text not null default 'draft' check (status in ('draft','published','updated_after_publish','archived')),
  version_number int default 1,
  created_by uuid references public.profiles(id),
  updated_by uuid references public.profiles(id),
  published_by uuid references public.profiles(id),
  published_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (project_id, builder_id)
);

create table if not exists public.builder_answer_images (
  id uuid primary key default gen_random_uuid(),
  answer_id uuid references public.builder_answers(id) on delete cascade,
  image_url text not null,
  sort_order int default 0,
  uploaded_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

create table if not exists public.answer_scores (
  id uuid primary key default gen_random_uuid(),
  answer_id uuid references public.builder_answers(id) on delete cascade,
  project_id uuid references public.projects(id) on delete cascade,
  builder_id uuid references public.builders(id) on delete cascade,
  scored_by uuid references public.profiles(id),
  score numeric(4,2) check (score >= 0 and score <= 10),
  feedback text,
  status text not null default 'submitted' check (status in ('draft','submitted','released','needs_revision')),
  is_released boolean default false,
  released_by uuid references public.profiles(id),
  released_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.project_scores (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  scored_by uuid references public.profiles(id),
  score numeric(4,2) check (score >= 0 and score <= 10),
  feedback text,
  status text not null default 'submitted' check (status in ('draft','submitted','released','needs_revision')),
  is_released boolean default false,
  released_by uuid references public.profiles(id),
  released_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.activity_posts (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id),
  hub_id uuid references public.hubs(id),
  project_id uuid references public.projects(id),
  author_id uuid references public.profiles(id) default auth.uid(),
  type text not null check (type in ('post','idea','question','resource','announcement')),
  body text not null,
  visibility text not null default 'hub' check (visibility in ('project_team','hub','institution')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.activity_post_images (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.activity_posts(id) on delete cascade,
  image_url text not null,
  sort_order int default 0,
  created_at timestamptz default now()
);

create table if not exists public.activity_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.activity_posts(id) on delete cascade,
  author_id uuid references public.profiles(id) default auth.uid(),
  body text not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.post_kudos (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.activity_posts(id) on delete cascade,
  user_id uuid references public.profiles(id) default auth.uid(),
  created_at timestamptz default now(),
  unique (post_id, user_id)
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  type text not null,
  title text not null,
  body text,
  entity_type text,
  entity_id uuid,
  is_read boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id),
  hub_id uuid references public.hubs(id),
  title text not null,
  description text,
  starts_at timestamptz,
  ends_at timestamptz,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

create table if not exists public.project_notes (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  answer_id uuid references public.builder_answers(id) on delete cascade,
  author_id uuid references public.profiles(id) default auth.uid(),
  body text not null,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.institutions enable row level security;
alter table public.institution_members enable row level security;
alter table public.hubs enable row level security;
alter table public.hub_members enable row level security;
alter table public.invites enable row level security;
alter table public.projects enable row level security;
alter table public.project_members enable row level security;
alter table public.builder_paths enable row level security;
alter table public.builder_tracks enable row level security;
alter table public.builders enable row level security;
alter table public.builder_topics enable row level security;
alter table public.builder_lessons enable row level security;
alter table public.builder_assignments enable row level security;
alter table public.builder_progress enable row level security;
alter table public.builder_answers enable row level security;
alter table public.answer_scores enable row level security;
alter table public.project_scores enable row level security;
alter table public.activity_posts enable row level security;
alter table public.activity_comments enable row level security;
alter table public.post_kudos enable row level security;
alter table public.notifications enable row level security;
alter table public.events enable row level security;
alter table public.project_notes enable row level security;

create or replace function public.is_institution_manager(target_institution uuid)
returns boolean language sql stable security definer as $$
  select exists (
    select 1 from public.institution_members im
    where im.user_id = auth.uid()
      and im.institution_id = target_institution
      and im.status = 'active'
      and im.role in ('admin','institution_manager')
  );
$$;

create or replace function public.is_faculty_or_manager_for_hub(target_hub uuid)
returns boolean language sql stable security definer as $$
  select exists (
    select 1 from public.hub_members hm
    where hm.user_id = auth.uid()
      and hm.hub_id = target_hub
      and hm.status = 'active'
      and hm.role in ('manager','faculty')
  );
$$;

create or replace function public.is_project_member(target_project uuid)
returns boolean language sql stable security definer as $$
  select exists (
    select 1 from public.project_members pm
    where pm.user_id = auth.uid() and pm.project_id = target_project
  );
$$;

create policy "profiles read authenticated" on public.profiles for select to authenticated using (true);
create policy "profile self update" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

create policy "institutions readable by members" on public.institutions for select to authenticated using (
  exists (select 1 from public.institution_members im where im.institution_id = id and im.user_id = auth.uid())
);
create policy "institution managers update institutions" on public.institutions for update to authenticated using (public.is_institution_manager(id));

create policy "hubs readable by hub members" on public.hubs for select to authenticated using (
  exists (select 1 from public.hub_members hm where hm.hub_id = id and hm.user_id = auth.uid())
  or public.is_institution_manager(institution_id)
);
create policy "institution managers create hubs" on public.hubs for insert to authenticated with check (public.is_institution_manager(institution_id));

create policy "projects readable by hub or team" on public.projects for select to authenticated using (
  visibility in ('hub','institution')
  and exists (select 1 from public.hub_members hm where hm.hub_id = hub_id and hm.user_id = auth.uid())
  or public.is_project_member(id)
  or public.is_faculty_or_manager_for_hub(hub_id)
);
create policy "project members update project" on public.projects for update to authenticated using (public.is_project_member(id) or public.is_faculty_or_manager_for_hub(hub_id));
create policy "hub members create projects" on public.projects for insert to authenticated with check (
  exists (select 1 from public.hub_members hm where hm.hub_id = hub_id and hm.user_id = auth.uid())
);

create policy "project members maintain answers" on public.builder_answers for all to authenticated using (public.is_project_member(project_id)) with check (public.is_project_member(project_id));
create policy "published answers readable by hub" on public.builder_answers for select to authenticated using (
  status in ('published','updated_after_publish')
  and exists (
    select 1 from public.projects p join public.hub_members hm on hm.hub_id = p.hub_id
    where p.id = project_id and hm.user_id = auth.uid()
  )
);

create policy "activity posts read by hub members" on public.activity_posts for select to authenticated using (
  exists (select 1 from public.hub_members hm where hm.hub_id = hub_id and hm.user_id = auth.uid())
);
create policy "activity posts create by hub members" on public.activity_posts for insert to authenticated with check (
  exists (select 1 from public.hub_members hm where hm.hub_id = hub_id and hm.user_id = auth.uid())
);
create policy "activity comments read by post visibility" on public.activity_comments for select to authenticated using (true);
create policy "activity comments insert authenticated" on public.activity_comments for insert to authenticated with check (author_id = auth.uid());
create policy "kudos own insert" on public.post_kudos for insert to authenticated with check (user_id = auth.uid());
create policy "kudos own delete" on public.post_kudos for delete to authenticated using (user_id = auth.uid());

create policy "students read released answer scores only" on public.answer_scores for select to authenticated using (
  is_released = true
  or exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);
create policy "faculty score answers" on public.answer_scores for insert to authenticated with check (
  exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);
create policy "managers release answer scores" on public.answer_scores for update to authenticated using (
  exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);

create policy "students read released project scores only" on public.project_scores for select to authenticated using (
  is_released = true
  or exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);
create policy "faculty score projects" on public.project_scores for insert to authenticated with check (
  exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);
create policy "managers release project scores" on public.project_scores for update to authenticated using (
  exists (select 1 from public.projects p where p.id = project_id and public.is_faculty_or_manager_for_hub(p.hub_id))
);

create policy "notifications own" on public.notifications for select to authenticated using (user_id = auth.uid());

create or replace function public.redeem_invite(invite_token text)
returns void language plpgsql security definer as $$
declare
  inv public.invites%rowtype;
  scope_row record;
begin
  select * into inv from public.invites where token = invite_token for update;
  if not found then raise exception 'Invite not found'; end if;
  if not inv.is_active then raise exception 'Invite inactive'; end if;
  if inv.expires_at is not null and inv.expires_at < now() then raise exception 'Invite expired'; end if;
  if inv.used_count >= inv.max_uses then raise exception 'Invite already used'; end if;

  if inv.scope_type = 'multiple_institutions' then
    for scope_row in select institution_id from public.invite_institution_scopes where invite_id = inv.id loop
      insert into public.institution_members(institution_id, user_id, role)
      values (scope_row.institution_id, auth.uid(), inv.role)
      on conflict do nothing;
    end loop;
  else
    insert into public.institution_members(institution_id, user_id, role)
    values (inv.institution_id, auth.uid(), inv.role)
    on conflict do nothing;
  end if;

  if inv.hub_id is not null then
    insert into public.hub_members(hub_id, user_id, role)
    values (inv.hub_id, auth.uid(), case when inv.role = 'institution_manager' then 'manager' else inv.role end)
    on conflict do nothing;
  end if;

  insert into public.invite_redemptions(invite_id, redeemed_by) values (inv.id, auth.uid()) on conflict do nothing;
  update public.invites set used_count = used_count + 1 where id = inv.id;
end;
$$;
