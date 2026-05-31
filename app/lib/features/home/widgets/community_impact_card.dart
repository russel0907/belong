import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/animations/animated_counter.dart';
import '../../../core/gamification/providers/gamification_provider.dart';

/// Community Impact Card showing key stats with animated counters.
/// Replaces the basic stats row with a premium, animated version.
class CommunityImpactCard extends ConsumerWidget {
  const CommunityImpactCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final reputation = gamification.reputation;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.diversity_3_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Community Impact',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Ranking badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.leaderboard_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '#${reputation.communityRanking}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _ImpactStat(
                  value: reputation.successfulReturns,
                  label: 'Returned',
                  icon: Icons.favorite_rounded,
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _ImpactStat(
                  value: reputation.peopleHelped,
                  label: 'Helped',
                  icon: Icons.diversity_3_rounded,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _ImpactStat(
                  value: (reputation.successRate * 100).round(),
                  label: 'Success',
                  icon: Icons.trending_up_rounded,
                  color: AppColors.accent,
                  suffix: '%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;
  final String? suffix;

  const _ImpactStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedCounter(
          target: value,
          duration: const Duration(milliseconds: 1000),
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          suffix: suffix,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
