import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';


final appRepositoryProvider = ChangeNotifierProvider<AppRepository>((ref) {
  throw UnimplementedError('AppRepository is overridden in main.dart');
});

class AppRepository extends ChangeNotifier {
  AppRepository({required this.cache, required this.supabaseEnabled});

  final Box<dynamic> cache;
  final bool supabaseEnabled;
  final _uuid = const Uuid();

  String currentUserId = 'u_rezaur';
  String activeHubId = 'hub_bracu';
  String activeProjectId = 'project_sol';
  int pendingSyncCount = 0;

  late final List<Institution> institutions;
  late final List<Hub> hubs;
  late final List<DemoGroup> groups;
  late final List<DemoEvent> events;
  late final List<AppUser> users;
  late List<Project> projects;
  late final List<BuilderTrack> tracks;
  late final List<BuilderTopic> topics;
  late final List<BuilderLesson> lessons;
  late List<BuilderModule> builders;
  late List<ActivityPost> posts;
  late List<ActivityComment> comments;
  late List<BuilderAnswer> answers;
  late List<ScoreRecord> scores;
  late final List<InviteLink> invites;
  late Map<String, List<String>> completedLessonIds;

  Future<void> load() async {
    _seedStableData();
    projects = _readList('projects', Project.fromJson, projects);
    builders = _readList('builders', BuilderModule.fromJson, _seedBuilders());
    posts = _readList('posts', ActivityPost.fromJson, _seedPosts());
    comments = _readList('comments', ActivityComment.fromJson, _seedComments());
    answers = _readList('answers', BuilderAnswer.fromJson, _seedAnswers());
    scores = _readList('scores', ScoreRecord.fromJson, _seedScores());
    completedLessonIds = _readProgress();
    pendingSyncCount = (cache.get('pendingSyncCount') as int?) ?? 0;
  }

