import 'package:flutter/material.dart';

String enumName(Object value) => value.toString().split('.').last;

T enumFromName<T extends Enum>(List<T> values, String? name, T fallback) {
  if (name == null) return fallback;
  for (final item in values) {
    if (item.name == name) return item;
  }
  return fallback;
}

enum UserRole { admin, institutionManager, faculty, student }
enum HubMemberRole { manager, faculty, student }
enum ProjectRole { owner, member, facultyMentor }
enum PostType { post, idea, question, resource, announcement }
enum AnswerStatus { draft, published, updatedAfterPublish, archived }
enum ScoreType { builderAnswer, project }
enum ScoreStatus { draft, submitted, released, needsRevision }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Admin',
        UserRole.institutionManager => 'Institution Manager',
        UserRole.faculty => 'Faculty',
        UserRole.student => 'Student',
      };
}

extension PostTypeUi on PostType {
  String get label => switch (this) {
        PostType.post => 'Post',
        PostType.idea => 'Idea',
        PostType.question => 'Question',
        PostType.resource => 'Resource',
        PostType.announcement => 'Announcement',
      };

  IconData get icon => switch (this) {
        PostType.post => Icons.edit_note,
        PostType.idea => Icons.lightbulb_outline,
        PostType.question => Icons.help_outline,
        PostType.resource => Icons.link,
        PostType.announcement => Icons.campaign_outlined,
      };

  Color get color => switch (this) {
        PostType.post => const Color(0xFF607D8B),
        PostType.idea => const Color(0xFFF5A524),
        PostType.question => const Color(0xFF4CC9F0),
        PostType.resource => const Color(0xFF7E57C2),
        PostType.announcement => const Color(0xFF00A7B5),
      };
}

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.avatarUrl,
    this.bio = '',
    this.powers = const [],
  });

  final String id;
  final String name;
  final String email;
  final List<UserRole> roles;
  final String? avatarUrl;
  final String bio;
  final List<String> powers;

  bool hasRole(UserRole role) => roles.contains(role);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'roles': roles.map((e) => e.name).toList(),
        'avatarUrl': avatarUrl,
        'bio': bio,
        'powers': powers,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        roles: ((json['roles'] as List?) ?? const [])
            .map((e) => enumFromName(UserRole.values, e.toString(), UserRole.student))
            .toList(),
        avatarUrl: json['avatarUrl'] as String?,
        bio: (json['bio'] as String?) ?? '',
        powers: ((json['powers'] as List?) ?? const []).map((e) => e.toString()).toList(),
      );
}

class Institution {
  Institution({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    this.description = '',
  });

  final String id;
  final String name;
  final String slug;
  final String? logoUrl;
  final String description;
}

class Hub {
  Hub({
    required this.id,
    required this.institutionId,
    required this.name,
    required this.description,
    this.logoUrl,
  });

  final String id;
  final String institutionId;
  final String name;
  final String description;
  final String? logoUrl;
}

class DemoGroup {
  DemoGroup({
    required this.id,
    required this.hubId,
    required this.name,
    required this.status,
    required this.projectIds,
    required this.memberIds,
    required this.managerIds,
  });

  final String id;
  final String hubId;
  final String name;
  final String status;
  final List<String> projectIds;
  final List<String> memberIds;
  final List<String> managerIds;
}

class DemoEvent {
  DemoEvent({
    required this.id,
    required this.hubId,
    required this.title,
    required this.description,
    required this.startsAt,
  });

  final String id;
  final String hubId;
  final String title;
  final String description;
  final DateTime startsAt;
}

class Project {
  Project({
    required this.id,
    required this.institutionId,
    required this.hubId,
    required this.name,
    required this.tagline,
    required this.description,
    required this.category,
    required this.location,
    required this.ownerId,
    required this.memberIds,
    this.logoUrl,
    this.visibility = 'hub',
  });

  final String id;
  final String institutionId;
  final String hubId;
  final String name;
  final String tagline;
  final String description;
  final String category;
  final String location;
  final String ownerId;
  final List<String> memberIds;
  final String? logoUrl;
  final String visibility;

