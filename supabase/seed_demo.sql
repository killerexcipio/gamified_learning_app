-- Demo tenant and invite seeds. Run after schema.sql.
-- The UUIDs are fixed to simplify Flutter demo wiring.

insert into public.institutions (id, name, slug, description)
values
  ('00000000-0000-0000-0000-000000000101', 'BRACU', 'bracu', 'Demo university tenant for innovation cohorts.'),
  ('00000000-0000-0000-0000-000000000102', 'SOL Institute', 'sol-institute', 'Second institution used to demonstrate multi-institution managers.')
on conflict (id) do nothing;

insert into public.hubs (id, institution_id, name, slug, description)
values
  ('00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000101', 'BRACU Innovation Hub', 'bracu-innovation', 'Main BRACU hub.'),
  ('00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000101', 'SOL Happiness Index Cohort', 'sol-happiness-index', 'Cohort hub for SOL Happiness Index.'),
  ('00000000-0000-0000-0000-000000000203', '00000000-0000-0000-0000-000000000101', 'Innovation Builders Cohort', 'innovation-builders', 'General builder training group.')
on conflict (id) do nothing;

insert into public.invites (id, token, role, institution_id, hub_id, scope_type, max_uses)
values
  ('00000000-0000-0000-0000-000000000301', 'mgr-multi-8KQ2-BRACU-SOL', 'institution_manager', null, null, 'multiple_institutions', 1),
  ('00000000-0000-0000-0000-000000000302', 'mgr-bracu-4XP9-DEMO', 'institution_manager', '00000000-0000-0000-0000-000000000101', null, 'institution', 1),
  ('00000000-0000-0000-0000-000000000303', 'fac-bracu-H7LM-DEMO', 'faculty', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', 'hub', 1),
  ('00000000-0000-0000-0000-000000000304', 'fac-solscore-P2VA-DEMO', 'faculty', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000202', 'hub', 1),
  ('00000000-0000-0000-0000-000000000305', 'stu-bracu-A1F9-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', 'hub', 1),
  ('00000000-0000-0000-0000-000000000306', 'stu-bracu-B2G8-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', 'hub', 1),
  ('00000000-0000-0000-0000-000000000307', 'stu-sol-C3H7-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000202', 'hub', 1),
  ('00000000-0000-0000-0000-000000000308', 'stu-sol-D4J6-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000202', 'hub', 1),
  ('00000000-0000-0000-0000-000000000309', 'stu-builders-E5K5-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000203', 'hub', 1),
  ('00000000-0000-0000-0000-000000000310', 'stu-builders-F6L4-DEMO', 'student', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000203', 'hub', 1)
on conflict (id) do nothing;

insert into public.invite_institution_scopes (invite_id, institution_id)
values
  ('00000000-0000-0000-0000-000000000301', '00000000-0000-0000-0000-000000000101'),
  ('00000000-0000-0000-0000-000000000301', '00000000-0000-0000-0000-000000000102')
on conflict do nothing;

insert into public.builder_paths (id, institution_id, title, description, is_published)
values ('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000101', 'Innovation Foundations', 'Guided project development path.', true)
on conflict (id) do nothing;

insert into public.builder_tracks (id, path_id, title, description, sort_order)
values
  ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000401', 'Ideation', 'Problem, solution, team, and purpose.', 1),
  ('00000000-0000-0000-0000-000000000502', '00000000-0000-0000-0000-000000000401', 'Validation', 'Market, prototype, ecosystem, and competitors.', 2)
on conflict (id) do nothing;

insert into public.builders (id, track_id, title, description, answer_prompt, sort_order, is_published)
values
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000501', 'Problem', 'What need will you meet?', 'What problem are you solving, who feels it, and what evidence shows it matters?', 1, true),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000501', 'Solution', 'What will you make to meet the need?', 'Describe your proposed solution and the smallest useful version you can test.', 2, true),
  ('00000000-0000-0000-0000-000000000603', '00000000-0000-0000-0000-000000000502', 'Target and Market', 'Who is your solution for and where would you sell it?', 'Who are you targeting with your solution? Who are the segments and which would adopt your solution first?', 1, true)
on conflict (id) do nothing;

insert into public.builder_assignments (hub_id, path_id)
values
  ('00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000401'),
  ('00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000401'),
  ('00000000-0000-0000-0000-000000000203', '00000000-0000-0000-0000-000000000401')
on conflict do nothing;
