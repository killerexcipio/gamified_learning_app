import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/activity_post_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/create_post_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PostType? _filter;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final posts = repo.posts
        .where((p) => _filter == null || p.type == _filter)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return RefreshIndicator(
      onRefresh: () async => repo.flushSyncQueue(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            decoration: const BoxDecoration(
              color: RbColors.darkShell,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                Text('Welcome back, ${repo.currentUser.name}.', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                _QuickStats(repo: repo),
              ],
            ),
          ),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => showCreatePostSheet(context, ref),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    UserAvatar(user: repo.currentUser),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: RbColors.pageBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Share an update, idea, question, or resource...', style: TextStyle(color: RbColors.muted)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text('All (${repo.posts.length})'), selected: _filter == null, onSelected: (_) => setState(() => _filter = null)),
                ),
                for (final type in PostType.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type.label),
                      selected: _filter == type,
                      avatar: Icon(type.icon, size: 16, color: _filter == type ? Colors.white : type.color),
                      selectedColor: type.color,
                      labelStyle: TextStyle(color: _filter == type ? Colors.white : RbColors.text, fontWeight: FontWeight.w700),
                      onSelected: (_) => setState(() => _filter = type),
                    ),
                  ),
              ],
            ),
          ),
          if (posts.isEmpty)
            const EmptyState(icon: Icons.dynamic_feed_outlined, title: 'No activities', message: 'Try another filter or create a new post.')
          else
            for (final post in posts) ActivityPostCard(post: post),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.repo});
  final AppRepository repo;

  @override
  Widget build(BuildContext context) {
    final published = repo.publishedAnswersForProject(repo.activeProjectId).length;
    final projectScores = repo.releasedScoresForProject(repo.activeProjectId).length;
    return Row(
      children: [
        Expanded(child: _StatTile(label: 'Projects', value: repo.projectsForCurrentUser().length.toString(), icon: Icons.workspaces_outline)),
        const SizedBox(width: 8),
        Expanded(child: _StatTile(label: 'Published', value: published.toString(), icon: Icons.publish_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _StatTile(label: 'Scores', value: projectScores.toString(), icon: Icons.scoreboard_outlined)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: RbColors.accent),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
