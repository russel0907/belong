import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/mock_data.dart';
import '../../core/widgets/belong_card.dart';
import '../../core/animations/spring_animations.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/community_impact_card.dart';
import 'widgets/achievement_showcase.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header with greeting
            SliverToBoxAdapter(child: _buildHeader()),
            // Gamification Profile Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: SpringScaleTransition(
                  beginScale: 0.95,
                  child: const ProfileHeaderCard(),
                ),
              ),
            ),
            // Community Impact Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: SpringScaleTransition(
                  beginScale: 0.95,
                  child: const CommunityImpactCard(),
                ),
              ),
            ),
            // Achievement Showcase
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: const AchievementShowcase(),
              ),
            ),
            // Quick Actions
            SliverToBoxAdapter(child: _buildQuickActions()),
            // Section Header
            SliverToBoxAdapter(
              child: _buildSectionHeader('Recent Items', 'See all'),
            ),
            // Recent Items
            SliverToBoxAdapter(child: _buildRecentItems()),
            // Categories
            SliverToBoxAdapter(child: _buildSectionHeader('Categories', null)),
            SliverToBoxAdapter(child: _buildCategories()),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Alex 👋',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Your community is here to help.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          // Notification bell
          GestureDetector(
            onTap: () => context.go('/notifications'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.outline),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              icon: Icons.search_rounded,
              title: 'Report Lost',
              subtitle: 'Something you lost',
              color: AppColors.secondary,
              onTap: () => context.go('/report'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.favorite_rounded,
              title: 'Report Found',
              subtitle: 'Something you found',
              color: AppColors.primary,
              onTap: () => context.go('/report'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: () {},
              child: Text(
                action,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentItems() {
    final items = recentItems.take(5).toList();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _RecentItemCard(item: item),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: ItemCategory.values.map((category) {
          return _CategoryChip(category: category);
        }).toList(),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BelongCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(subtitle, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _RecentItemCard extends StatelessWidget {
  final LostFoundItem item;

  const _RecentItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLost = item.status == ItemStatus.lost;
    final statusColor = isLost ? AppColors.secondary : AppColors.primary;

    return BelongCard(
      onTap: () => context.go('/details/${item.id}'),
      width: 160,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              isLost ? 'Lost' : 'Found',
              style: AppTypography.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Icon
          Icon(item.category.icon, size: 28, color: AppColors.textPrimary),
          const Spacer(),
          // Title
          Text(
            item.title,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          // Location + time
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 12,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  item.location,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            item.timeAgo,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final ItemCategory category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                category.label,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
