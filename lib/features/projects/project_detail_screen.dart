import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/common_widgets.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final project = repo.projectById(projectId);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Team'),
              Tab(text: 'Answers'),
              Tab(text: 'Scores'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AboutTab(project: project),
            _TeamTab(project: project),
            _AnswersTab(project: project),
            _ScoresTab(project: project),
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Column(
            children: [
              CircleAvatar(radius: 42, backgroundColor: Colors.white, child: Text(project.name[0], style: const TextStyle(color: RbColors.accent, fontSize: 34, fontWeight: FontWeight.w900))),
              const SizedBox(height: 12),
              Text(project.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(project.tagline, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  RbRoleChip(label: project.location),
                  RbRoleChip(label: project.category),
                  RbRoleChip(label: project.visibility),
                ],
              ),
            ],
          ),
        ),
        const RbSectionHeader(title: 'Brief'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Text(project.description, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        const RbSectionHeader(title: 'Project Page Visibility'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text('Students can view each other\'s Project Pages. Builder drafts and unreleased scores remain private. Published answers appear in the Answers tab.'),
          ),
        ),
      ],
    );
  }
}

class _TeamTab extends ConsumerWidget {
  const _TeamTab({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final members = project.memberIds.map(repo.userById).toList();
    return ListView(
      padding: const EdgeInsets.only(top: 12),
      children: [
        for (final member in members)
          Card(
            child: ListTile(
              leading: UserAvatar(user: member),
              title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  RbRoleChip(label: member.id == project.ownerId ? 'Project Owner' : 'Project Member'),
                  for (final power in member.powers.take(3)) RbRoleChip(label: power, color: RbColors.muted),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}

class _AnswersTab extends ConsumerWidget {
  const _AnswersTab({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final answers = repo.publishedAnswersForProject(project.id);
    return ListView(
      padding: const EdgeInsets.only(bottom: 100, top: 12),
      children: [
        if (answers.isEmpty)
          const EmptyState(icon: Icons.article_outlined, title: 'No published answers', message: 'Project members can publish Builder answers to fill this Project Page.')
        else
          for (final answer in answers)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(repo.builderById(answer.builderId).title, style: Theme.of(context).textTheme.titleLarge)),
                        const RbRoleChip(label: 'Published', color: RbColors.success),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Published by ${repo.userById(answer.publishedBy ?? answer.updatedBy).name} · version ${answer.versionNumber}', style: const TextStyle(color: RbColors.muted)),
                    const SizedBox(height: 12),
                    Text(answer.answerText, style: Theme.of(context).textTheme.bodyLarge),
                    if (answer.imagePaths.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: answer.imagePaths.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) => SizedBox(width: 130, child: RbLocalImage(path: answer.imagePaths[index], height: 110)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => context.push('/builder/${answer.builderId}/reader'),
                        icon: const Icon(Icons.edit_note),
                        label: const Text('Edit Builder'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _ScoresTab extends ConsumerWidget {
  const _ScoresTab({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final scores = repo.releasedScoresForProject(project.id);
    return ListView(
      padding: const EdgeInsets.only(bottom: 100, top: 12),
      children: [
        if (scores.isEmpty)
          const EmptyState(icon: Icons.lock_outline, title: 'Scores not released', message: 'Students can only view scores after faculty, managers, or admins release them.')
        else
          for (final score in scores)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: score.type == ScoreType.project ? RbColors.darkShell : RbColors.paleTeal,
                  child: Icon(score.type == ScoreType.project ? Icons.workspace_premium : Icons.scoreboard, color: score.type == ScoreType.project ? Colors.white : RbColors.accent),
                ),
                title: Text(score.type == ScoreType.project ? 'Project Score: ${score.score.toStringAsFixed(1)} / 10' : '${repo.builderById(score.builderId!).title}: ${score.score.toStringAsFixed(1)} / 10'),
                subtitle: Text(score.feedback),
              ),
            ),
      ],
    );
  }
}
