import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/gamification/providers/gamification_provider.dart';

/// A streak indicator showing the user's current activity streak.
/// Inspired by Duolingo's streak but with a professional, minimal design.
class StreakIndicator extends ConsumerWidget {
  const StreakIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final reputation = gamification.reputation;
    final streak = reputation.currentStreak;
    final isActive = streak > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: isActive && streak >= 3
            ? LinearGradient(
                colors: [
                  AppColors.accentContainer,
                  AppColors.accentContainer.withValues(alpha: 0.5),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: !isActive || streak < 3 ? AppColors.surfaceVariant : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: isActive && streak >= 3
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 20,
            color: streak >= 3 ? AppColors.accent : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streak day${streak == 1 ? '' : 's'}',
                style: AppTypography.titleSmall.copyWith(
                  color: streak >= 3 ? AppColors.accent : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                streak >= 7
                    ? 'On fire! 🔥'
                    : streak >= 3
                    ? 'Keep going!'
                    : 'Start your streak',
                style: AppTypography.labelSmall.copyWith(
                  color: streak >= 3
                      ? AppColors.accent.withValues(alpha: 0.8)
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
