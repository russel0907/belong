import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/animations/animated_progress.dart';
import '../../../core/animations/animated_counter.dart';
import '../../../core/gamification/providers/gamification_provider.dart';

/// Large level progress card for the profile screen.
/// Shows level number, XP progress, and milestone markers.
class LevelProgressCard extends ConsumerWidget {
  const LevelProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final level = gamification.level;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline, width: 0.5),
      ),
      child: Column(
        children: [
          // Level circle with XP
          Row(
            children: [
              // Large level indicator
              _buildLevelCircle(level.level),
              const SizedBox(width: AppSpacing.lg),
              // Level info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${level.level}',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      level.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // XP text
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        AnimatedCounter(
                          target: level.currentXP,
                          duration: const Duration(milliseconds: 1200),
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' / ${level.xpToNextLevel} XP',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // XP Progress bar
          AnimatedProgressBar(
            progress: level.progress,
            height: 8,
            gradientColors: [
              AppColors.primaryLight,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            borderRadius: 4,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Milestone markers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MilestoneLabel(
                level: level.level,
                isReached: true,
                label: 'Current',
              ),
              _MilestoneLabel(
                level: _nextMilestone(level.level),
                isReached: false,
                label: 'Next milestone',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCircle(int level) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 3,
              backgroundColor: AppColors.outline.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          // Level number
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(
                '$level',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _nextMilestone(int currentLevel) {
    if (currentLevel < 5) return 5;
    if (currentLevel < 10) return 10;
    if (currentLevel < 25) return 25;
    if (currentLevel < 50) return 50;
    if (currentLevel < 75) return 75;
    return 100;
  }
}

class _MilestoneLabel extends StatelessWidget {
  final int level;
  final bool isReached;
  final String label;

  const _MilestoneLabel({
    required this.level,
    required this.isReached,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isReached ? AppColors.primary : AppColors.outline,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          isReached ? 'Level $level' : 'Level $level',
          style: AppTypography.labelSmall.copyWith(
            color: isReached ? AppColors.textPrimary : AppColors.textTertiary,
            fontWeight: isReached ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
