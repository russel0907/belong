import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/animations/animated_progress.dart';
import '../../../core/gamification/providers/gamification_provider.dart';
import '../../../core/gamification/models/achievement.dart';

/// Full achievement grid for the profile screen.
/// Shows all achievements with their unlock status and progress.
class AchievementGrid extends ConsumerWidget {
  const AchievementGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final achievements = gamification.achievements;
    final unlockedCount = gamification.unlockedAchievements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$unlockedCount/${achievements.length}',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Overall progress
        AnimatedProgressBar(
          progress: achievements.isEmpty
              ? 0.0
              : unlockedCount / achievements.length,
          height: 4,
          gradientColors: [AppColors.primaryLight, AppColors.primary],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Achievement grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _AchievementTile(achievement: achievements[index]);
          },
        ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    final rarity = achievement.rarity;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isUnlocked ? rarity.backgroundColor : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isUnlocked
              ? rarity.color.withValues(alpha: 0.3)
              : AppColors.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? rarity.color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              achievement.icon,
              size: 18,
              color: isUnlocked ? rarity.color : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement.title,
                  style: AppTypography.labelMedium.copyWith(
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                    fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isUnlocked && achievement.required > 1) ...[
                  const SizedBox(height: 2),
                  AnimatedProgressBar(
                    progress: achievement.progress,
                    height: 3,
                    color: rarity.color,
                    backgroundColor: AppColors.outline.withValues(alpha: 0.2),
                  ),
                ],
                if (isUnlocked) ...[
                  const SizedBox(height: 2),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: rarity.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
