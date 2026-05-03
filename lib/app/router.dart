import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

import 'package:go_router/go_router.dart';
import '../core/models.dart';
import '../core/app_repository.dart';
import '../features/admin/admin_screen.dart';
import '../features/activities/activities_screen.dart';
import '../features/auth/invite_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/builders/builder_detail_screen.dart';
import '../features/builders/builder_reader_screen.dart';
import '../features/builders/builders_screen.dart';
import '../features/home/home_screen.dart';
import '../features/hub/hub_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/projects/project_detail_screen.dart';
import '../features/projects/projects_screen.dart';
import '../widgets/create_post_sheet.dart';
import 'theme.dart';
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/invite/:token',
      builder: (context, state) => InviteScreen(token: state.pathParameters['token']!),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/activities',
      builder: (context, state) => const ActivitiesScreen(),
    ),
    GoRoute(
      path: '/builder/:builderId',
      builder: (context, state) => BuilderDetailScreen(builderId: state.pathParameters['builderId']!),
    ),
    GoRoute(
      path: '/builder/:builderId/reader',
      builder: (context, state) => BuilderReaderScreen(builderId: state.pathParameters['builderId']!),
    ),
    GoRoute(
      path: '/project/:projectId',
      builder: (context, state) => ProjectDetailScreen(projectId: state.pathParameters['projectId']!),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
  ],
);

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;
  bool _subMenuOpen = false;
  final Map<int, String> _selectedSub = {
    1: 'Activities',
    2: 'Tracks',
    3: 'My Projects',
    4: 'Profile',
  };

  static const _labels = ['Home', 'Hub', 'Builders', 'Projects', 'Profile'];
  static const _icons = [Icons.home_outlined, Icons.groups_2_outlined, Icons.auto_stories_outlined, Icons.workspaces_outlined, Icons.person_outline];

  List<String> _submenuFor(int index) {
    switch (index) {
      case 1:
        return ['Activities', 'Groups', 'Events', 'Members'];
      case 2:
        return ['Tracks', 'In Progress', 'Published', 'Scores'];
      case 3:
        return ['My Projects', 'Joined', 'Explore', 'Drafts'];
      case 4:
        return ['Profile', 'Settings', 'Invites', 'Admin Mode'];
      default:
        return const [];
    }
  }

  Widget _bodyForIndex() {
    final sub = _selectedSub[_index] ?? '';
    switch (_index) {
      case 0:
        return const HomeScreen();
      case 1:
        return HubScreen(section: sub);
      case 2:
        return BuildersScreen(section: sub);
      case 3:
        return ProjectsScreen(section: sub);
      case 4:
        return ProfileScreen(section: sub);
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final submenu = _submenuFor(_index);
    final showMenu = _subMenuOpen && submenu.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const Icon(Icons.hexagon_outlined, size: 24),
            const SizedBox(width: 8),
            const Text('rebelbase', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2)),
            const Spacer(),
            IconButton(
              tooltip: 'Search',
              onPressed: () => showSearch(context: context, delegate: DemoSearchDelegate(ref)),
              icon: const Icon(Icons.search),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () => _showNotifications(context, repo),
                  icon: const Icon(Icons.notifications_none),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        repo.unreleasedScores().length.toString(),
                        style: const TextStyle(color: RbColors.darkShell, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _bodyForIndex(),
      floatingActionButton: _index == 0 || (_index == 1 && (_selectedSub[1] ?? 'Activities') == 'Activities')
          ? FloatingActionButton.extended(
              onPressed: () => showCreatePostSheet(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Post'),
            )
          : null,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: showMenu
                ? Container(
                    key: ValueKey(_index),
                    height: 52,
                    decoration: const BoxDecoration(
                      color: RbColors.darkShell,
                      border: Border(top: BorderSide(color: Colors.white10)),
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: submenu.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final label = submenu[i];
                        final selected = _selectedSub[_index] == label;
                        return ChoiceChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _selectedSub[_index] = label;
                            if (label == 'Admin Mode') {
                              _subMenuOpen = false;
                              if (repo.canOpenAdmin) context.push('/admin');
                            }
                          }),
                          selectedColor: RbColors.accent,
                          labelStyle: TextStyle(color: selected ? Colors.white : Colors.white70, fontWeight: FontWeight.w700),
                          backgroundColor: RbColors.darkNav,
                          side: BorderSide(color: selected ? RbColors.accent : Colors.white12),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Container(
            color: RbColors.darkNav,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 70,
                child: Row(
                  children: List.generate(_labels.length, (i) {
                    final selected = i == _index;
                    final hasMenu = _submenuFor(i).isNotEmpty;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_index == i && hasMenu) {
                              _subMenuOpen = !_subMenuOpen;
                            } else {
                              _index = i;
                              _subMenuOpen = false;
                            }
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (hasMenu)
                              Icon(
                                _index == i && _subMenuOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                size: 16,
                                color: selected ? RbColors.accent : Colors.white54,
                              )
                            else
                              const SizedBox(height: 16),
                            Icon(_icons[i], color: selected ? RbColors.accent : Colors.white70),
                            const SizedBox(height: 2),
                            Text(
                              _labels[i],
                              style: TextStyle(color: selected ? RbColors.accent : Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context, AppRepository repo) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final score in repo.unreleasedScores())
            ListTile(
              leading: const CircleAvatar(backgroundColor: RbColors.paleTeal, child: Icon(Icons.lock_clock, color: RbColors.accent)),
              title: Text('${repo.projectById(score.projectId).name} has an unreleased score'),
              subtitle: Text(score.type == ScoreType.project ? 'Project score pending release' : 'Builder answer score pending release'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                context.push('/admin');
              },
            ),
          if (repo.unreleasedScores().isEmpty)
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Nothing pending'),
              subtitle: Text('You are all caught up.'),
            ),
        ],
      ),
    );
  }
}

class DemoSearchDelegate extends SearchDelegate<String?> {
  DemoSearchDelegate(this.ref);
  final WidgetRef ref;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final repo = ref.watch(appRepositoryProvider);
    final q = query.trim().toLowerCase();
    final projects = repo.projects.where((e) => e.name.toLowerCase().contains(q) || e.description.toLowerCase().contains(q)).toList();
    final users = repo.users.where((e) => e.name.toLowerCase().contains(q) || e.powers.join(' ').toLowerCase().contains(q)).toList();
    final posts = repo.posts.where((e) => e.body.toLowerCase().contains(q)).toList();
    return ListView(
      children: [
        if (q.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Search people, projects, and activities.'),
          ),
        if (projects.isNotEmpty) const ListTile(title: Text('Projects')),
        for (final p in projects)
          ListTile(
            leading: const Icon(Icons.workspaces_outlined),
            title: Text(p.name),
            subtitle: Text(p.tagline),
            onTap: () {
              close(context, null);
              context.push('/project/${p.id}');
            },
          ),
        if (users.isNotEmpty) const ListTile(title: Text('People')),
        for (final u in users)
          ListTile(
            leading: CircleAvatar(child: Text(u.name[0])),
            title: Text(u.name),
            subtitle: Text(u.powers.join(', ')),
          ),
        if (posts.isNotEmpty) const ListTile(title: Text('Activities')),
        for (final p in posts)
          ListTile(
            leading: Icon(p.type.icon, color: p.type.color),
            title: Text(p.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(p.type.label),
          ),
      ],
    );
  }
}
