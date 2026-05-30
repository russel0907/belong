import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/belong_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  int _currentPage = 0;

  final _pages = [
    _OnboardingPageData(
      icon: Icons.search_rounded,
      title: 'Lost something?\nWe\'ve got you.',
      subtitle:
          'Report your lost item and our community will help you find it. Thousands of items are reunited every day.',
      color: AppColors.primary,
    ),
    _OnboardingPageData(
      icon: Icons.favorite_rounded,
      title: 'Found something?\nHelp someone.',
      subtitle:
          'Found an item? A quick report can make someone\'s day. Kindness spreads through every return.',
      color: AppColors.secondary,
    ),
    _OnboardingPageData(
      icon: Icons.diversity_3_rounded,
      title: 'Join the\ncommunity.',
      subtitle:
          'Belong brings neighbors together. Every reunion starts with a single report. Be part of the story.',
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  _animController.reset();
                  _animController.forward();
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: _pages[index],
                    animation: _animController,
                  );
                },
              ),
            ),
            // Bottom section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _PageIndicator(
                        isActive: index == _currentPage,
                        color: _pages[index].color,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // CTA Button
                  BelongButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final AnimationController animation;

  const _OnboardingPage({required this.data, required this.animation});

  @override
  Widget build(BuildContext context) {
    final anim = animation;
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return Opacity(
          opacity: anim.value,
          child: Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, (1 - anim.value) * 30, 0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(data.icon, size: 56, color: data.color),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Title
            Text(
              data.title,
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            // Subtitle
            Text(
              data.subtitle,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _PageIndicator({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : AppColors.outline,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
