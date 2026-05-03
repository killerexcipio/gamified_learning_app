import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/theme.dart';
import '../core/models.dart';

class RbSectionHeader extends StatelessWidget {
  const RbSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class RbRoleChip extends StatelessWidget {
  const RbRoleChip({super.key, required this.label, this.color = RbColors.accent});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 22});

  final AppUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initials = user.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0].toUpperCase())
        .join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: RbColors.darkShell,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProgressDots extends StatelessWidget {
  const ProgressDots({super.key, required this.completed, required this.total, this.size = 12});

  final int completed;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    final displayTotal = total == 0 ? 1 : total;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(displayTotal, (index) {
        final done = total == 0 ? completed > 0 : index < completed;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? RbColors.accent : Colors.transparent,
            border: Border.all(
              color: done ? RbColors.accent : Colors.grey.shade500,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class PostTypeBadge extends StatelessWidget {
  const PostTypeBadge({super.key, required this.type});

  final PostType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 14, color: type.color),
          const SizedBox(width: 4),
          Text(
            type.label.toUpperCase(),
            style: TextStyle(color: type.color, fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class RbLocalImage extends StatelessWidget {
  const RbLocalImage({super.key, required this.path, this.height = 180, this.borderRadius = 14});

  final String path;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = path.startsWith('http')
        ? Image.network(path, fit: BoxFit.cover, width: double.infinity, height: height)
        : Image.file(File(path), fit: BoxFit.cover, width: double.infinity, height: height);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }
}

String compactDate(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 30) return '${diff.inDays}d';
  return DateFormat('MMM d').format(date);
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: RbColors.muted),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: RbColors.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
