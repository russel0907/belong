/// Represents a user's community reputation.
/// This is the professional, LinkedIn-style reputation system.
class CommunityReputation {
  final int helperPoints;
  final double trustedFinderScore; // 0.0 to 5.0
  final String contributorLevel;
  final int successfulReturns;
  final int currentStreak;
  final int longestStreak;
  final int peopleHelped;
  final int communityRanking; // 1-based, lower is better

  const CommunityReputation({
    this.helperPoints = 0,
    this.trustedFinderScore = 0.0,
    this.contributorLevel = 'Bronze',
    this.successfulReturns = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.peopleHelped = 0,
    this.communityRanking = 1,
  });

  /// Get the contributor level based on helper points
  static String levelForPoints(int points) {
    if (points >= 10000) return 'Platinum';
    if (points >= 5000) return 'Gold';
    if (points >= 1000) return 'Silver';
    return 'Bronze';
  }

  /// Get the color hex for the contributor level
  static int levelColor(String level) {
    switch (level) {
      case 'Platinum':
        return 0xFF94A3B8;
      case 'Gold':
        return 0xFFD97706;
      case 'Silver':
        return 0xFF78716C;
      case 'Bronze':
        return 0xFFB45309;
      default:
        return 0xFF78716C;
    }
  }

  /// Create a copy with updated fields
  CommunityReputation copyWith({
    int? helperPoints,
    double? trustedFinderScore,
    String? contributorLevel,
    int? successfulReturns,
    int? currentStreak,
    int? longestStreak,
    int? peopleHelped,
    int? communityRanking,
  }) {
    return CommunityReputation(
      helperPoints: helperPoints ?? this.helperPoints,
      trustedFinderScore: trustedFinderScore ?? this.trustedFinderScore,
      contributorLevel: contributorLevel ?? this.contributorLevel,
      successfulReturns: successfulReturns ?? this.successfulReturns,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      peopleHelped: peopleHelped ?? this.peopleHelped,
      communityRanking: communityRanking ?? this.communityRanking,
    );
  }

  /// Success rate as a percentage (0.0 to 1.0)
  double get successRate {
    final total = successfulReturns + (helperPoints ~/ 10);
    if (total == 0) return 0.0;
    return (successfulReturns / total).clamp(0.0, 1.0);
  }

  @override
  String toString() =>
      'CommunityReputation(points: $helperPoints, level: $contributorLevel, '
      'score: $trustedFinderScore, returns: $successfulReturns, '
      'streak: $currentStreak, ranking: #$communityRanking)';
}
