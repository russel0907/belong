import 'package:flutter/material.dart';
import '../models/user_level.dart';
import '../models/reputation.dart';
import '../models/gamification_state.dart';
import 'achievement_definitions.dart';

/// Mock gamification data for development and preview.
/// Represents a user at Level 12 with some achievements unlocked.
class MockGamificationData {
  MockGamificationData._();

  /// Create a realistic mock gamification state
  static GamificationState get mockState {
    final now = DateTime.now();

    // Level 12 with partial XP progress
    final level = UserLevel(
      level: 12,
      currentXP: 450,
      xpToNextLevel: UserLevel.xpForLevel(13) - UserLevel.xpForLevel(12),
      title: 'Trusted Helper',
    );

    // Community reputation
    final reputation = CommunityReputation(
      helperPoints: 2840,
      trustedFinderScore: 4.8,
      contributorLevel: 'Silver',
      successfulReturns: 8,
      currentStreak: 5,
      longestStreak: 12,
      peopleHelped: 15,
      communityRanking: 42,
    );

    // Achievements with some unlocked
    final achievements = [
      // Unlocked achievements
      AchievementDefinitions.firstItemFound.copyWith(
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 45)),
        progress: 1.0,
        current: 1,
      ),
      AchievementDefinitions.firstSuccessfulReturn.copyWith(
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 30)),
        progress: 1.0,
        current: 1,
      ),
      AchievementDefinitions.fastResponder.copyWith(
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 20)),
        progress: 1.0,
        current: 1,
      ),
      AchievementDefinitions.goodSamaritan.copyWith(
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 15)),
        progress: 1.0,
        current: 1,
      ),
      AchievementDefinitions.verifiedContributor.copyWith(
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 7)),
        progress: 1.0,
        current: 20,
      ),
      // In-progress achievements
      AchievementDefinitions.communityHero.copyWith(progress: 0.6, current: 15),
      AchievementDefinitions.trustedFinder.copyWith(progress: 0.8, current: 8),
      AchievementDefinitions.tenReturns.copyWith(progress: 0.8, current: 8),
      // Locked achievements
      AchievementDefinitions.fiftyReturns,
      AchievementDefinitions.hundredReturns,
    ];

    // Recent activity
    final recentActivity = [
      RecentActivity(
        id: 'a1',
        title: 'Item Returned Successfully',
        description: 'Returned brown leather wallet to its owner',
        xpGained: 50,
        timestamp: now.subtract(const Duration(hours: 2)),
        icon: Icons.favorite_rounded,
        iconColor: const Color(0xFF059669),
        type: ActivityType.returnItem,
      ),
      RecentActivity(
        id: 'a2',
        title: 'Achievement Unlocked',
        description: 'Verified Contributor - Reported 20 items',
        xpGained: 400,
        timestamp: now.subtract(const Duration(days: 7)),
        icon: Icons.assignment_rounded,
        iconColor: const Color(0xFF0D9488),
        type: ActivityType.achievement,
      ),
      RecentActivity(
        id: 'a3',
        title: 'Found Item Reported',
        description: 'Reported a blue winter scarf in Central Park',
        xpGained: 15,
        timestamp: now.subtract(const Duration(days: 10)),
        icon: Icons.search_rounded,
        iconColor: const Color(0xFF0D9488),
        type: ActivityType.report,
      ),
      RecentActivity(
        id: 'a4',
        title: 'Potential Match Found',
        description: 'Your found item matches a lost AirPods case',
        xpGained: 25,
        timestamp: now.subtract(const Duration(days: 12)),
        icon: Icons.link_rounded,
        iconColor: const Color(0xFFD97706),
        type: ActivityType.match,
      ),
      RecentActivity(
        id: 'a5',
        title: 'Helped a Community Member',
        description: 'Provided information about a lost pet',
        xpGained: 20,
        timestamp: now.subtract(const Duration(days: 14)),
        icon: Icons.diversity_3_rounded,
        iconColor: const Color(0xFF7C3AED),
        type: ActivityType.help,
      ),
    ];

    return GamificationState(
      level: level,
      reputation: reputation,
      achievements: achievements,
      recentActivity: recentActivity,
    );
  }
}
