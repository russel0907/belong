/// XP calculation logic for Belong gamification.
/// Every positive action in the app rewards XP.
class XPCalculator {
  XPCalculator._();

  /// XP for reporting a lost item
  static const int reportLostItem = 10;

  /// XP for reporting a found item
  static const int reportFoundItem = 15;

  /// XP for a potential match being found
  static const int matchFound = 25;

  /// XP for successfully returning an item
  static const int successfulReturn = 50;

  /// XP for helping someone in the community
  static const int helpSomeone = 20;

  /// Base XP for daily login
  static const int dailyLogin = 5;

  /// Streak multiplier (applied to daily login XP)
  static double streakMultiplier(int streakDays) {
    if (streakDays >= 30) return 3.0;
    if (streakDays >= 14) return 2.5;
    if (streakDays >= 7) return 2.0;
    if (streakDays >= 3) return 1.5;
    return 1.0;
  }

  /// Calculate XP for daily login with streak bonus
  static int dailyLoginWithStreak(int streakDays) {
    return (dailyLogin * streakMultiplier(streakDays)).round();
  }

  /// Calculate total XP for a set of actions
  static int calculateTotal(List<int> xpValues) {
    return xpValues.fold(0, (sum, xp) => sum + xp);
  }

  /// Get a human-readable description for an XP source
  static String descriptionForSource(String source) {
    switch (source) {
      case 'report_lost':
        return 'Reported a lost item';
      case 'report_found':
        return 'Reported a found item';
      case 'match_found':
        return 'Potential match found';
      case 'successful_return':
        return 'Successfully returned an item';
      case 'help_someone':
        return 'Helped a community member';
      case 'daily_login':
        return 'Daily login';
      case 'achievement':
        return 'Achievement unlocked';
      default:
        return source;
    }
  }
}