  void _seedStableData() {
    institutions = [
      Institution(
        id: 'inst_bracu',
        name: 'BRACU',
        slug: 'bracu',
        description: 'Demo university tenant for innovation cohorts.',
      ),
      Institution(
        id: 'inst_sol',
        name: 'SOL Institute',
        slug: 'sol-institute',
        description: 'A second tenant used to demonstrate multi-institution managers.',
      ),
    ];

    hubs = [
      Hub(
        id: 'hub_bracu',
        institutionId: 'inst_bracu',
        name: 'BRACU',
        description: 'Main BRACU hub for activities, members, projects, and builders.',
      ),
      Hub(
        id: 'hub_sol',
        institutionId: 'inst_sol',
        name: 'SOL Happiness Index',
        description: 'Cohort hub for the SOL Happiness Index project group.',
      ),
      Hub(
        id: 'hub_builders',
        institutionId: 'inst_bracu',
        name: 'Innovation Builders Cohort',
        description: 'Cohort assigned to the Innovation Foundations learning path.',
      ),
    ];

    users = [
      AppUser(
        id: 'u_rezaur',
        name: 'Md. Rezaur Rahman',
        email: 'rezaur@example.com',
        roles: const [UserRole.student, UserRole.institutionManager, UserRole.admin],
        bio: 'Project owner and demo administrator.',
        powers: const ['Leadership', 'Research', 'Operations'],
      ),
      AppUser(
        id: 'u_rafsan',
        name: 'Rafsan Monsur',
        email: 'rafsan@example.com',
        roles: const [UserRole.student],
        powers: const ['Marketing', 'Communication'],
      ),
      AppUser(
        id: 'u_rehnuma',
        name: 'Rehnuma Majba',
        email: 'rehnuma@example.com',
        roles: const [UserRole.student],
        powers: const ['Critical Thinking', 'Design'],
      ),
      AppUser(
        id: 'u_sameer',
        name: 'Md. Sameer Sakib',
        email: 'sameer@example.com',
        roles: const [UserRole.student],
        powers: const ['Analytics', 'Writing'],
      ),
      AppUser(
        id: 'u_faculty',
        name: 'Dr. Ayesha Karim',
        email: 'faculty@example.com',
        roles: const [UserRole.faculty],
        powers: const ['Scoring', 'Mentorship'],
      ),
      AppUser(
        id: 'u_manager',
        name: 'Institution Manager Demo',
        email: 'manager@example.com',
        roles: const [UserRole.institutionManager],
        powers: const ['Program Management'],
      ),
      AppUser(
        id: 'u_admin',
        name: 'Super Admin Demo',
        email: 'admin@example.com',
        roles: const [UserRole.admin],
        powers: const ['Tenant Setup', 'Builder CMS'],
      ),
      AppUser(
        id: 'u_alexa',
        name: 'Alexa Creavey',
        email: 'alexa@example.com',
        roles: const [UserRole.student],
        powers: const ['Marketing', 'Collaboration', 'Compassion'],
      ),
      AppUser(
        id: 'u_adil',
        name: 'Adil Usubaliev',
        email: 'adil@example.com',
        roles: const [UserRole.student],
        powers: const ['Research'],
      ),
      AppUser(
        id: 'u_abdul',
        name: 'Abdul Basir Nasiri',
        email: 'abdul@example.com',
        roles: const [UserRole.student],
        powers: const ['Support'],
      ),
    ];

    projects = [
      Project(
        id: 'project_sol',
        institutionId: 'inst_bracu',
        hubId: 'hub_bracu',
        name: 'SOL Happiness Index',
        tagline: 'Making workplace wellbeing visible and actionable.',
        description:
            'A tool for Bangladeshi workplaces to measure employee happiness, psychological safety, and organizational empathy.',
        category: 'Energy / Social Impact',
        location: 'Dhaka, Bangladesh',
        ownerId: 'u_rezaur',
        memberIds: const ['u_rezaur', 'u_rafsan', 'u_rehnuma', 'u_sameer'],
      ),
      Project(
        id: 'project_facepet',
        institutionId: 'inst_bracu',
        hubId: 'hub_bracu',
        name: 'FacePet',
        tagline: 'Smart pet matching for urban animal services.',
        description: 'A playful animal services idea inspired by social discovery.',
        category: 'Animal Services',
        location: 'New York, NY, USA',
        ownerId: 'u_alexa',
        memberIds: const ['u_alexa'],
      ),
      Project(
        id: 'project_music',
        institutionId: 'inst_bracu',
        hubId: 'hub_bracu',
        name: 'The Music Note',
        tagline: 'Music education made collaborative.',
        description: 'A concept for music learning communities.',
        category: 'Education',
        location: 'New Haven, CT, USA',
        ownerId: 'u_adil',
        memberIds: const ['u_adil', 'u_abdul'],
      ),
    ];

    tracks = [
      BuilderTrack(
        id: 'track_ideation',
        title: 'Ideation',
        description: 'Define the need, solution, and team.',
        builderIds: const ['builder_problem', 'builder_solution', 'builder_team', 'builder_role'],
      ),
      BuilderTrack(
        id: 'track_validation',
        title: 'Validation',
        description: 'Validate customers, ecosystem, prototype, and competitors.',
        builderIds: const ['builder_target_market', 'builder_prototesting', 'builder_ecosystem', 'builder_competitive'],
      ),
      BuilderTrack(
        id: 'track_business_case',
        title: 'Business Case',
        description: 'Explain why the project matters and how it can grow.',
        builderIds: const ['builder_why', 'builder_leadership'],
      ),
    ];

    topics = [
      BuilderTopic(
        id: 'topic_tm_intro',
        builderId: 'builder_target_market',
        title: 'Intro to Target Market',
        description: 'Learn what a target market is and why it matters.',
        lessonIds: const ['lesson_tm_intro_1', 'lesson_tm_intro_2', 'lesson_tm_intro_3'],
      ),
      BuilderTopic(
        id: 'topic_tm_segments',
        builderId: 'builder_target_market',
        title: 'Target Market',
        description: 'Name the segments and decide who adopts first.',
        lessonIds: const ['lesson_tm_segments_1', 'lesson_tm_segments_2', 'lesson_tm_segments_3'],
      ),
      BuilderTopic(
        id: 'topic_tm_category',
        builderId: 'builder_target_market',
        title: 'Market Category',
        description: 'Name the category and describe your role in it.',
        lessonIds: const ['lesson_tm_category_1', 'lesson_tm_category_2'],
      ),
      BuilderTopic(
        id: 'topic_problem',
        builderId: 'builder_problem',
        title: 'Problem Discovery',
        description: 'Clarify the need your project will meet.',
        lessonIds: const ['lesson_problem_1', 'lesson_problem_2', 'lesson_problem_3'],
      ),
      BuilderTopic(
        id: 'topic_solution',
        builderId: 'builder_solution',
        title: 'Solution Design',
        description: 'Describe what you will make to meet the need.',
        lessonIds: const ['lesson_solution_1', 'lesson_solution_2', 'lesson_solution_3'],
      ),
      BuilderTopic(
        id: 'topic_team',
        builderId: 'builder_team',
        title: 'Core Team',
        description: 'Identify team roles and collaboration needs.',
        lessonIds: const ['lesson_team_1', 'lesson_team_2'],
      ),
      BuilderTopic(
        id: 'topic_why',
        builderId: 'builder_why',
        title: 'Why Statement',
        description: 'Explain why your project deserves to exist.',
        lessonIds: const ['lesson_why_1', 'lesson_why_2'],
      ),
    ];

    lessons = [
      BuilderLesson(
        id: 'lesson_tm_intro_1',
        topicId: 'topic_tm_intro',
        title: 'What is a target market?',
        body:
            'A target market is a collection of people or organizations that share a common need your solution can meet. Early venture work becomes stronger when you identify a reachable first audience instead of trying to serve everyone.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_tm_intro_2',
        topicId: 'topic_tm_intro',
        title: 'Users vs customers',
        body:
            'Users experience the solution. Customers pay for it or approve buying it. In many institutional or B2B contexts, these are different people, so your answer should show both groups when relevant.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_tm_intro_3',
        topicId: 'topic_tm_intro',
        title: 'First adopters',
        body:
            'The best first adopters feel the problem strongly, can access your solution, and are willing to give feedback. Your first market is often narrower than your long-term market.',
        sortOrder: 3,
      ),
      BuilderLesson(
        id: 'lesson_tm_segments_1',
        topicId: 'topic_tm_segments',
        title: 'Segmenting your audience',
        body:
            'Segment by behavior, context, urgency, budget, role, geography, or institutional environment. Useful segments help you decide what to build next and who to interview first.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_tm_segments_2',
        topicId: 'topic_tm_segments',
        title: 'Interview map',
        body:
            'List five representative people or organizations. For each, write what problem they face, where you can reach them, and what evidence would prove interest.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_tm_segments_3',
        topicId: 'topic_tm_segments',
        title: 'Prioritizing early segments',
        body:
            'Choose your first segment by combining pain intensity, reachability, willingness to try, and strategic value. Your answer should justify why this segment is first.',
        sortOrder: 3,
      ),
      BuilderLesson(
        id: 'lesson_tm_category_1',
        topicId: 'topic_tm_category',
        title: 'Name the market category',
        body: 'A market category helps others understand what kind of solution you are building and what alternatives they should compare it with.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_tm_category_2',
        topicId: 'topic_tm_category',
        title: 'Describe your role',
        body: 'Your role in the market can be tool provider, service provider, data layer, community, marketplace, or learning platform. Pick the description that makes your project easiest to understand.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_problem_1',
        topicId: 'topic_problem',
        title: 'Need statement',
        body: 'Write the human need in plain language. Avoid naming your solution too early. A strong problem statement makes the pain, audience, and current workaround clear.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_problem_2',
        topicId: 'topic_problem',
        title: 'Evidence of pain',
        body: 'Use interviews, observations, complaints, failed workarounds, or data. Evidence keeps the project grounded.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_problem_3',
        topicId: 'topic_problem',
        title: 'Scope boundaries',
        body: 'Clarify what you are not solving yet. Boundaries make the first version buildable.',
        sortOrder: 3,
      ),
      BuilderLesson(
        id: 'lesson_solution_1',
        topicId: 'topic_solution',
        title: 'Solution concept',
        body: 'Describe the object, service, app, campaign, or system you will create. Focus on the smallest version that can prove value.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_solution_2',
        topicId: 'topic_solution',
        title: 'Value promise',
        body: 'State what changes for the user after using the solution. Use a before-and-after frame.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_solution_3',
        topicId: 'topic_solution',
        title: 'Proof plan',
        body: 'Name what test would show the solution is useful. This can be a prototype test, sign-up test, pilot, or interview.',
        sortOrder: 3,
      ),
      BuilderLesson(
        id: 'lesson_team_1',
        topicId: 'topic_team',
        title: 'Roles and responsibilities',
        body: 'Assign clear roles so the project does not depend on vague enthusiasm. Every member should know what they own.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_team_2',
        topicId: 'topic_team',
        title: 'Collaboration rhythm',
        body: 'Decide how the team will meet, make decisions, document work, and resolve disagreements.',
        sortOrder: 2,
      ),
      BuilderLesson(
        id: 'lesson_why_1',
        topicId: 'topic_why',
        title: 'Purpose of the project',
        body: 'A why statement connects the problem to a larger reason for action. It should be specific enough to guide decisions.',
        sortOrder: 1,
      ),
      BuilderLesson(
        id: 'lesson_why_2',
        topicId: 'topic_why',
        title: 'Stakeholder value',
        body: 'Explain who benefits and why that benefit matters. Good project pages make the audience care quickly.',
        sortOrder: 2,
      ),
    ];

    groups = [
      DemoGroup(
        id: 'group_lsc',
        hubId: 'hub_bracu',
        name: 'Leading Sustainable Change',
        status: 'active',
        projectIds: const ['project_sol', 'project_facepet', 'project_music'],
        memberIds: users.map((e) => e.id).take(8).toList(),
        managerIds: const ['u_manager', 'u_faculty'],
      ),
      DemoGroup(
        id: 'group_founders',
        hubId: 'hub_builders',
        name: 'Innovation Founders Sprint',
        status: 'active',
        projectIds: const ['project_sol'],
        memberIds: const ['u_rezaur', 'u_rafsan', 'u_rehnuma', 'u_sameer'],
        managerIds: const ['u_faculty'],
      ),
    ];

    events = [
      DemoEvent(
        id: 'event_demo_day',
        hubId: 'hub_bracu',
        title: 'Builder Demo Day',
        description: 'Teams present their published project pages and receive faculty scoring.',
        startsAt: DateTime.now().add(const Duration(days: 10)),
      ),
      DemoEvent(
        id: 'event_target_market_workshop',
        hubId: 'hub_bracu',
        title: 'Target Market Workshop',
        description: 'A hands-on session for customer segment discovery.',
        startsAt: DateTime.now().add(const Duration(days: 3)),
      ),
    ];

    invites = [
      InviteLink(id: 'inv1', token: 'mgr-multi-8KQ2-BRACU-SOL', roleLabel: 'Institution Manager', scopeLabel: 'Multi-institution manager', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv2', token: 'mgr-bracu-4XP9-DEMO', roleLabel: 'Institution Manager', scopeLabel: 'BRACU only', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv3', token: 'fac-bracu-H7LM-DEMO', roleLabel: 'Faculty', scopeLabel: 'BRACU hub faculty', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv4', token: 'fac-solscore-P2VA-DEMO', roleLabel: 'Faculty', scopeLabel: 'SOL Happiness Index reviewer', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv5', token: 'stu-bracu-A1F9-DEMO', roleLabel: 'Student', scopeLabel: 'BRACU hub student', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv6', token: 'stu-bracu-B2G8-DEMO', roleLabel: 'Student', scopeLabel: 'BRACU hub student', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv7', token: 'stu-sol-C3H7-DEMO', roleLabel: 'Student', scopeLabel: 'SOL Happiness Index cohort', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv8', token: 'stu-sol-D4J6-DEMO', roleLabel: 'Student', scopeLabel: 'SOL Happiness Index cohort', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv9', token: 'stu-builders-E5K5-DEMO', roleLabel: 'Student', scopeLabel: 'Innovation Builders cohort', maxUses: 1, usedCount: 0),
      InviteLink(id: 'inv10', token: 'stu-builders-F6L4-DEMO', roleLabel: 'Student', scopeLabel: 'Innovation Builders cohort', maxUses: 1, usedCount: 0),
    ];
  }

