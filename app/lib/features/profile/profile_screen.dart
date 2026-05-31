import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/spring_animations.dart';
import 'widgets/level_progress_card.dart';
import 'widgets/reputation_stats.dart';
import 'widgets/achievement_grid.dart';
import 'widgets/contribution_timeline.dart';

/// Enhanced profile screen with full gamification integration.
/// Shows level, reputation, achievements, and activity timeline.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(child: _buildAppBar(context, ref)),
            // Level Progress Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: SpringSlideTransition(
                  beginOffset: const Offset(0, 0.1),
                  child: const LevelProgressCard(),
                ),
              ),
            ),
            // Reputation Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: SpringSlideTransition(
                  beginOffset: const Offset(0, 0.1),
                  child: const ReputationStats(),
                ),
              ),
            ),
            // Achievement Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: SpringSlideTransition(
                  beginOffset: const Offset(0, 0.1),
                  child: const AchievementGrid(),
                ),
              ),
            ),
            // Contribution Timeline
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: SpringSlideTransition(
                  beginOffset: const Offset(0, 0.1),
                  child: const ContributionTimeline(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Title
          Text(
            'Profile',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Settings button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(
                Icons.settings_outlined,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
