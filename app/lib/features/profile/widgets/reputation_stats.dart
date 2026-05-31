import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/animations/animated_counter.dart';
import '../../../core/gamification/providers/gamification_provider.dart';
import '../../../core/gamification/models/reputation.dart';

/// Detailed reputation statistics for the profile screen.
/// Shows helper points, trust score, contributor level, and streaks.
class ReputationStats extends ConsumerWidget {
  const ReputationStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final reputation = gamification.reputation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reputation',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Main stats card
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.outline, width: 0.5),
          ),
          child: Column(
            children: [
              // Helper Points + Contributor Level
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Helper Points',
                      value: reputation.helperPoints,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.outline.withValues(alpha: 0.5),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Contributor',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              CommunityReputation.levelColor(
                                reputation.contributorLevel,
                              ),
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Text(
                            reputation.contributorLevel,
                            style: AppTypography.labelLarge.copyWith(
                              color: Color(
                                CommunityReputation.levelColor(
                                  reputation.contributorLevel,
                                ),
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              // Trust Score + Streaks
              Row(
                children: [
                  Expanded(
                    child: _buildTrustScore(reputation.trustedFinderScore),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.outline.withValues(alpha: 0.5),
                  ),
                  Expanded(
                    child: _StreakItem(
                      current: reputation.currentStreak,
                      longest: reputation.longestStreak,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrustScore(double score) {
    final fullStars = score.floor();
    final hasHalfStar = score - fullStars >= 0.5;

    return Column(
      children: [
        Text(
          'Trust Score',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          score.toStringAsFixed(1),
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.accent,
              );
            } else if (index == fullStars && hasHalfStar) {
              return const Icon(
                Icons.star_half_rounded,
                size: 14,
                color: AppColors.accent,
              );
            }
            return Icon(
              Icons.star_outline_rounded,
              size: 14,
              color: AppColors.textTertiary,
            );
          }),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: AppSpacing.xxs),
        AnimatedCounter(
          target: value,
          duration: const Duration(milliseconds: 1000),
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _StreakItem extends StatelessWidget {
  final int current;
  final int longest;

  const _StreakItem({required this.current, required this.longest});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          size: 20,
          color: current >= 3 ? AppColors.accent : AppColors.textTertiary,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '$current',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Current',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 1,
              height: 24,
              color: AppColors.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              children: [
                Text(
                  '$longest',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Best',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
