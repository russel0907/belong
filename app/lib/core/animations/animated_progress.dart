import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A premium animated progress bar with gradient fill.
/// Inspired by Apple Wallet and Duolingo progress indicators.
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final bool animate;
  final Duration duration;
  final double borderRadius;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.gradientColors,
    this.animate = true,
    this.duration = const Duration(milliseconds: 800),
    this.borderRadius = 3,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? AppColors.outline.withValues(alpha: 0.3);
    final barColor = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value * widget.progress.clamp(0.0, 1.0);
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: t,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: widget.gradientColors != null
                        ? LinearGradient(
                            colors: widget.gradientColors!,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: widget.gradientColors != null ? null : barColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A premium animated circular progress indicator.
/// Used for level progress rings and achievement progress.
class AnimatedCircularProgress extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final Widget? child;
  final bool animate;
  final Duration duration;

  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
    this.gradientColors,
    this.child,
    this.animate = true,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? AppColors.outline.withValues(alpha: 0.3);
    final barColor = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value * widget.progress.clamp(0.0, 1.0);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: t,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: bgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

/// A multi-segment progress bar showing milestones.
/// Each segment represents a milestone on the path to the next level.
class MilestoneProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int totalSegments;
  final Color color;
  final Color emptyColor;
  final double height;
  final double gap;

  const MilestoneProgressBar({
    super.key,
    required this.progress,
    this.totalSegments = 5,
    this.color = AppColors.primary,
    this.emptyColor = AppColors.outline,
    this.height = 4,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    final filledSegments = (progress * totalSegments).floor();
    final partialFill = (progress * totalSegments) - filledSegments;

    return Row(
      children: List.generate(totalSegments, (index) {
        final isFilled = index < filledSegments;
        final isPartial = index == filledSegments && partialFill > 0;
        final fillAmount = isFilled ? 1.0 : (isPartial ? partialFill : 0.0);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < totalSegments - 1 ? gap : 0,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              height: height,
              decoration: BoxDecoration(
                color: emptyColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fillAmount,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