  List<BuilderModule> _seedBuilders() => [
        BuilderModule(
          id: 'builder_problem',
          trackId: 'track_ideation',
          title: 'Problem',
          description: 'What need will you meet?',
          answerPrompt: 'What problem are you solving, who feels it, and what evidence shows it matters?',
          topicIds: const ['topic_problem'],
        ),
        BuilderModule(
          id: 'builder_solution',
          trackId: 'track_ideation',
          title: 'Solution',
          description: 'What will you make to meet the need?',
          answerPrompt: 'Describe your proposed solution and the smallest useful version you can test.',
          topicIds: const ['topic_solution'],
        ),
        BuilderModule(
          id: 'builder_team',
          trackId: 'track_ideation',
          title: 'Core Team',
          description: 'Who will you work with and how will you collaborate?',
          answerPrompt: 'Who is on your core team, what do they own, and how will you collaborate?',
          topicIds: const ['topic_team'],
        ),
        BuilderModule(
          id: 'builder_role',
          trackId: 'track_ideation',
          title: 'Organization Role',
          description: 'What role will your organization play?',
          answerPrompt: 'What role does your organization play in making this solution possible?',
          topicIds: const [],
        ),
        BuilderModule(
          id: 'builder_target_market',
          trackId: 'track_validation',
          title: 'Target and Market',
          description: 'Who is your solution for and where would you sell it?',
          answerPrompt: 'Who are you targeting with your solution? Who are the segments and which would adopt your solution first?',
          topicIds: const ['topic_tm_intro', 'topic_tm_segments', 'topic_tm_category'],
        ),
        BuilderModule(
          id: 'builder_prototesting',
          trackId: 'track_validation',
          title: 'Prototesting',
          description: 'How can you demo, test, and improve your solution?',
          answerPrompt: 'What prototype will you test and what feedback will prove whether it works?',
          topicIds: const [],
        ),
        BuilderModule(
          id: 'builder_ecosystem',
          trackId: 'track_validation',
          title: 'Ecosystem',
          description: 'What do you need access to and who can help?',
          answerPrompt: 'Who must help, approve, fund, distribute, or support your solution?',
          topicIds: const [],
        ),
        BuilderModule(
          id: 'builder_competitive',
          trackId: 'track_validation',
          title: 'Competitive Landscape',
          description: 'Who are your competitors and how do you set yourself apart?',
          answerPrompt: 'What alternatives exist, and why would your target segment choose your solution?',
          topicIds: const [],
        ),
        BuilderModule(
          id: 'builder_why',
          trackId: 'track_business_case',
          title: 'Why Statement',
          description: 'Why does the project matter?',
          answerPrompt: 'Write the purpose of your project and why the audience should care.',
          topicIds: const ['topic_why'],
        ),
        BuilderModule(
          id: 'builder_leadership',
          trackId: 'track_business_case',
          title: 'Leading, Leaders, and Leadership',
          description: 'How will leadership support the work?',
          answerPrompt: 'Describe the leadership traits and operating rhythm needed for the project to succeed.',
          topicIds: const [],
        ),
      ];

