import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/gamification/providers/gamification_provider.dart';
import '../../../core/gamification/models/achievement.dart';

/// Achievement showcase carousel showing recently unlocked badges
/// and progress towards the next achievement.
class AchievementShowcase extends ConsumerWidget {
  const AchievementShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final recentAchievements = gamification.recentAchievements;
    final inProgress = gamification.inProgressAchievements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/profile'),
              child: Text(
                'See all',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Achievement badges
        SizedBox(
          height: 72,
          child: recentAchievements.isNotEmpty
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      recentAchievements.length +
                      (inProgress.isNotEmpty ? 1 : 0),
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index < recentAchievements.length) {
                      return _AchievementBadge(
                        achievement: recentAchievements[index],
                      );
                    }
                    // Show next achievement progress
                    return _NextAchievementBadge(achievement: inProgress.first);
                  },
                )
              : _EmptyAchievements(),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: achievement.rarity.backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: achievement.rarity.color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(achievement.icon, size: 20, color: achievement.rarity.color),
          const SizedBox(height: 2),
          Text(
            achievement.title.split(' ').first,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: achievement.rarity.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NextAchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _NextAchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: achievement.progress,
                  strokeWidth: 2,
                  backgroundColor: AppColors.outline.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    achievement.rarity.color,
                  ),
                ),
              ),
              Icon(achievement.icon, size: 12, color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Next',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAchievements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 16,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Report items to earn achievements',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
