/// Represents a user's level and XP progression.
/// Levels range from 1 to 100.
class UserLevel {
  final int level;
  final int currentXP;
  final int xpToNextLevel;
  final String title;

  const UserLevel({
    required this.level,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.title,
  });

  /// Progress towards next level (0.0 to 1.0)
  double get progress {
    if (xpToNextLevel <= 0) return 1.0;
    return (currentXP / xpToNextLevel).clamp(0.0, 1.0);
  }

  /// Total XP earned to reach this level
  int get totalXP {
    // Sum of XP thresholds from level 1 to current level
    int total = 0;
    for (int i = 1; i < level; i++) {
      total += xpForLevel(i);
    }
    return total + currentXP;
  }

  /// Whether this is the maximum level
  bool get isMaxLevel => level >= 100;

  /// Get the title for a given level
  static String titleForLevel(int level) {
    if (level >= 100) return 'Belong Legend';
    if (level >= 75) return 'Community Guardian';
    if (level >= 50) return 'Neighborhood Hero';
    if (level >= 35) return 'Trusted Pillar';
    if (level >= 25) return 'Community Champion';
    if (level >= 15) return 'Dedicated Helper';
    if (level >= 10) return 'Trusted Helper';
    if (level >= 5) return 'Community Member';
    if (level >= 3) return 'Active Participant';
    return 'Newcomer';
  }

  /// Calculate XP required to reach a specific level
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    // Exponential curve: each level requires more XP
    // Level 2: 100, Level 10: ~1000, Level 25: ~5000, Level 50: ~20000, Level 100: ~100000
    return (100 * level * (1 + (level / 20))).round();
  }

  /// Create a level 1 default state
  static UserLevel get defaultLevel => const UserLevel(
    level: 1,
    currentXP: 0,
    xpToNextLevel: 100,
    title: 'Newcomer',
  );

  @override
  String toString() =>
      'UserLevel(level: $level, XP: $currentXP/$xpToNextLevel, title: $title)';
}
