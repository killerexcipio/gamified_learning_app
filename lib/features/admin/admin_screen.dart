import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/common_widgets.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Invites'),
              Tab(text: 'Builders'),
              Tab(text: 'Scores'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: repo.canOpenAdmin
            ? const TabBarView(
                children: [
                  _UsersAdminTab(),
                  _InvitesAdminTab(),
                  _BuildersAdminTab(),
                  _ScoresAdminTab(),
                  _AnalyticsAdminTab(),
                ],
              )
            : const Center(child: Text('You need admin, manager, or faculty access.')),
      ),
    );
  }
}

class _UsersAdminTab extends ConsumerWidget {
  const _UsersAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 100, top: 12),
      children: [
        const RbSectionHeader(title: 'People and roles'),
        for (final user in repo.users)
          Card(
            child: ListTile(
              leading: UserAvatar(user: user),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final role in user.roles) RbRoleChip(label: role.label)],
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demo action: $value for ${user.name}'))),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Add to hub', child: Text('Add to hub')),
                  PopupMenuItem(value: 'Assign faculty', child: Text('Assign faculty')),
                  PopupMenuItem(value: 'Make manager', child: Text('Make manager')),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _InvitesAdminTab extends ConsumerWidget {
  const _InvitesAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 100, top: 12),
      children: [
        const RbSectionHeader(title: 'Generated demo links'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('These 10 demo links are seeded by position. In production, generate tokens in Supabase and redeem them with an Edge Function.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: RbColors.muted)),
        ),
        const SizedBox(height: 8),
        for (final invite in repo.invites)
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.vpn_key_outlined, color: RbColors.accent)),
              title: Text(invite.roleLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${invite.scopeLabel}\n${invite.link}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: invite.link));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite link copied.')));
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _BuildersAdminTab extends ConsumerWidget {
  const _BuildersAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        RbSectionHeader(
          title: 'Builder CMS',
          trailing: FilledButton.icon(
            onPressed: () => _showCreateBuilder(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ),
        for (final track in repo.tracks) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(track.title, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final builder in repo.builders.where((b) => b.trackId == track.id))
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.auto_stories_outlined, color: RbColors.accent)),
                title: Text(builder.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${builder.description}\nPrompt: ${builder.answerPrompt}', maxLines: 3, overflow: TextOverflow.ellipsis),
                isThreeLine: true,
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _showBuilderPreview(context, builder),
              ),
            ),
        ],
      ],
    );
  }

  void _showCreateBuilder(BuildContext context, WidgetRef ref) {
    final repo = ref.read(appRepositoryProvider);
    final title = TextEditingController();
    final description = TextEditingController();
    final prompt = TextEditingController();
    String trackId = repo.tracks.first.id;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final bottom = MediaQuery.of(context).viewInsets.bottom;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Builder', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: trackId,
                    decoration: const InputDecoration(labelText: 'Track'),
                    items: repo.tracks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title))).toList(),
                    onChanged: (value) => setState(() => trackId = value!),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 10),
                  TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
                  const SizedBox(height: 10),
                  TextField(controller: prompt, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Answer prompt')),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      if (title.text.trim().isEmpty) return;
                      repo.createBuilder(trackId: trackId, title: title.text, description: description.text, answerPrompt: prompt.text);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Builder'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).whenComplete(() {
      title.dispose();
      description.dispose();
      prompt.dispose();
    });
  }

  void _showBuilderPreview(BuildContext context, BuilderModule builder) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(builder.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(builder.description),
            const SizedBox(height: 12),
            Text('Answer prompt', style: Theme.of(context).textTheme.titleMedium),
            Text(builder.answerPrompt),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ScoresAdminTab extends ConsumerWidget {
  const _ScoresAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final answers = repo.answers.where((a) => a.isPublished).toList();
    final projectScores = repo.scores.where((s) => s.type == ScoreType.project).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        const RbSectionHeader(title: 'Review Queue'),
        for (final answer in answers)
          _AnswerReviewCard(answer: answer),
        const RbSectionHeader(title: 'Project Scores'),
        for (final score in projectScores)
          _ScoreReleaseCard(score: score),
        if (answers.isEmpty && projectScores.isEmpty)
          const EmptyState(icon: Icons.rate_review_outlined, title: 'Nothing to review', message: 'Published Builder answers will appear here.'),
      ],
    );
  }
}

