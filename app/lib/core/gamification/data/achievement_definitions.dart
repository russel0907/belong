import 'package:flutter/material.dart';
import '../models/achievement.dart';

/// All achievement definitions for Belong.
/// These are the canonical definitions - the source of truth for what achievements exist.
class AchievementDefinitions {
  AchievementDefinitions._();

  /// Get all achievement definitions
  static List<Achievement> get all => [
    firstItemFound,
    firstSuccessfulReturn,
    communityHero,
    trustedFinder,
    fastResponder,
    verifiedContributor,
    goodSamaritan,
    tenReturns,
    fiftyReturns,
    hundredReturns,
  ];

  /// First Item Found - Report your first found item
  static const Achievement firstItemFound = Achievement(
    id: 'first_found',
    title: 'First Item Found',
    description: 'Reported your first found item to the community',
    category: AchievementCategory.discovery,
    rarity: AchievementRarity.common,
    icon: Icons.search_rounded,
    xpReward: 50,
    required: 1,
  );

  /// First Successful Return - First item returned to owner
  static const Achievement firstSuccessfulReturn = Achievement(
    id: 'first_return',
    title: 'First Successful Return',
    description: 'Successfully returned an item to its owner',
    category: AchievementCategory.returns,
    rarity: AchievementRarity.common,
    icon: Icons.favorite_rounded,
    xpReward: 100,
    required: 1,
  );

  /// Community Hero - Helped 25 people
  static const Achievement communityHero = Achievement(
    id: 'community_hero',
    title: 'Community Hero',
    description: 'Helped 25 people in the community find their belongings',
    category: AchievementCategory.community,
    rarity: AchievementRarity.rare,
    icon: Icons.diversity_3_rounded,
    xpReward: 500,
    required: 25,
  );

  /// Trusted Finder - 5.0 rating with 10+ returns
  static const Achievement trustedFinder = Achievement(
    id: 'trusted_finder',
    title: 'Trusted Finder',
    description: 'Achieved a perfect trust score with 10 successful returns',
    category: AchievementCategory.reliability,
    rarity: AchievementRarity.rare,
    icon: Icons.verified_rounded,
    xpReward: 300,
    required: 10,
  );

  /// Fast Responder - Respond to a match within 1 hour
  static const Achievement fastResponder = Achievement(
    id: 'fast_responder',
    title: 'Fast Responder',
    description: 'Responded to a potential match within one hour',
    category: AchievementCategory.reliability,
    rarity: AchievementRarity.common,
    icon: Icons.bolt_rounded,
    xpReward: 150,
    required: 1,
  );

  /// Verified Contributor - Reported 20+ items
  static const Achievement verifiedContributor = Achievement(
    id: 'verified_contributor',
    title: 'Verified Contributor',
    description: 'Reported 20 items to help the community',
    category: AchievementCategory.community,
    rarity: AchievementRarity.rare,
    icon: Icons.assignment_rounded,
    xpReward: 400,
    required: 20,
  );

  /// Good Samaritan - Returned item without accepting reward
  static const Achievement goodSamaritan = Achievement(
    id: 'good_samaritan',
    title: 'Good Samaritan',
    description: 'Returned an item to its owner without accepting a reward',
    category: AchievementCategory.community,
    rarity: AchievementRarity.common,
    icon: Icons.volunteer_activism_rounded,
    xpReward: 250,
    required: 1,
  );

  /// 10 Returns - 10 successful returns
  static const Achievement tenReturns = Achievement(
    id: 'ten_returns',
    title: '10 Returns',
    description: 'Successfully returned 10 items to their owners',
    category: AchievementCategory.returns,
    rarity: AchievementRarity.rare,
    icon: Icons.recycling_rounded,
    xpReward: 200,
    required: 10,
  );

  /// 50 Returns - 50 successful returns
  static const Achievement fiftyReturns = Achievement(
    id: 'fifty_returns',
    title: '50 Returns',
    description: 'Successfully returned 50 items to their owners',
    category: AchievementCategory.returns,
    rarity: AchievementRarity.epic,
    icon: Icons.auto_awesome_rounded,
    xpReward: 1000,
    required: 50,
  );

  /// 100 Returns - 100 successful returns
  static const Achievement hundredReturns = Achievement(
    id: 'hundred_returns',
    title: '100 Returns',
    description: 'Successfully returned 100 items to their owners',
    category: AchievementCategory.returns,
    rarity: AchievementRarity.legendary,
    icon: Icons.emoji_events_rounded,
    xpReward: 2500,
    required: 100,
  );
}
