import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../app/theme.dart';
import '../core/app_repository.dart';
import '../core/models.dart';
import 'common_widgets.dart';

Future<void> showCreatePostSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const CreatePostSheet(),
  );
}

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  final _controller = TextEditingController();
  PostType _type = PostType.post;
  String? _imagePath;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create activity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PostType.values.map((type) {
                return ChoiceChip(
                  selected: _type == type,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(type.icon, size: 16, color: _type == type ? Colors.white : type.color), const SizedBox(width: 4), Text(type.label)],
                  ),
                  selectedColor: type.color,
                  labelStyle: TextStyle(color: _type == type ? Colors.white : RbColors.text, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _type = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: _hintForType(_type),
              ),
            ),
            const SizedBox(height: 12),
            if (_imagePath != null) ...[
              RbLocalImage(path: _imagePath!, height: 170),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Add image'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    repo.addPost(
                            type: _type,
                            body: _controller.text,
                            hubId: repo.activeHubId,
                            projectId: repo.activeProjectId,
                            imagePath: _imagePath,
                          );
                          Navigator.pop(context);
                        },
                  icon: const Icon(Icons.send),
                  label: const Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _hintForType(PostType type) => switch (type) {
        PostType.post => 'Share an update with your hub...',
        PostType.idea => 'Describe the idea you want others to react to...',
        PostType.question => 'Ask a clear question...',
        PostType.resource => 'Share a resource, link, or useful note...',
        PostType.announcement => 'Write an announcement for the hub...',
      };
}