  List<ActivityPost> _seedPosts() {
    final now = DateTime.now();
    return [
      ActivityPost(
        id: 'post_1',
        hubId: 'hub_bracu',
        projectId: 'project_sol',
        authorId: 'u_rafsan',
        type: PostType.idea,
        body: 'What if the Happiness Index also captured anonymous micro-feedback after team meetings? It may reveal stress patterns earlier than monthly surveys.',
        createdAt: now.subtract(const Duration(hours: 3)),
        kudosUserIds: const ['u_rezaur', 'u_sameer'],
      ),
      ActivityPost(
        id: 'post_2',
        hubId: 'hub_bracu',
        authorId: 'u_faculty',
        type: PostType.announcement,
        body: 'Reminder: publish at least one Builder answer before the Target Market Workshop. Faculty scoring will be released after review.',
        createdAt: now.subtract(const Duration(days: 1)),
        kudosUserIds: const ['u_rezaur', 'u_rafsan', 'u_rehnuma'],
      ),
      ActivityPost(
        id: 'post_3',
        hubId: 'hub_bracu',
        projectId: 'project_music',
        authorId: 'u_adil',
        type: PostType.question,
        body: 'For early validation, should we interview music teachers first or students who are learning independently?',
        createdAt: now.subtract(const Duration(days: 2)),
        kudosUserIds: const ['u_alexa'],
      ),
      ActivityPost(
        id: 'post_4',
        hubId: 'hub_bracu',
        authorId: 'u_alexa',
        type: PostType.resource,
        body: 'Useful resource for segment interviews: build a small script with pain, frequency, workaround, and willingness-to-try questions.',
        createdAt: now.subtract(const Duration(days: 4)),
        kudosUserIds: const ['u_rezaur', 'u_rafsan', 'u_adil'],
      ),
    ];
  }

