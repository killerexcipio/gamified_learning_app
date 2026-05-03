import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../widgets/common_widgets.dart';

class BuilderDetailScreen extends ConsumerWidget {
  const BuilderDetailScreen({super.key, required this.builderId});

  final String builderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final builder = repo.builderById(builderId);
    final topics = repo.topicsForBuilder(builderId);
    final lessons = repo.lessonsForBuilder(builderId);
    final completed = repo.completedLessons(repo.activeProjectId, builderId, repo.currentUserId);
    final answer = repo.answerFor(repo.activeProjectId, builderId);
    final canPublish = answer != null && (answer.answerText.trim().isNotEmpty || answer.imagePaths.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(builder.title),
        actions: [
          TextButton(
            onPressed: () => context.push('/builder/$builderId/reader'),
            child: const Text('Answer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 110),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
            decoration: const BoxDecoration(color: RbColors.darkShell),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.auto_awesome_motion_outlined, size: 42, color: RbColors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(builder.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                      const SizedBox(height: 6),
                      Text(builder.description, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 14),
                      Text('(${completed.length} / ${lessons.length}) Topics Completed', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: lessons.isEmpty ? 0 : completed.length / lessons.length,
                          minHeight: 10,
                          color: RbColors.accent,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const RbSectionHeader(title: 'Topics'),
          if (topics.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('This Builder is ready for an answer but has no lesson topics yet. Admins can add content from Admin Mode.'),
              ),
            )
          else
            for (final topic in topics)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(color: RbColors.paleTeal, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.menu_book_outlined, color: RbColors.accent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topic.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(topic.description, style: const TextStyle(color: RbColors.muted)),
                            const SizedBox(height: 10),
                            ProgressDots(
                              completed: topic.lessonIds.where(completed.contains).length,
                              total: topic.lessonIds.length,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          Card(
            color: canPublish ? RbColors.paleTeal : Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Review + Publish', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: canPublish ? RbColors.text : RbColors.muted)),
                        const SizedBox(height: 4),
                        Text(
                          answer?.isPublished == true
                              ? 'Builder already published. You can edit and republish it.'
                              : canPublish
                                  ? 'Publish this answer to the Project Page.'
                                  : 'At least one answer is required before publishing.',
                          style: const TextStyle(color: RbColors.muted),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: canPublish
                        ? () {
                            repo.publishAnswer(repo.activeProjectId, builderId);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Builder answer published to Project Page.')));
                          }
                        : null,
                    icon: const Icon(Icons.publish),
                    label: const Text('Publish'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: () => context.push('/builder/$builderId/reader'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Continue Reading / Answer'),
          ),
        ),
      ),
    );
  }
}
