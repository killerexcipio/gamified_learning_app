import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/common_widgets.dart';

class BuildersScreen extends ConsumerWidget {
  const BuildersScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (section) {
      case 'In Progress':
        return const _InProgressBuilders();
      case 'Published':
        return const _PublishedBuilders();
      case 'Scores':
        return const _BuilderScores();
      case 'Tracks':
      default:
        return const _TracksView();
    }
  }
}

class _TracksView extends ConsumerWidget {
  const _TracksView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final total = repo.builders.length;
    final published = repo.builders.where((b) => repo.answerFor(repo.activeProjectId, b.id)?.isPublished == true).length;
    final ratio = total == 0 ? 0.0 : published / total;

    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.auto_stories_outlined, color: RbColors.accent, size: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repo.activeProject.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    const Text('Project Builders', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Track completion', style: Theme.of(context).textTheme.titleMedium)),
                    Text('($published / $total) ${(ratio * 100).round()}% Builders Published', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(value: ratio, minHeight: 16, backgroundColor: RbColors.pageBg, color: RbColors.accent),
                ),
              ],
            ),
          ),
        ),
        for (final track in repo.tracks) ...[
          RbSectionHeader(title: track.title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(track.description, style: const TextStyle(color: RbColors.muted)),
          ),
          const SizedBox(height: 8),
          for (final builder in repo.builders.where((b) => b.trackId == track.id)) _BuilderCard(builder: builder),
        ],
      ],
    );
  }
}

class _BuilderCard extends ConsumerWidget {
  const _BuilderCard({required this.builder});

  final BuilderModule builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final totalLessons = repo.lessonsForBuilder(builder.id).length;
    final done = repo.completedCountForBuilder(repo.activeProjectId, builder.id, repo.currentUserId);
    final answer = repo.answerFor(repo.activeProjectId, builder.id);
    final isPublished = answer?.isPublished == true;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/builder/${builder.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(color: RbColors.paleTeal, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.auto_awesome_motion_outlined, color: RbColors.accent, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(builder.title, style: Theme.of(context).textTheme.titleMedium)),
                        if (isPublished) const RbRoleChip(label: 'Published', color: RbColors.success),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(builder.description, style: const TextStyle(color: RbColors.muted)),
                    const SizedBox(height: 14),
                    Text('Progress ($done/$totalLessons)', style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    ProgressDots(completed: totalLessons == 0 && isPublished ? 1 : done, total: totalLessons),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: RbColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _InProgressBuilders extends ConsumerWidget {
  const _InProgressBuilders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final items = repo.builders.where((b) {
      final ratio = repo.builderCompletionRatio(repo.activeProjectId, b.id, repo.currentUserId);
      final answer = repo.answerFor(repo.activeProjectId, b.id);
      return ratio > 0 && answer?.isPublished != true;
    }).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 8),
      children: [
        const RbSectionHeader(title: 'In Progress'),
        if (items.isEmpty) const EmptyState(icon: Icons.hourglass_empty, title: 'Nothing in progress', message: 'Open a Builder and start reading.') else for (final builder in items) _BuilderCard(builder: builder),
      ],
    );
  }
}

class _PublishedBuilders extends ConsumerWidget {
  const _PublishedBuilders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final answers = repo.publishedAnswersForProject(repo.activeProjectId);
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 8),
      children: [
        const RbSectionHeader(title: 'Published Builder Answers'),
        if (answers.isEmpty)
          const EmptyState(icon: Icons.publish_outlined, title: 'No published answers', message: 'Publish a Builder answer to make it appear on the Project Page.')
        else
          for (final answer in answers)
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.article_outlined, color: RbColors.accent)),
                title: Text(repo.builderById(answer.builderId).title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text(answer.answerText, maxLines: 3, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/project/${answer.projectId}'),
              ),
            ),
      ],
    );
  }
}

class _BuilderScores extends ConsumerWidget {
  const _BuilderScores();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final released = repo.releasedScoresForProject(repo.activeProjectId).where((s) => s.type == ScoreType.builderAnswer).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 8),
      children: [
        const RbSectionHeader(title: 'Released Builder Scores'),
        if (released.isEmpty)
          const EmptyState(icon: Icons.lock_clock, title: 'No released scores', message: 'Faculty or managers must release scores before students can see them.')
        else
          for (final score in released)
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.scoreboard, color: RbColors.accent)),
                title: Text('${repo.builderById(score.builderId!).title}: ${score.score.toStringAsFixed(1)} / 10'),
                subtitle: Text(score.feedback),
              ),
            ),
      ],
    );
  }
}