  List<ActivityComment> _seedComments() => [
        ActivityComment(
          id: 'comment_1',
          postId: 'post_1',
          authorId: 'u_rezaur',
          body: 'This could become one of our key differentiators. I will add it to the project notes.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

  List<BuilderAnswer> _seedAnswers() {
    final now = DateTime.now();
    return [
      BuilderAnswer(
        id: 'answer_why_sol',
        projectId: 'project_sol',
        builderId: 'builder_why',
        answerText:
            'To sustainably empower company-people communities, we must ensure the people behind the project are mentally resilient and animated. Without a systematic measurement of workplace satisfaction, risks like burnout and disengagement reduce efficiency. A culture aimed at empathetic work-life balance and synergy, where every employee experience is valued, is imperative for efficient innovation and scalability.',
        status: AnswerStatus.published,
        createdBy: 'u_rezaur',
        updatedBy: 'u_rezaur',
        publishedBy: 'u_rezaur',
        publishedAt: now.subtract(const Duration(days: 2)),
        versionNumber: 1,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      BuilderAnswer(
        id: 'answer_leadership_sol',
        projectId: 'project_sol',
        builderId: 'builder_leadership',
        answerText:
            'The strongest leadership trait for this project is empathic harmonization. The team should feel supported and heard. When things get stressful, the leadership rhythm must focus on keeping morale up, making decisions together, and ensuring no voice gets left out.',
        status: AnswerStatus.published,
        createdBy: 'u_rezaur',
        updatedBy: 'u_sameer',
        publishedBy: 'u_sameer',
        publishedAt: now.subtract(const Duration(days: 1)),
        versionNumber: 2,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<ScoreRecord> _seedScores() {
    final now = DateTime.now();
    return [
      ScoreRecord(
        id: 'score_answer_why',
        type: ScoreType.builderAnswer,
        projectId: 'project_sol',
        answerId: 'answer_why_sol',
        builderId: 'builder_why',
        scoredBy: 'u_faculty',
        score: 8.5,
        feedback: 'Strong purpose and context. Add one measurable outcome for the first pilot.',
        status: ScoreStatus.submitted,
        isReleased: false,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      ScoreRecord(
        id: 'score_project_sol',
        type: ScoreType.project,
        projectId: 'project_sol',
        scoredBy: 'u_faculty',
        score: 8.0,
        feedback: 'Project is coherent and socially valuable. Validation evidence should be stronger before Demo Day.',
        status: ScoreStatus.submitted,
        isReleased: false,
        createdAt: now.subtract(const Duration(hours: 10)),
        updatedAt: now.subtract(const Duration(hours: 10)),
      ),
    ];
  }

  List<T> _readList<T>(String key, T Function(Map<String, dynamic>) fromJson, List<T> seed) {
    final raw = cache.get(key) as String?;
    if (raw == null) return seed;
    try {
      final items = jsonDecode(raw) as List<dynamic>;
      return items.map((e) => fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return seed;
    }
  }

  Map<String, List<String>> _readProgress() {
    final raw = cache.get('completedLessonIds') as String?;
    if (raw == null) {
      return {
        _progressKey('project_sol', 'builder_problem', 'u_rezaur'): ['lesson_problem_1', 'lesson_problem_2', 'lesson_problem_3'],
        _progressKey('project_sol', 'builder_solution', 'u_rezaur'): ['lesson_solution_1', 'lesson_solution_2', 'lesson_solution_3'],
        _progressKey('project_sol', 'builder_team', 'u_rezaur'): ['lesson_team_1', 'lesson_team_2'],
      };
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as List).map((e) => e.toString()).toList()));
    } catch (_) {
      return {};
    }
  }

  void _persist() {
    cache.put('projects', jsonEncode(projects.map((e) => e.toJson()).toList()));
    cache.put('builders', jsonEncode(builders.map((e) => e.toJson()).toList()));
    cache.put('posts', jsonEncode(posts.map((e) => e.toJson()).toList()));
    cache.put('comments', jsonEncode(comments.map((e) => e.toJson()).toList()));
    cache.put('answers', jsonEncode(answers.map((e) => e.toJson()).toList()));
    cache.put('scores', jsonEncode(scores.map((e) => e.toJson()).toList()));
    cache.put('completedLessonIds', jsonEncode(completedLessonIds));
    cache.put('pendingSyncCount', pendingSyncCount);
  }

  void _markPendingSync() {
    pendingSyncCount += 1;
    _persist();
  }

  AppUser get currentUser => userById(currentUserId);
  Hub get activeHub => hubs.firstWhere((e) => e.id == activeHubId);
  Project get activeProject => projects.firstWhere((e) => e.id == activeProjectId);

  bool get canOpenAdmin => currentUser.roles.any((r) => r == UserRole.admin || r == UserRole.institutionManager || r == UserRole.faculty);

  AppUser userById(String id) => users.firstWhere((e) => e.id == id, orElse: () => users.first);
  Project projectById(String id) => projects.firstWhere((e) => e.id == id);
  Hub hubById(String id) => hubs.firstWhere((e) => e.id == id, orElse: () => activeHub);
  BuilderModule builderById(String id) => builders.firstWhere((e) => e.id == id);
  BuilderTrack trackById(String id) => tracks.firstWhere((e) => e.id == id);
  BuilderTopic topicById(String id) => topics.firstWhere((e) => e.id == id);

  List<BuilderTopic> topicsForBuilder(String builderId) {
    final builder = builderById(builderId);
    return builder.topicIds.map(topicById).toList();
  }

  List<BuilderLesson> lessonsForTopic(String topicId) {
    final topic = topicById(topicId);
    final items = lessons.where((e) => topic.lessonIds.contains(e.id)).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  List<BuilderLesson> lessonsForBuilder(String builderId) {
    final result = <BuilderLesson>[];
    for (final topic in topicsForBuilder(builderId)) {
      result.addAll(lessonsForTopic(topic.id));
    }
    return result;
  }

  List<ActivityPost> postsForHub(String hubId) {
    final items = posts.where((e) => e.hubId == hubId).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  List<ActivityComment> commentsForPost(String postId) {
    final items = comments.where((e) => e.postId == postId).toList();
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  List<Project> projectsForHub(String hubId) => projects.where((e) => e.hubId == hubId).toList();

  List<Project> projectsForCurrentUser() => projects.where((e) => e.memberIds.contains(currentUserId) || e.ownerId == currentUserId).toList();

  String _progressKey(String projectId, String builderId, String userId) => '$projectId::$builderId::$userId';

  List<String> completedLessons(String projectId, String builderId, String userId) {
    return completedLessonIds[_progressKey(projectId, builderId, userId)] ?? const [];
  }

  int completedCountForBuilder(String projectId, String builderId, String userId) {
    return completedLessons(projectId, builderId, userId).length;
  }

  double builderCompletionRatio(String projectId, String builderId, String userId) {
    final total = lessonsForBuilder(builderId).length;
    if (total == 0) return answerFor(projectId, builderId)?.isPublished == true ? 1 : 0;
    return completedCountForBuilder(projectId, builderId, userId) / total;
  }

  BuilderAnswer? answerFor(String projectId, String builderId) {
    for (final answer in answers) {
      if (answer.projectId == projectId && answer.builderId == builderId) return answer;
    }
    return null;
  }

  List<BuilderAnswer> publishedAnswersForProject(String projectId) {
    final items = answers.where((e) => e.projectId == projectId && e.isPublished).toList();
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  List<ScoreRecord> releasedScoresForProject(String projectId) => scores.where((e) => e.projectId == projectId && e.isReleased).toList();
  List<ScoreRecord> unreleasedScores() => scores.where((e) => !e.isReleased).toList();

  void switchCurrentUser(String userId) {
    currentUserId = userId;
    notifyListeners();
  }

  void setActiveHub(String hubId) {
    activeHubId = hubId;
    final project = projects.where((e) => e.hubId == hubId).toList();
    if (project.isNotEmpty) activeProjectId = project.first.id;
    notifyListeners();
  }

  void setActiveProject(String projectId) {
    activeProjectId = projectId;
    notifyListeners();
  }

  void addPost({
    required PostType type,
    required String body,
    required String hubId,
    String? projectId,
    String? imagePath,
  }) {
    final post = ActivityPost(
      id: _uuid.v4(),
      hubId: hubId,
      projectId: projectId,
      authorId: currentUserId,
      type: type,
      body: body.trim(),
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );
    posts = [post, ...posts];
    _markPendingSync();
    notifyListeners();
  }

  void addComment(String postId, String body) {
    comments = [
      ...comments,
      ActivityComment(
        id: _uuid.v4(),
        postId: postId,
        authorId: currentUserId,
        body: body.trim(),
        createdAt: DateTime.now(),
      ),
    ];
    _markPendingSync();
    notifyListeners();
  }

  void toggleKudos(String postId) {
    posts = posts.map((post) {
      if (post.id != postId) return post;
      final next = [...post.kudosUserIds];
      if (next.contains(currentUserId)) {
        next.remove(currentUserId);
      } else {
        next.add(currentUserId);
      }
      return post.copyWith(kudosUserIds: next);
    }).toList();
    _markPendingSync();
    notifyListeners();
  }

void markLessonComplete(String projectId, String builderId, String lessonId) {
    final key = _progressKey(projectId, builderId, currentUserId);
    
    // FIX: Explicitly type the empty fallback list as <String>[]
    final current = [...(completedLessonIds[key] ?? const <String>[])];
    
    if (!current.contains(lessonId)) current.add(lessonId);
    completedLessonIds[key] = current;
    _markPendingSync();
    notifyListeners();
  }

  BuilderAnswer saveAnswer({
    required String projectId,
    required String builderId,
    required String answerText,
    List<String> imagePaths = const [],
  }) {
    final existing = answerFor(projectId, builderId);
    final now = DateTime.now();
    if (existing == null) {
      final answer = BuilderAnswer(
        id: _uuid.v4(),
        projectId: projectId,
        builderId: builderId,
        answerText: answerText.trim(),
        imagePaths: imagePaths,
        status: AnswerStatus.draft,
        createdBy: currentUserId,
        updatedBy: currentUserId,
        versionNumber: 1,
        createdAt: now,
        updatedAt: now,
      );
      answers = [...answers, answer];
      _markPendingSync();
      notifyListeners();
      return answer;
    }
    final status = existing.status == AnswerStatus.published ? AnswerStatus.updatedAfterPublish : existing.status;
    final updated = existing.copyWith(
      answerText: answerText.trim(),
      imagePaths: imagePaths,
      status: status,
      updatedBy: currentUserId,
      versionNumber: existing.versionNumber + 1,
      updatedAt: now,
    );
    answers = answers.map((e) => e.id == updated.id ? updated : e).toList();
    _markPendingSync();
    notifyListeners();
    return updated;
  }

  void publishAnswer(String projectId, String builderId) {
    final existing = answerFor(projectId, builderId);
    if (existing == null) return;
    if (existing.answerText.trim().isEmpty && existing.imagePaths.isEmpty) return;
    final updated = existing.copyWith(
      status: AnswerStatus.published,
      publishedBy: currentUserId,
      publishedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    answers = answers.map((e) => e.id == updated.id ? updated : e).toList();
    _markPendingSync();
    notifyListeners();
  }

  void upsertAnswerScore({
    required BuilderAnswer answer,
    required double score,
    required String feedback,
  }) {
    final now = DateTime.now();
    final existing = scores.where((e) => e.type == ScoreType.builderAnswer && e.answerId == answer.id && e.scoredBy == currentUserId).toList();
    if (existing.isEmpty) {
      scores = [
        ...scores,
        ScoreRecord(
          id: _uuid.v4(),
          type: ScoreType.builderAnswer,
          projectId: answer.projectId,
          answerId: answer.id,
          builderId: answer.builderId,
          scoredBy: currentUserId,
          score: score,
          feedback: feedback.trim(),
          status: ScoreStatus.submitted,
          isReleased: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];
    } else {
      final updated = existing.first.copyWith(
        score: score,
        feedback: feedback.trim(),
        status: ScoreStatus.submitted,
        isReleased: false,
        updatedAt: now,
      );
      scores = scores.map((e) => e.id == updated.id ? updated : e).toList();
    }
    _markPendingSync();
    notifyListeners();
  }

  void upsertProjectScore({
    required String projectId,
    required double score,
    required String feedback,
  }) {
    final now = DateTime.now();
    final existing = scores.where((e) => e.type == ScoreType.project && e.projectId == projectId && e.scoredBy == currentUserId).toList();
    if (existing.isEmpty) {
      scores = [
        ...scores,
        ScoreRecord(
          id: _uuid.v4(),
          type: ScoreType.project,
          projectId: projectId,
          scoredBy: currentUserId,
          score: score,
          feedback: feedback.trim(),
          status: ScoreStatus.submitted,
          isReleased: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];
    } else {
      final updated = existing.first.copyWith(
        score: score,
        feedback: feedback.trim(),
        status: ScoreStatus.submitted,
        isReleased: false,
        updatedAt: now,
      );
      scores = scores.map((e) => e.id == updated.id ? updated : e).toList();
    }
    _markPendingSync();
    notifyListeners();
  }

  void releaseScore(String scoreId) {
    scores = scores.map((score) {
      if (score.id != scoreId) return score;
      return score.copyWith(
        status: ScoreStatus.released,
        isReleased: true,
        releasedBy: currentUserId,
        releasedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
    _markPendingSync();
    notifyListeners();
  }

  void createBuilder({
    required String trackId,
    required String title,
    required String description,
    required String answerPrompt,
  }) {
    final id = _uuid.v4();
    builders = [
      ...builders,
      BuilderModule(
        id: id,
        trackId: trackId,
        title: title.trim(),
        description: description.trim(),
        answerPrompt: answerPrompt.trim(),
        topicIds: const [],
      ),
    ];
    _markPendingSync();
    notifyListeners();
  }

  void createProject({
    required String name,
    required String tagline,
    required String description,
    required String category,
    required String location,
  }) {
    final project = Project(
      id: _uuid.v4(),
      institutionId: activeHub.institutionId,
      hubId: activeHubId,
      name: name.trim(),
      tagline: tagline.trim(),
      description: description.trim(),
      category: category.trim(),
      location: location.trim(),
      ownerId: currentUserId,
      memberIds: [currentUserId],
    );
    projects = [...projects, project];
    activeProjectId = project.id;
    _markPendingSync();
    notifyListeners();
  }

  void flushSyncQueue() {
    pendingSyncCount = 0;
    _persist();
    notifyListeners();
  }

  void resetLocalDemoData() {
    cache.clear();
    builders = _seedBuilders();
    posts = _seedPosts();
    comments = _seedComments();
    answers = _seedAnswers();
    scores = _seedScores();
    completedLessonIds = _readProgress();
    pendingSyncCount = 0;
    _persist();
    notifyListeners();
  }
}
