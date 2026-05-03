import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';

class InviteScreen extends ConsumerWidget {
  const InviteScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final invite = repo.invites.where((item) => item.token == token).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Link')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(invite == null ? Icons.error_outline : Icons.mark_email_read_outlined, color: invite == null ? RbColors.danger : RbColors.accent, size: 46),
                const SizedBox(height: 14),
                Text(invite == null ? 'Invalid invite' : invite.roleLabel, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(invite == null ? 'No matching demo invite was found.' : invite.scopeLabel),
                const SizedBox(height: 8),
                Text('Token: $token', style: const TextStyle(color: RbColors.muted)),
                const SizedBox(height: 16),
                FilledButton(onPressed: invite == null ? null : () => context.go('/'), child: const Text('Accept invite')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