class _AnswerReviewCard extends ConsumerWidget {
  const _AnswerReviewCard({required this.answer});

  final BuilderAnswer answer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final builder = repo.builderById(answer.builderId);
    final score = repo.scores.where((s) => s.answerId == answer.id).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('${repo.projectById(answer.projectId).name} · ${builder.title}', style: Theme.of(context).textTheme.titleMedium)),
                RbRoleChip(label: score.isEmpty ? 'Unscored' : (score.first.isReleased ? 'Released' : 'Unreleased'), color: score.isEmpty ? RbColors.warning : (score.first.isReleased ? RbColors.success : RbColors.warning)),
              ],
            ),
            const SizedBox(height: 8),
            Text(answer.answerText, maxLines: 4, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(onPressed: () => _showScoreDialog(context, ref, answer), icon: const Icon(Icons.scoreboard), label: const Text('Score')),
                const SizedBox(width: 8),
                if (score.isNotEmpty && !score.first.isReleased) FilledButton(onPressed: () => repo.releaseScore(score.first.id), child: const Text('Release')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(BuildContext context, WidgetRef ref, BuilderAnswer answer) {
    final scoreCtrl = TextEditingController(text: '8.0');
    final feedbackCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Score Builder Answer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: scoreCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score out of 10')),
            const SizedBox(height: 10),
            TextField(controller: feedbackCtrl, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Feedback')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(appRepositoryProvider).upsertAnswerScore(answer: answer, score: double.tryParse(scoreCtrl.text) ?? 0, feedback: feedbackCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ).whenComplete(() {
      scoreCtrl.dispose();
      feedbackCtrl.dispose();
    });
  }
}

class _ScoreReleaseCard extends ConsumerWidget {
  const _ScoreReleaseCard({required this.score});

  final ScoreRecord score;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: score.isReleased ? RbColors.paleTeal : Colors.orange.shade100, child: Icon(score.isReleased ? Icons.lock_open : Icons.lock_clock, color: score.isReleased ? RbColors.accent : RbColors.warning)),
        title: Text('${repo.projectById(score.projectId).name} · ${score.score.toStringAsFixed(1)} / 10'),
        subtitle: Text(score.feedback),
        trailing: score.isReleased ? const RbRoleChip(label: 'Released', color: RbColors.success) : FilledButton(onPressed: () => repo.releaseScore(score.id), child: const Text('Release')),
      ),
    );
  }
}

class _AnalyticsAdminTab extends ConsumerWidget {
  const _AnalyticsAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final published = repo.answers.where((a) => a.isPublished).length;
    final unreleased = repo.unreleasedScores().length;
    return ListView(
      padding: const EdgeInsets.only(bottom: 120, top: 12),
      children: [
        const RbSectionHeader(title: 'Demo Analytics'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(children: [Expanded(child: _Metric(label: 'Users', value: repo.users.length.toString(), icon: Icons.people)), Expanded(child: _Metric(label: 'Projects', value: repo.projects.length.toString(), icon: Icons.workspaces))]),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: _Metric(label: 'Published', value: published.toString(), icon: Icons.publish)), Expanded(child: _Metric(label: 'Unreleased Scores', value: unreleased.toString(), icon: Icons.lock_clock))]),
              ],
            ),
          ),
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text('Production analytics should log events such as builder_started, lesson_completed, answer_published, post_created, score_submitted, and score_released.'),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: RbColors.paleTeal, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: RbColors.accent),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: RbColors.muted)),
        ],
      ),
    );
  }
}
