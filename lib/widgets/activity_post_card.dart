import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/theme.dart';
import '../core/app_repository.dart';
import '../core/models.dart';
import 'common_widgets.dart';

class ActivityPostCard extends ConsumerWidget {
  const ActivityPostCard({super.key, required this.post});

  final ActivityPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final author = repo.userById(post.authorId);
    final project = post.projectId == null ? null : repo.projectById(post.projectId!);
    final hub = repo.hubById(post.hubId);
    final comments = repo.commentsForPost(post.id);
    final hasKudos = post.kudosUserIds.contains(repo.currentUserId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(user: author, radius: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text('${hub.name} hub · ${compactDate(post.createdAt)}', style: const TextStyle(color: RbColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                PostTypeBadge(type: post.type),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            if (post.imagePath != null) ...[
              const SizedBox(height: 12),
              RbLocalImage(path: post.imagePath!),
            ],
            if (project != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RbColors.paleTeal,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspaces_outline, color: RbColors.accent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(project.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${post.kudosUserIds.length} Kudos', style: const TextStyle(color: RbColors.muted, fontWeight: FontWeight.w700)),
                const SizedBox(width: 16),
                Text('${comments.length} Comments', style: const TextStyle(color: RbColors.muted, fontWeight: FontWeight.w700)),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => repo.toggleKudos(post.id),
                  icon: Icon(hasKudos ? Icons.favorite : Icons.favorite_border, color: hasKudos ? RbColors.danger : RbColors.muted),
                  label: Text(hasKudos ? 'Kudoed' : 'Kudos'),
                ),
                TextButton.icon(
                  onPressed: () => _showComments(context, ref),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Comment'),
                ),
                const Spacer(),
                if (post.type == PostType.idea)
                  const RbRoleChip(label: 'Brainstorm', color: RbColors.warning)
                else if (post.type == PostType.question)
                  const RbRoleChip(label: 'Answer')
                else if (post.type == PostType.resource)
                  const RbRoleChip(label: 'Save', color: Color(0xFF7E57C2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          final repo = ref.watch(appRepositoryProvider);
          final comments = repo.commentsForPost(post.id);
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Comments', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 260,
                  child: comments.isEmpty
                      ? const EmptyState(icon: Icons.chat_bubble_outline, title: 'No comments yet', message: 'Start the conversation.')
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            final author = repo.userById(comment.authorId);
                            return ListTile(
                              leading: UserAvatar(user: author, radius: 16),
                              title: Text(author.name),
                              subtitle: Text(comment.body),
                              trailing: Text(compactDate(comment.createdAt)),
                            );
                          },
                        ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Write a comment...'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        if (controller.text.trim().isEmpty) return;
                        repo.addComment(post.id, controller.text);
                        controller.clear();
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    ).whenComplete(controller.dispose);
  }
}
