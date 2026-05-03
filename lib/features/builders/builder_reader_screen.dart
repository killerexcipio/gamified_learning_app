import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme.dart';
import '../../core/app_repository.dart';
import '../../widgets/common_widgets.dart';

class BuilderReaderScreen extends ConsumerWidget {
  const BuilderReaderScreen({super.key, required this.builderId});

  final String builderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(appRepositoryProvider);
    final builder = repo.builderById(builderId);
    final lessons = repo.lessonsForBuilder(builderId);
    final completed = repo.completedLessons(repo.activeProjectId, builderId, repo.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(builder.title),
        actions: [
          IconButton(
            tooltip: 'Table of contents',
            onPressed: () => _showToc(context, repo, lessons),
            icon: const Icon(Icons.list_alt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 130),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            decoration: const BoxDecoration(color: RbColors.darkShell),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(repo.activeProject.name, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(builder.title.toUpperCase(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                ProgressDots(completed: completed.length, total: lessons.length, size: 10),
              ],
            ),
          ),
          if (lessons.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'This Builder does not have lesson content yet. You can still write and publish an answer. Admins can add lessons from Admin Mode.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            for (final lesson in lessons)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(completed.contains(lesson.id) ? Icons.check_circle : Icons.radio_button_unchecked, color: completed.contains(lesson.id) ? RbColors.accent : RbColors.muted),
                          const SizedBox(width: 8),
                          Expanded(child: Text(lesson.title, style: Theme.of(context).textTheme.titleMedium)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(lesson.body, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: completed.contains(lesson.id) ? null : () => repo.markLessonComplete(repo.activeProjectId, builderId, lesson.id),
                          icon: const Icon(Icons.done),
                          label: Text(completed.contains(lesson.id) ? 'Completed' : 'Got it'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Answer prompt', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(builder.answerPrompt, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => _showAnswerEditor(context, ref, builderId),
                    icon: const Icon(Icons.edit),
                    label: const Text('Write / Edit Answer'),
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Builder'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showAnswerEditor(context, ref, builderId),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Skip to Answer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToc(BuildContext context, AppRepository repo, List lessons) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text('Table of contents', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final lesson in lessons)
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(lesson.title),
              subtitle: Text(repo.topicById(lesson.topicId).title),
            ),
        ],
      ),
    );
  }

  void _showAnswerEditor(BuildContext context, WidgetRef ref, String builderId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _AnswerEditor(builderId: builderId),
    );
  }
}

class _AnswerEditor extends ConsumerStatefulWidget {
  const _AnswerEditor({required this.builderId});

  final String builderId;

  @override
  ConsumerState<_AnswerEditor> createState() => _AnswerEditorState();
}

class _AnswerEditorState extends ConsumerState<_AnswerEditor> {
  late final TextEditingController _controller;
  late List<String> _imagePaths;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(appRepositoryProvider);
    final answer = repo.answerFor(repo.activeProjectId, widget.builderId);
    _controller = TextEditingController(text: answer?.answerText ?? '');
    _imagePaths = [...(answer?.imagePaths ?? const [])];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) setState(() => _imagePaths.add(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final builder = repo.builderById(widget.builderId);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Answer: ${builder.title}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(builder.answerPrompt, style: const TextStyle(color: RbColors.muted)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 8,
              maxLines: 14,
              decoration: const InputDecoration(hintText: 'Write the shared project answer here...'),
            ),
            const SizedBox(height: 12),
            if (_imagePaths.isNotEmpty)
              SizedBox(
                height: 104,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagePaths.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => Stack(
                    children: [
                      SizedBox(width: 120, child: RbLocalImage(path: _imagePaths[index], height: 104, borderRadius: 12)),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            color: Colors.white,
                            onPressed: () => setState(() => _imagePaths.removeAt(index)),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image_outlined), label: const Text('Add image')),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    repo.saveAnswer(projectId: repo.activeProjectId, builderId: widget.builderId, answerText: _controller.text, imagePaths: _imagePaths);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved locally.')));
                  },
                  child: const Text('Save draft'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    repo.saveAnswer(projectId: repo.activeProjectId, builderId: widget.builderId, answerText: _controller.text, imagePaths: _imagePaths);
                    repo.publishAnswer(repo.activeProjectId, widget.builderId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Published to Project Page.')));
                  },
                  icon: const Icon(Icons.publish),
                  label: const Text('Publish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
