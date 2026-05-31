import 'package:flutter/material.dart';

/// The rarity of an achievement, affecting its visual presentation.
enum AchievementRarity {
  common,
  rare,
  epic,
  legendary;

  Color get color {
    switch (this) {
      case AchievementRarity.common:
        return const Color(0xFF78716C); // Stone
      case AchievementRarity.rare:
        return const Color(0xFF0D9488); // Teal
      case AchievementRarity.epic:
        return const Color(0xFF7C3AED); // Purple
      case AchievementRarity.legendary:
        return const Color(0xFFD97706); // Amber
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AchievementRarity.common:
        return const Color(0xFFF5F5F4);
      case AchievementRarity.rare:
        return const Color(0xFFF0FDFA);
      case AchievementRarity.epic:
        return const Color(0xFFF5F3FF);
      case AchievementRarity.legendary:
        return const Color(0xFFFFFBEB);
    }
  }

  String get label {
    switch (this) {
      case AchievementRarity.common:
        return 'Common';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.legendary:
        return 'Legendary';
    }
  }
}

/// The category of an achievement.
enum AchievementCategory {
  discovery,
  returns,
  community,
  reliability;

  String get label {
    switch (this) {
      case AchievementCategory.discovery:
        return 'Discovery';
      case AchievementCategory.returns:
        return 'Returns';
      case AchievementCategory.community:
        return 'Community';
      case AchievementCategory.reliability:
        return 'Reliability';
    }
  }
}

/// Represents a single achievement that can be unlocked.
class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final IconData icon;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final int current; // Current count towards requirement
  final int required; // Required count to unlock

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rarity,
    required this.icon,
    this.xpReward = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.current = 0,
    this.required = 1,
  });

  /// Create a copy with updated fields
  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    int? current,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      category: category,
      rarity: rarity,
      icon: icon,
      xpReward: xpReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      current: current ?? this.current,
      required: required,
    );
  }

  /// Whether this achievement is in progress (not unlocked, but has progress)
  bool get isInProgress => !isUnlocked && progress > 0;

  /// Whether this achievement is locked with no progress
  bool get isLocked => !isUnlocked && progress == 0;

  @override
  String toString() =>
      'Achievement($id: $title, ${isUnlocked ? "Unlocked" : "Locked"}, $progress%)';
}
