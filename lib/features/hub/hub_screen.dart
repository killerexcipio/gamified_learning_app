import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../activities/activity_feed_view.dart';
import '../../widgets/common_widgets.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final hub = repo.activeHub;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.hexagon_outlined, color: RbColors.accent, size: 34),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hub.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    Text(section.isEmpty ? 'Activities' : section, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                iconColor: Colors.white,
                tooltip: 'Switch hub',
                onSelected: repo.setActiveHub,
                itemBuilder: (context) => repo.hubs.map((h) => PopupMenuItem(value: h.id, child: Text(h.name))).toList(),
              ),
            ],
          ),
        ),
        Expanded(child: _HubBody(section: section)),
      ],
    );
  }
}

class _HubBody extends ConsumerWidget {
  const _HubBody({required this.section});
  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (section) {
      case 'Groups':
        return const _GroupsView();
      case 'Events':
        return const _EventsView();
      case 'Members':
        return const _MembersView();
      case 'Activities':
      default:
        return const _ActivitiesView();
    }
  }
}

class _ActivitiesView extends ConsumerWidget {
  const _ActivitiesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ActivityFeedView(
      hubId: repo.activeHubId,
      showComposer: true,
      emptyTitle: 'No hub activities',
      emptyMessage: 'Create a post to start the hub feed.',
    );
  }
}

class _GroupsView extends ConsumerWidget {
  const _GroupsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final groups = repo.groups.where((e) => e.hubId == repo.activeHubId).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        for (final group in groups)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(group.name, style: Theme.of(context).textTheme.titleMedium)),
                      RbRoleChip(label: group.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Projects', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final projectId in group.projectIds.take(4))
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: CircleAvatar(
                            backgroundColor: RbColors.paleTeal,
                            child: Text(repo.projectById(projectId).name[0], style: const TextStyle(color: RbColors.accent, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      if (group.projectIds.length > 4) CircleAvatar(child: Text('+${group.projectIds.length - 4}')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _Metric(label: 'Members', value: group.memberIds.length.toString(), icon: Icons.people_outline)),
                      Expanded(child: _Metric(label: 'Managers', value: group.managerIds.length.toString(), icon: Icons.manage_accounts_outlined)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (groups.isEmpty) const EmptyState(icon: Icons.groups_outlined, title: 'No groups yet', message: 'Managers can create groups for cohorts or sections.'),
      ],
    );
  }
}

class _EventsView extends ConsumerWidget {
  const _EventsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final events = repo.events.where((e) => e.hubId == repo.activeHubId).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        for (final event in events)
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.event, color: RbColors.accent)),
              title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${DateFormat('EEE, MMM d').format(event.startsAt)} · ${event.description}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        if (events.isEmpty) const EmptyState(icon: Icons.event_busy, title: 'No events', message: 'Upcoming workshops and demo days will appear here.'),
      ],
    );
  }
}

class _MembersView extends ConsumerStatefulWidget {
  const _MembersView();

  @override
  ConsumerState<_MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends ConsumerState<_MembersView> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final users = repo.users.where((u) {
      final haystack = '${u.name} ${u.email} ${u.powers.join(' ')}'.toLowerCase();
      return haystack.contains(_q.toLowerCase());
    }).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (value) => setState(() => _q = value),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by name or power'),
          ),
        ),
        for (final user in users)
          Card(
            child: ListTile(
              leading: UserAvatar(user: user),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final role in user.roles) RbRoleChip(label: role.label),
                  for (final power in user.powers.take(3)) RbRoleChip(label: power, color: RbColors.muted),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: RbColors.accent),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            Text(label, style: const TextStyle(color: RbColors.muted, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
