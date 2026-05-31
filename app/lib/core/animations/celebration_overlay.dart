import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A premium, tasteful celebration overlay.
/// No confetti, no fireworks - think Apple Wallet pass add animation.
/// Uses subtle radial glows, smooth scale transitions, and elegant reveals.

/// Shows a success checkmark animation (Apple-style).
class SuccessCheckmark extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const SuccessCheckmark({
    super.key,
    this.size = 64,
    this.color = AppColors.success,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<SuccessCheckmark> createState() => _SuccessCheckmarkState();
}

class _SuccessCheckmarkState extends State<SuccessCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );
    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + (0.5 * _scaleAnimation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _CheckPainter(
                progress: _checkAnimation.value,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = size.width * 0.28;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.65;
    final endX = size.width * 0.72;
    final endY = size.height * 0.38;

    // First segment: start to mid
    if (progress <= 0.5) {
      final t = progress / 0.5;
      path.moveTo(startX, startY);
      path.lineTo(startX + (midX - startX) * t, startY + (midY - startY) * t);
    } else {
      final t = (progress - 0.5) / 0.5;
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.moveTo(midX, midY);
      path.lineTo(midX + (endX - midX) * t, midY + (endY - midY) * t);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// A level-up celebration with radial glow and badge reveal.
class LevelUpCelebration extends StatefulWidget {
  final int level;
  final String title;
  final VoidCallback? onDismiss;

  const LevelUpCelebration({
    super.key,
    required this.level,
    required this.title,
    this.onDismiss,
  });

  @override
  State<LevelUpCelebration> createState() => _LevelUpCelebrationState();
}

class _LevelUpCelebrationState extends State<LevelUpCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _badgeAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _badgeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
    );
    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              color: AppColors.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Radial glow ring
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primarySoft,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.2 * _glowAnimation.value,
                        ),
                        blurRadius: 30 * _glowAnimation.value,
                        spreadRadius: 10 * _glowAnimation.value,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: 0.3 + (0.7 * _badgeAnimation.value),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.level}',
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Opacity(
                  opacity: _textAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _textAnimation.value)),
                    child: Column(
                      children: [
                        Text(
                          'Level Up!',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.title,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// An achievement unlock celebration with badge reveal.
class AchievementUnlockCelebration extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int xpReward;
  final VoidCallback? onDismiss;

  const AchievementUnlockCelebration({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color = AppColors.accent,
    this.xpReward = 0,
    this.onDismiss,
  });

  @override
  State<AchievementUnlockCelebration> createState() =>
      _AchievementUnlockCelebrationState();
}

class _AchievementUnlockCelebrationState
    extends State<AchievementUnlockCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ringAnimation;
  late Animation<double> _badgeAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _badgeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
    );
    _contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              color: AppColors.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expanding ring + badge
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Expanding ring
                      Container(
                        width: 40 + (60 * _ringAnimation.value),
                        height: 40 + (60 * _ringAnimation.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.color.withValues(
                              alpha: 0.3 * (1 - _ringAnimation.value),
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                      // Badge icon
                      Transform.scale(
                        scale: 0.3 + (0.7 * _badgeAnimation.value),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: widget.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Title and description
                Opacity(
                  opacity: _contentAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - _contentAnimation.value)),
                    child: Column(
                      children: [
                        Text(
                          'Achievement Unlocked',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.title,
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          widget.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.xpReward > 0) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull,
                              ),
                            ),
                            child: Text(
                              '+${widget.xpReward} XP',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A floating XP gain indicator that drifts up and fades.
class XPGainIndicator extends StatefulWidget {
  final int xp;
  final String? reason;
  final Color color;

  const XPGainIndicator({
    super.key,
    required this.xp,
    this.reason,
    this.color = AppColors.primary,
  });

  @override
  State<XPGainIndicator> createState() => _XPGainIndicatorState();
}

class _XPGainIndicatorState extends State<XPGainIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value * 15,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: widget.color),
                  const SizedBox(width: 4),
                  Text(
                    '+${widget.xp} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                    ),
                  ),
                  if (widget.reason != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      widget.reason!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: widget.color.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A modal overlay that shows a celebration with a backdrop blur.
/// Used for level-ups and achievement unlocks.
class CelebrationModal extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const CelebrationModal({super.key, required this.child, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.4),
        body: Center(
          child: GestureDetector(
            onTap: onDismiss,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
