import 'package:flutter/material.dart';
import 'user_level.dart';
import 'achievement.dart';
import 'reputation.dart';

/// The complete gamification state for a user.
/// This is the single source of truth for all gamification data.
class GamificationState {
  final UserLevel level;
  final CommunityReputation reputation;
  final List<Achievement> achievements;
  final List<RecentActivity> recentActivity;
  final bool hasNewAchievement;
  final Achievement? lastUnlockedAchievement;
  final bool hasLeveledUp;
  final int? previousLevel;
  final int lastXPGained;

  const GamificationState({
    required this.level,
    required this.reputation,
    required this.achievements,
    this.recentActivity = const [],
    this.hasNewAchievement = false,
    this.lastUnlockedAchievement,
    this.hasLeveledUp = false,
    this.previousLevel,
    this.lastXPGained = 0,
  });

  /// Create a default initial state
  static GamificationState get defaultState => GamificationState(
    level: UserLevel.defaultLevel,
    reputation: const CommunityReputation(),
    achievements: [],
  );

  /// Get unlocked achievements
  List<Achievement> get unlockedAchievements =>
      achievements.where((a) => a.isUnlocked).toList();

  /// Get in-progress achievements
  List<Achievement> get inProgressAchievements =>
      achievements.where((a) => a.isInProgress).toList();

  /// Get locked achievements
  List<Achievement> get lockedAchievements =>
      achievements.where((a) => a.isLocked).toList();

  /// Get recently unlocked achievements (last 3)
  List<Achievement> get recentAchievements {
    final unlocked =
        unlockedAchievements.where((a) => a.unlockedAt != null).toList()
          ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
    return unlocked.take(3).toList();
  }

  /// Create a copy with updated fields
  GamificationState copyWith({
    UserLevel? level,
    CommunityReputation? reputation,
    List<Achievement>? achievements,
    List<RecentActivity>? recentActivity,
    bool? hasNewAchievement,
    Achievement? lastUnlockedAchievement,
    bool? hasLeveledUp,
    int? previousLevel,
    int? lastXPGained,
    bool clearNewAchievement = false,
    bool clearLevelUp = false,
  }) {
    return GamificationState(
      level: level ?? this.level,
      reputation: reputation ?? this.reputation,
      achievements: achievements ?? this.achievements,
      recentActivity: recentActivity ?? this.recentActivity,
      hasNewAchievement: clearNewAchievement
          ? false
          : (hasNewAchievement ?? this.hasNewAchievement),
      lastUnlockedAchievement: clearNewAchievement
          ? null
          : (lastUnlockedAchievement ?? this.lastUnlockedAchievement),
      hasLeveledUp: clearLevelUp ? false : (hasLeveledUp ?? this.hasLeveledUp),
      previousLevel: previousLevel ?? this.previousLevel,
      lastXPGained: lastXPGained ?? this.lastXPGained,
    );
  }

  @override
  String toString() =>
      'GamificationState(level: ${level.level}, XP: ${level.currentXP}, '
      'achievements: ${unlockedAchievements.length}/${achievements.length})';
}

/// A recent activity entry for the timeline.
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final int xpGained;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;
  final ActivityType type;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    this.xpGained = 0,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.type,
  });
}

enum ActivityType { report, match, returnItem, achievement, levelUp, help }
