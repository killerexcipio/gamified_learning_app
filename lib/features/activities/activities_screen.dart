import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'activity_feed_view.dart';

/// Standalone Activities screen for future routing or for turning Activities
/// into a primary bottom-tab destination. The current demo uses the same
/// ActivityFeedView inside Home and Hub.
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key, this.hubId, this.title = 'Activities'});

  final String? hubId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
        ),
        Expanded(
          child: ActivityFeedView(
            hubId: hubId,
            showComposer: true,
            emptyTitle: 'No activities yet',
            emptyMessage: 'Create a post, idea, question, resource, or announcement.',
          ),
        ),
      ],
    );
  }
}
