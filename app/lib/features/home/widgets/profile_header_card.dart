import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/animations/animated_progress.dart';
import '../../../core/gamification/providers/gamification_provider.dart';

/// Profile header card showing user avatar, level, XP progress, and streak.
/// Inspired by Duolingo's profile header but with a professional, premium feel.
class ProfileHeaderCard extends ConsumerWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final level = gamification.level;
    final reputation = gamification.reputation;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline, width: 0.5),
      ),
      child: Row(
        children: [
          // Avatar with level ring
          _buildAvatarWithLevel(level.level),
          const SizedBox(width: AppSpacing.md),
          // User info and progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and level title
                Text(
                  'Alex Morgan',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Level ${level.level} - ${level.title}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // XP Progress bar
                Row(
                  children: [
                    Expanded(
                      child: AnimatedProgressBar(
                        progress: level.progress,
                        height: 4,
                        gradientColors: [
                          AppColors.primaryLight,
                          AppColors.primary,
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${level.currentXP}/${level.xpToNextLevel}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Streak indicator
          _buildStreakBadge(reputation.currentStreak),
        ],
      ),
    );
  }

  Widget _buildAvatarWithLevel(int level) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Level ring
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 2.5,
              backgroundColor: AppColors.outline.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(
                'AM',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: streak >= 3
            ? AppColors.accentContainer
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 18,
            color: streak >= 3 ? AppColors.accent : AppColors.textTertiary,
          ),
          const SizedBox(height: 2),
          Text(
            '$streak',
            style: AppTypography.labelSmall.copyWith(
              color: streak >= 3 ? AppColors.accent : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'day',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
