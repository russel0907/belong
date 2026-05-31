import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gamification_state.dart';
import '../models/user_level.dart';
import '../models/achievement.dart';
import '../models/reputation.dart';
import '../data/mock_gamification_data.dart';
import '../utils/xp_calculator.dart';

/// Provider for the gamification state.
/// In production, this would connect to a backend API.
/// For now, it uses mock data and simulates XP gains.
class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(MockGamificationData.mockState);

  /// Add XP and check for level-ups and achievement unlocks
  void addXP(int amount, {String? reason, String? source}) {
    if (amount <= 0) return;

    final currentLevel = state.level;
    final newXP = currentLevel.currentXP + amount;
    final xpNeeded = currentLevel.xpToNextLevel;

    // Check if user levels up
    if (newXP >= xpNeeded && !currentLevel.isMaxLevel) {
      final newLevelNum = currentLevel.level + 1;
      final remainingXP = newXP - xpNeeded;
      final nextLevelXP =
          UserLevel.xpForLevel(newLevelNum + 1) -
          UserLevel.xpForLevel(newLevelNum);

      final newLevel = UserLevel(
        level: newLevelNum,
        currentXP: remainingXP,
        xpToNextLevel: nextLevelXP,
        title: UserLevel.titleForLevel(newLevelNum),
      );

      // Add level-up activity
      final activity = RecentActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Level Up!',
        description: 'Reached Level $newLevelNum - ${newLevel.title}',
        xpGained: amount,
        timestamp: DateTime.now(),
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF0D9488),
        type: ActivityType.levelUp,
      );

      state = state.copyWith(
        level: newLevel,
        lastXPGained: amount,
        hasLeveledUp: true,
        previousLevel: currentLevel.level,
        recentActivity: [activity, ...state.recentActivity].take(20).toList(),
      );
    } else {
      final updatedLevel = UserLevel(
        level: currentLevel.level,
        currentXP: newXP,
        xpToNextLevel: xpNeeded,
        title: currentLevel.title,
      );

      state = state.copyWith(level: updatedLevel, lastXPGained: amount);
    }

    // Check for achievement unlocks
    _checkAchievements();
  }

  /// Check and unlock any achievements that have been earned
  void _checkAchievements() {
    final reputation = state.reputation;
    final achievements = state.achievements;
    bool hasNewUnlock = false;
    Achievement? lastUnlocked;

    final updatedAchievements = achievements.map((achievement) {
      if (achievement.isUnlocked) return achievement;

      int current = achievement.current;
      bool shouldUnlock = false;

      // Calculate progress based on achievement type
      switch (achievement.id) {
        case 'first_found':
          current = reputation.peopleHelped > 0 ? 1 : 0;
          shouldUnlock = current >= achievement.required;
          break;
        case 'first_return':
          current = reputation.successfulReturns > 0 ? 1 : 0;
          shouldUnlock = current >= achievement.required;
          break;
        case 'community_hero':
          current = reputation.peopleHelped;
          shouldUnlock = current >= achievement.required;
          break;
        case 'trusted_finder':
          current = reputation.successfulReturns;
          shouldUnlock =
              current >= achievement.required &&
              reputation.trustedFinderScore >= 4.5;
          break;
        case 'fast_responder':
          // Would be set externally when a fast response happens
          shouldUnlock = false;
          break;
        case 'verified_contributor':
          current = reputation.helperPoints ~/ 100;
          shouldUnlock = current >= achievement.required;
          break;
        case 'good_samaritan':
          // Would be set externally
          shouldUnlock = false;
          break;
        case 'ten_returns':
          current = reputation.successfulReturns;
          shouldUnlock = current >= achievement.required;
          break;
        case 'fifty_returns':
          current = reputation.successfulReturns;
          shouldUnlock = current >= achievement.required;
          break;
        case 'hundred_returns':
          current = reputation.successfulReturns;
          shouldUnlock = current >= achievement.required;
          break;
      }

      if (shouldUnlock) {
        hasNewUnlock = true;
        final unlocked = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
          progress: 1.0,
          current: current,
        );
        lastUnlocked = unlocked;

        // Add XP reward for achievement
        if (unlocked.xpReward > 0) {
          addXP(unlocked.xpReward, reason: 'Achievement: ${unlocked.title}');
        }

        // Add achievement activity
        final activity = RecentActivity(
          id: 'achievement_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Achievement Unlocked',
          description: unlocked.title,
          xpGained: unlocked.xpReward,
          timestamp: DateTime.now(),
          icon: unlocked.icon,
          iconColor: unlocked.rarity.color,
          type: ActivityType.achievement,
        );

        state = state.copyWith(
          recentActivity: [activity, ...state.recentActivity].take(20).toList(),
        );

        return unlocked;
      }

      // Update progress
      final progress = achievement.required > 0
          ? (current / achievement.required).clamp(0.0, 1.0)
          : 0.0;
      return achievement.copyWith(progress: progress, current: current);
    }).toList();

    if (hasNewUnlock) {
      state = state.copyWith(
        achievements: updatedAchievements,
        hasNewAchievement: true,
        lastUnlockedAchievement: lastUnlocked,
      );
    } else {
      state = state.copyWith(achievements: updatedAchievements);
    }
  }

  /// Simulate reporting a found item
  void reportFoundItem() {
    final xp = XPCalculator.reportFoundItem;
    final reputation = state.reputation.copyWith(
      helperPoints: state.reputation.helperPoints + xp,
      contributorLevel: CommunityReputation.levelForPoints(
        state.reputation.helperPoints + xp,
      ),
    );

    state = state.copyWith(reputation: reputation);
    addXP(xp, reason: 'Reported found item', source: 'report_found');

    // Add activity
    final activity = RecentActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Found Item Reported',
      description: 'You reported a found item to the community',
      xpGained: xp,
      timestamp: DateTime.now(),
      icon: Icons.search_rounded,
      iconColor: const Color(0xFF0D9488),
      type: ActivityType.report,
    );

    state = state.copyWith(
      recentActivity: [activity, ...state.recentActivity].take(20).toList(),
    );
  }

  /// Simulate reporting a lost item
  void reportLostItem() {
    final xp = XPCalculator.reportLostItem;
    final reputation = state.reputation.copyWith(
      helperPoints: state.reputation.helperPoints + xp,
      contributorLevel: CommunityReputation.levelForPoints(
        state.reputation.helperPoints + xp,
      ),
    );

    state = state.copyWith(reputation: reputation);
    addXP(xp, reason: 'Reported lost item', source: 'report_lost');
  }

  /// Simulate a successful return
  void successfulReturn() {
    final xp = XPCalculator.successfulReturn;
    final reputation = state.reputation.copyWith(
      helperPoints: state.reputation.helperPoints + xp,
      successfulReturns: state.reputation.successfulReturns + 1,
      peopleHelped: state.reputation.peopleHelped + 1,
      trustedFinderScore: _calculateTrustScore(
        state.reputation.trustedFinderScore,
        state.reputation.successfulReturns + 1,
      ),
      contributorLevel: CommunityReputation.levelForPoints(
        state.reputation.helperPoints + xp,
      ),
    );

    state = state.copyWith(reputation: reputation);
    addXP(xp, reason: 'Successful return', source: 'successful_return');

    // Add activity
    final activity = RecentActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Item Returned Successfully',
      description: 'An item was successfully returned to its owner',
      xpGained: xp,
      timestamp: DateTime.now(),
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFF059669),
      type: ActivityType.returnItem,
    );

    state = state.copyWith(
      recentActivity: [activity, ...state.recentActivity].take(20).toList(),
    );
  }

  /// Simulate helping someone
  void helpSomeone() {
    final xp = XPCalculator.helpSomeone;
    final reputation = state.reputation.copyWith(
      helperPoints: state.reputation.helperPoints + xp,
      peopleHelped: state.reputation.peopleHelped + 1,
      contributorLevel: CommunityReputation.levelForPoints(
        state.reputation.helperPoints + xp,
      ),
    );

    state = state.copyWith(reputation: reputation);
    addXP(xp, reason: 'Helped someone', source: 'help_someone');
  }

  /// Simulate daily login with streak
  void dailyLogin() {
    final newStreak = state.reputation.currentStreak + 1;
    final xp = XPCalculator.dailyLoginWithStreak(newStreak);
    final reputation = state.reputation.copyWith(
      helperPoints: state.reputation.helperPoints + xp,
      currentStreak: newStreak,
      longestStreak: newStreak > state.reputation.longestStreak
          ? newStreak
          : state.reputation.longestStreak,
    );

    state = state.copyWith(reputation: reputation);
    addXP(xp, reason: 'Daily login', source: 'daily_login');
  }

  /// Clear the new achievement notification
  void clearNewAchievement() {
    state = state.copyWith(clearNewAchievement: true);
  }

  /// Clear the level-up notification
  void clearLevelUp() {
    state = state.copyWith(clearLevelUp: true);
  }

  /// Calculate trust score based on returns
  double _calculateTrustScore(double currentScore, int totalReturns) {
    if (totalReturns <= 0) return 0.0;
    // Gradually increase towards 5.0
    final target = (totalReturns / (totalReturns + 2)) * 5.0;
    return (currentScore + (target - currentScore) * 0.3).clamp(0.0, 5.0);
  }
}

/// The main gamification state provider
final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
      return GamificationNotifier();
    });
