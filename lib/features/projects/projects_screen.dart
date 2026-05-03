import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../core/models.dart';
import '../../widgets/common_widgets.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final projects = switch (section) {
      'Explore' => repo.projectsForHub(repo.activeHubId),
      'Drafts' => repo.projectsForCurrentUser().where((p) => repo.publishedAnswersForProject(p.id).isEmpty).toList(),
      'Joined' => repo.projects.where((p) => p.memberIds.contains(repo.currentUserId)).toList(),
      _ => repo.projectsForCurrentUser(),
    };
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: const BoxDecoration(color: RbColors.darkShell),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Projects', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    Text(section.isEmpty ? 'My Projects' : section, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showCreateProject(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('New'),
              ),
            ],
          ),
        ),
        for (final project in projects) ProjectCard(project: project),
        if (projects.isEmpty) const EmptyState(icon: Icons.workspaces_outline, title: 'No projects', message: 'Create or join a project to get started.'),
      ],
    );
  }

  void _showCreateProject(BuildContext context, WidgetRef ref) {
    final name = TextEditingController();
    final tagline = TextEditingController();
    final description = TextEditingController();
    final category = TextEditingController(text: 'Innovation');
    final location = TextEditingController(text: 'Dhaka, Bangladesh');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final bottom = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create project', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Project name')),
                const SizedBox(height: 10),
                TextField(controller: tagline, decoration: const InputDecoration(labelText: 'Tagline')),
                const SizedBox(height: 10),
                TextField(controller: description, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 10),
                TextField(controller: category, decoration: const InputDecoration(labelText: 'Category')),
                const SizedBox(height: 10),
                TextField(controller: location, decoration: const InputDecoration(labelText: 'Location')),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    if (name.text.trim().isEmpty) return;
                    ref.read(appRepositoryProvider).createProject(
                          name: name.text,
                          tagline: tagline.text,
                          description: description.text,
                          category: category.text,
                          location: location.text,
                        );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create project'),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      name.dispose();
      tagline.dispose();
      description.dispose();
      category.dispose();
      location.dispose();
    });
  }
}

class ProjectCard extends ConsumerWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final publishedCount = repo.publishedAnswersForProject(project.id).length;
    final isMine = project.memberIds.contains(repo.currentUserId) || project.ownerId == repo.currentUserId;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          repo.setActiveProject(project.id);
          context.push('/project/${project.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(color: RbColors.paleTeal, borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text(project.name[0], style: const TextStyle(color: RbColors.accent, fontWeight: FontWeight.w900, fontSize: 24))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.name, style: Theme.of(context).textTheme.titleMedium),
                        Text(project.tagline, style: const TextStyle(color: RbColors.muted)),
                      ],
                    ),
                  ),
                  if (isMine) const RbRoleChip(label: 'Member'),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.place_outlined, color: RbColors.accent, size: 20),
                  const SizedBox(width: 6),
                  Expanded(child: Text(project.location)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category_outlined, color: RbColors.accent, size: 20),
                  const SizedBox(width: 6),
                  Expanded(child: Text(project.category)),
                ],
              ),
              const SizedBox(height: 12),
              Text('$publishedCount Builder answers published', style: const TextStyle(color: RbColors.muted, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
