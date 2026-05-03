import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';


import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (section) {
      case 'Settings':
        return const _SettingsView();
      case 'Invites':
        return const _InvitesView();
      case 'Admin Mode':
        return const _AdminModeView();
      case 'Profile':
      default:
        return const _ProfileView();
    }
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final user = repo.currentUser;
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Column(
            children: [
              UserAvatar(user: user, radius: 46),
              const SizedBox(height: 12),
              Text(user.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
              Text(user.email, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [for (final role in user.roles) RbRoleChip(label: role.label)]),
            ],
          ),
        ),
        const RbSectionHeader(title: 'Powers'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(spacing: 8, runSpacing: 8, children: [for (final power in user.powers) RbRoleChip(label: power, color: RbColors.muted)]),
          ),
        ),
        const RbSectionHeader(title: 'Demo user switcher'),
        Card(
          child: Column(
            children: [
              for (final u in repo.users)
                RadioListTile<String>(
                  value: u.id,
                  groupValue: repo.currentUserId,
                  onChanged: (value) => repo.switchCurrentUser(value!),
                  title: Text(u.name),
                  subtitle: Text(u.roles.map((e) => e.label).join(', ')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        const RbSectionHeader(title: 'Sync and offline cache'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Offline caching', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('Builder progress, drafts, activities, and score changes are cached locally using Hive. In this demo, Sync Now clears the pending sync queue. In production this queue should push to Supabase.'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RbRoleChip(label: '${repo.pendingSyncCount} pending sync items', color: repo.pendingSyncCount == 0 ? RbColors.success : RbColors.warning),
                    const Spacer(),
                    OutlinedButton(onPressed: repo.flushSyncQueue, child: const Text('Sync Now')),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_outlined, color: RbColors.accent),
            title: Text(repo.supabaseEnabled ? 'Supabase configured' : 'Supabase not configured'),
            subtitle: Text(repo.supabaseEnabled ? 'The app detected Supabase credentials in .env.' : 'Use .env and supabase/schema.sql to connect the production backend.'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.restart_alt, color: RbColors.danger),
            title: const Text('Reset local demo data'),
            subtitle: const Text('Clears cached posts, answers, scores, and progress.'),
            onTap: () => _confirmReset(context, repo),
          ),
        ),
      ],
    );
  }

  void _confirmReset(BuildContext context, AppRepository repo) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset demo data?'),
        content: const Text('This clears local cached demo state.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              repo.resetLocalDemoData();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _InvitesView extends ConsumerWidget {
  const _InvitesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        const RbSectionHeader(title: 'Demo invite links'),
        for (final invite in repo.invites)
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.link, color: RbColors.accent)),
              title: Text('${invite.roleLabel} · ${invite.scopeLabel}', style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${invite.link}\n${invite.usedCount}/${invite.maxUses} used'),
              isThreeLine: true,
              trailing: IconButton(
                tooltip: 'Copy link',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: invite.link));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite copied.')));
                },
                icon: const Icon(Icons.copy),
              ),
            ),
          ),
      ],
    );
  }
}

class _AdminModeView extends ConsumerWidget {
  const _AdminModeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Mode', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(repo.canOpenAdmin ? 'Your current demo role can access the admin/faculty/manager workspace.' : 'Switch to an admin, manager, or faculty demo user first.'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: repo.canOpenAdmin ? () => context.push('/admin') : null,
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text('Open Admin Panel'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
