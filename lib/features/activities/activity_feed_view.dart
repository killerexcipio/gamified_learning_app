import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/activity_post_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/create_post_sheet.dart';

/// Reusable Activities feed for the Home feed and hub-specific feeds.
///
/// The folder was intentionally kept feature-first, so all activity-feed
/// behaviour lives here instead of being hidden only in generic widgets.
class ActivityFeedView extends ConsumerStatefulWidget {
  const ActivityFeedView({
    super.key,
    this.hubId,
    this.showComposer = true,
    this.emptyTitle = 'No activities',
    this.emptyMessage = 'Create a post to start the conversation.',
    this.topPadding = 8,
  });

  /// Null means show every post visible to the current user.
  final String? hubId;
  final bool showComposer;
  final String emptyTitle;
  final String emptyMessage;
  final double topPadding;

  @override
  ConsumerState<ActivityFeedView> createState() => _ActivityFeedViewState();
}

class _ActivityFeedViewState extends ConsumerState<ActivityFeedView> {
  PostType? _filter;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final basePosts = widget.hubId == null ? [...repo.posts] : repo.postsForHub(widget.hubId!);
    basePosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final posts = basePosts.where((post) => _filter == null || post.type == _filter).toList();

    return RefreshIndicator(
      onRefresh: () async => repo.flushSyncQueue(),
      child: ListView(
        padding: EdgeInsets.only(bottom: 120, top: widget.topPadding),
        children: [
          if (widget.showComposer) _ActivityComposerCard(repo: repo),
          _ActivityFilterBar(
            selected: _filter,
            posts: basePosts,
            onChanged: (value) => setState(() => _filter = value),
          ),
          if (posts.isEmpty)
            EmptyState(
              icon: Icons.dynamic_feed_outlined,
              title: widget.emptyTitle,
              message: widget.emptyMessage,
            )
          else
            for (final post in posts) ActivityPostCard(post: post),
        ],
      ),
    );
  }
}

class _ActivityComposerCard extends ConsumerWidget {
  const _ActivityComposerCard({required this.repo});

  final AppRepository repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
                  child: const Text(
                    'Share an update, idea, question, or resource...',
                    style: TextStyle(color: RbColors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityFilterBar extends StatelessWidget {
  const _ActivityFilterBar({
    required this.selected,
    required this.posts,
    required this.onChanged,
  });

  final PostType? selected;
  final List<ActivityPost> posts;
  final ValueChanged<PostType?> onChanged;

  @override
  Widget build(BuildContext context) {
    int countFor(PostType type) => posts.where((post) => post.type == type).length;

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('All (${posts.length})'),
              selected: selected == null,
              onSelected: (_) => onChanged(null),
            ),
          ),
          for (final type in PostType.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('${type.label} (${countFor(type)})'),
                selected: selected == type,
                avatar: Icon(type.icon, size: 16, color: selected == type ? Colors.white : type.color),
                selectedColor: type.color,
                labelStyle: TextStyle(
                  color: selected == type ? Colors.white : RbColors.text,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => onChanged(type),
              ),
            ),
        ],
      ),
    );
  }
}