  Project copyWith({
    String? name,
    String? tagline,
    String? description,
    String? category,
    String? location,
    List<String>? memberIds,
    String? logoUrl,
    String? visibility,
  }) {
    return Project(
      id: id,
      institutionId: institutionId,
      hubId: hubId,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      ownerId: ownerId,
      memberIds: memberIds ?? this.memberIds,
      logoUrl: logoUrl ?? this.logoUrl,
      visibility: visibility ?? this.visibility,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'institutionId': institutionId,
        'hubId': hubId,
        'name': name,
        'tagline': tagline,
        'description': description,
        'category': category,
        'location': location,
        'ownerId': ownerId,
        'memberIds': memberIds,
        'logoUrl': logoUrl,
        'visibility': visibility,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        institutionId: json['institutionId'] as String,
        hubId: json['hubId'] as String,
        name: json['name'] as String,
        tagline: (json['tagline'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        category: (json['category'] as String?) ?? '',
        location: (json['location'] as String?) ?? '',
        ownerId: json['ownerId'] as String,
        memberIds: ((json['memberIds'] as List?) ?? const []).map((e) => e.toString()).toList(),
        logoUrl: json['logoUrl'] as String?,
        visibility: (json['visibility'] as String?) ?? 'hub',
      );
}

class BuilderTrack {
  BuilderTrack({
    required this.id,
    required this.title,
    required this.description,
    required this.builderIds,
  });

  final String id;
  final String title;
  final String description;
  final List<String> builderIds;
}

class BuilderModule {
  BuilderModule({
    required this.id,
    required this.trackId,
    required this.title,
    required this.description,
    required this.answerPrompt,
    required this.topicIds,
    this.imageUrl,
    this.isPublished = true,
  });

  final String id;
  final String trackId;
  final String title;
  final String description;
  final String answerPrompt;
  final List<String> topicIds;
  final String? imageUrl;
  final bool isPublished;

  Map<String, dynamic> toJson() => {
        'id': id,
        'trackId': trackId,
        'title': title,
        'description': description,
        'answerPrompt': answerPrompt,
        'topicIds': topicIds,
        'imageUrl': imageUrl,
        'isPublished': isPublished,
      };

  factory BuilderModule.fromJson(Map<String, dynamic> json) => BuilderModule(
        id: json['id'] as String,
        trackId: json['trackId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        answerPrompt: json['answerPrompt'] as String,
        topicIds: ((json['topicIds'] as List?) ?? const []).map((e) => e.toString()).toList(),
        imageUrl: json['imageUrl'] as String?,
        isPublished: (json['isPublished'] as bool?) ?? true,
      );
}

class BuilderTopic {
  BuilderTopic({
    required this.id,
    required this.builderId,
    required this.title,
    required this.description,
    required this.lessonIds,
  });

  final String id;
  final String builderId;
  final String title;
  final String description;
  final List<String> lessonIds;
}

class BuilderLesson {
  BuilderLesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.body,
    required this.sortOrder,
  });

  final String id;
  final String topicId;
  final String title;
  final String body;
  final int sortOrder;
}

class BuilderAnswer {
  BuilderAnswer({
    required this.id,
    required this.projectId,
    required this.builderId,
    required this.answerText,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.versionNumber,
    required this.createdAt,
    required this.updatedAt,
    this.imagePaths = const [],
    this.publishedBy,
    this.publishedAt,
  });

  final String id;
  final String projectId;
  final String builderId;
  final String answerText;
  final List<String> imagePaths;
  final AnswerStatus status;
  final String createdBy;
  final String updatedBy;
  final String? publishedBy;
  final DateTime? publishedAt;
  final int versionNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPublished => status == AnswerStatus.published || status == AnswerStatus.updatedAfterPublish;

  BuilderAnswer copyWith({
    String? answerText,
    List<String>? imagePaths,
    AnswerStatus? status,
    String? updatedBy,
    String? publishedBy,
    DateTime? publishedAt,
    int? versionNumber,
    DateTime? updatedAt,
  }) {
    return BuilderAnswer(
      id: id,
      projectId: projectId,
      builderId: builderId,
      answerText: answerText ?? this.answerText,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      createdBy: createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      publishedBy: publishedBy ?? this.publishedBy,
      publishedAt: publishedAt ?? this.publishedAt,
      versionNumber: versionNumber ?? this.versionNumber,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'builderId': builderId,
        'answerText': answerText,
        'imagePaths': imagePaths,
        'status': status.name,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'publishedBy': publishedBy,
        'publishedAt': publishedAt?.toIso8601String(),
        'versionNumber': versionNumber,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory BuilderAnswer.fromJson(Map<String, dynamic> json) => BuilderAnswer(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        builderId: json['builderId'] as String,
        answerText: (json['answerText'] as String?) ?? '',
        imagePaths: ((json['imagePaths'] as List?) ?? const []).map((e) => e.toString()).toList(),
        status: enumFromName(AnswerStatus.values, json['status']?.toString(), AnswerStatus.draft),
        createdBy: json['createdBy'] as String,
        updatedBy: json['updatedBy'] as String,
        publishedBy: json['publishedBy'] as String?,
        publishedAt: json['publishedAt'] == null ? null : DateTime.parse(json['publishedAt'] as String),
        versionNumber: (json['versionNumber'] as num?)?.toInt() ?? 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class ActivityPost {
  ActivityPost({
    required this.id,
    required this.hubId,
    required this.authorId,
    required this.type,
    required this.body,
    required this.createdAt,
    this.projectId,
    this.imagePath,
    this.kudosUserIds = const [],
  });

  final String id;
  final String hubId;
  final String? projectId;
  final String authorId;
  final PostType type;
  final String body;
  final String? imagePath;
  final DateTime createdAt;
  final List<String> kudosUserIds;

  ActivityPost copyWith({
    String? body,
    String? imagePath,
    List<String>? kudosUserIds,
  }) {
    return ActivityPost(
      id: id,
      hubId: hubId,
      projectId: projectId,
      authorId: authorId,
      type: type,
      body: body ?? this.body,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
      kudosUserIds: kudosUserIds ?? this.kudosUserIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hubId': hubId,
        'projectId': projectId,
        'authorId': authorId,
        'type': type.name,
        'body': body,
        'imagePath': imagePath,
        'createdAt': createdAt.toIso8601String(),
        'kudosUserIds': kudosUserIds,
      };

  factory ActivityPost.fromJson(Map<String, dynamic> json) => ActivityPost(
        id: json['id'] as String,
        hubId: json['hubId'] as String,
        projectId: json['projectId'] as String?,
        authorId: json['authorId'] as String,
        type: enumFromName(PostType.values, json['type']?.toString(), PostType.post),
        body: (json['body'] as String?) ?? '',
        imagePath: json['imagePath'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        kudosUserIds: ((json['kudosUserIds'] as List?) ?? const []).map((e) => e.toString()).toList(),
      );
}

class ActivityComment {
  ActivityComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String authorId;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'authorId': authorId,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ActivityComment.fromJson(Map<String, dynamic> json) => ActivityComment(
        id: json['id'] as String,
        postId: json['postId'] as String,
        authorId: json['authorId'] as String,
        body: (json['body'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ScoreRecord {
  ScoreRecord({
    required this.id,
    required this.type,
    required this.projectId,
    required this.scoredBy,
    required this.score,
    required this.feedback,
    required this.status,
    required this.isReleased,
    required this.createdAt,
    required this.updatedAt,
    this.answerId,
    this.builderId,
    this.releasedBy,
    this.releasedAt,
  });

  final String id;
  final ScoreType type;
  final String projectId;
  final String? answerId;
  final String? builderId;
  final String scoredBy;
  final double score;
  final String feedback;
  final ScoreStatus status;
  final bool isReleased;
  final String? releasedBy;
  final DateTime? releasedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScoreRecord copyWith({
    double? score,
    String? feedback,
    ScoreStatus? status,
    bool? isReleased,
    String? releasedBy,
    DateTime? releasedAt,
    DateTime? updatedAt,
  }) {
    return ScoreRecord(
      id: id,
      type: type,
      projectId: projectId,
      answerId: answerId,
      builderId: builderId,
      scoredBy: scoredBy,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      status: status ?? this.status,
      isReleased: isReleased ?? this.isReleased,
      releasedBy: releasedBy ?? this.releasedBy,
      releasedAt: releasedAt ?? this.releasedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'projectId': projectId,
        'answerId': answerId,
        'builderId': builderId,
        'scoredBy': scoredBy,
        'score': score,
        'feedback': feedback,
        'status': status.name,
        'isReleased': isReleased,
        'releasedBy': releasedBy,
        'releasedAt': releasedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ScoreRecord.fromJson(Map<String, dynamic> json) => ScoreRecord(
        id: json['id'] as String,
        type: enumFromName(ScoreType.values, json['type']?.toString(), ScoreType.builderAnswer),
        projectId: json['projectId'] as String,
        answerId: json['answerId'] as String?,
        builderId: json['builderId'] as String?,
        scoredBy: json['scoredBy'] as String,
        score: (json['score'] as num).toDouble(),
        feedback: (json['feedback'] as String?) ?? '',
        status: enumFromName(ScoreStatus.values, json['status']?.toString(), ScoreStatus.draft),
        isReleased: (json['isReleased'] as bool?) ?? false,
        releasedBy: json['releasedBy'] as String?,
        releasedAt: json['releasedAt'] == null ? null : DateTime.parse(json['releasedAt'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class InviteLink {
  InviteLink({
    required this.id,
    required this.token,
    required this.roleLabel,
    required this.scopeLabel,
    required this.maxUses,
    required this.usedCount,
  });

  final String id;
  final String token;
  final String roleLabel;
  final String scopeLabel;
  final int maxUses;
  final int usedCount;

  String get link => 'https://app.rebelbase.co/invite/$token';
}
