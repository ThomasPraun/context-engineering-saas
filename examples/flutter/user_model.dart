import 'dart:convert';

/// Example User model with JSON serialization
/// This pattern demonstrates:
/// - Null safety
/// - JSON parsing with error handling
/// - Immutable data classes
/// - Factory constructors
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> roles;
  final List<String> permissions;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    required this.permissions,
    required this.preferences,
  });

  /// Factory constructor for creating User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        roles: List<String>.from(json['roles'] as List? ?? []),
        permissions: List<String>.from(json['permissions'] as List? ?? []),
        preferences: UserPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>? ?? {},
        ),
      );
    } catch (e) {
      throw FormatException('Failed to parse User from JSON: $e');
    }
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roles': roles,
      'permissions': permissions,
      'preferences': preferences.toJson(),
    };
  }

  /// Create User from JSON string
  factory User.fromJsonString(String jsonString) {
    return User.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  /// Convert User to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? roles,
    List<String>? permissions,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Get user's display name (falls back to email if name is empty)
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  /// Check if user has admin role
  bool get isAdmin => roles.contains('admin');

  /// Check if user has completed profile
  bool get hasCompletedProfile => 
      name.isNotEmpty && 
      isEmailVerified && 
      avatarUrl != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}

/// User preferences model
class UserPreferences {
  final bool darkMode;
  final String language;
  final bool emailNotifications;
  final bool pushNotifications;
  final NotificationFrequency notificationFrequency;

  const UserPreferences({
    this.darkMode = false,
    this.language = 'en',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.notificationFrequency = NotificationFrequency.instant,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      notificationFrequency: NotificationFrequency.fromString(
        json['notificationFrequency'] as String? ?? 'instant',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'language': language,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'notificationFrequency': notificationFrequency.value,
    };
  }

  UserPreferences copyWith({
    bool? darkMode,
    String? language,
    bool? emailNotifications,
    bool? pushNotifications,
    NotificationFrequency? notificationFrequency,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      notificationFrequency: notificationFrequency ?? this.notificationFrequency,
    );
  }
}

/// Notification frequency enum
enum NotificationFrequency {
  instant('instant'),
  daily('daily'),
  weekly('weekly'),
  never('never');

  final String value;
  const NotificationFrequency(this.value);

  static NotificationFrequency fromString(String value) {
    return NotificationFrequency.values.firstWhere(
      (freq) => freq.value == value,
      orElse: () => NotificationFrequency.instant,
    );
  }
}

/// Example of a related model - UserProfile
/// Demonstrates composition and nested models
class UserProfile {
  final User user;
  final UserStats stats;
  final List<UserAchievement> achievements;

  const UserProfile({
    required this.user,
    required this.stats,
    required this.achievements,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      achievements: (json['achievements'] as List? ?? [])
          .map((e) => UserAchievement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'stats': stats.toJson(),
      'achievements': achievements.map((e) => e.toJson()).toList(),
    };
  }
}

/// User statistics model
class UserStats {
  final int totalPosts;
  final int totalFollowers;
  final int totalFollowing;
  final DateTime lastActive;

  const UserStats({
    required this.totalPosts,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.lastActive,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalPosts: json['totalPosts'] as int? ?? 0,
      totalFollowers: json['totalFollowers'] as int? ?? 0,
      totalFollowing: json['totalFollowing'] as int? ?? 0,
      lastActive: DateTime.parse(json['lastActive'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPosts': totalPosts,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}

/// User achievement model
class UserAchievement {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final DateTime unlockedAt;

  const UserAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.unlockedAt,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }
}