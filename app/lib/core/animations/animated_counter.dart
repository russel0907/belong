import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A premium animated number counter.
/// Counts from 0 to target value with smooth easing.
/// Inspired by Apple Wallet transaction counters and Duolingo XP.
class AnimatedCounter extends StatefulWidget {
  final int target;
  final int? begin;
  final Duration duration;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final bool animate;
  final Curve curve;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.begin,
    this.duration = const Duration(milliseconds: 800),
    this.style,
    this.prefix,
    this.suffix,
    this.animate = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _displayValue = widget.begin ?? 0;
    _controller.addListener(_updateValue);
    if (widget.animate) {
      _controller.forward();
    } else {
      _displayValue = widget.target;
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.target != oldWidget.target) {
      _controller.forward(from: 0);
    }
  }

  void _updateValue() {
    final begin = widget.begin ?? 0;
    final range = widget.target - begin;
    setState(() {
      _displayValue = begin + (range * _animation.value).round();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateValue);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = '${widget.prefix ?? ""}$_displayValue${widget.suffix ?? ""}';
    return Text(text, style: widget.style ?? AppTypography.headlineMedium);
  }
}

/// An animated counter that shows a "+N" or "-N" delta animation.
/// Floats up and fades out, like gaining XP in a game.
class FloatingDelta extends StatefulWidget {
  final int delta;
  final String? prefix;
  final Color? color;
  final IconData? icon;

  const FloatingDelta({
    super.key,
    required this.delta,
    this.prefix,
    this.color,
    this.icon,
  });

  @override
  State<FloatingDelta> createState() => _FloatingDeltaState();
}

class _FloatingDeltaState extends State<FloatingDelta>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      reverseCurve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
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
    final isPositive = widget.delta >= 0;
    final sign = isPositive ? '+' : '';
    final color =
        widget.color ?? (isPositive ? AppColors.success : AppColors.error);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value * 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 14, color: color),
                  const SizedBox(width: 2),
                ],
                Text(
                  '$sign${widget.delta}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.01,
                  ),
                ),
                if (widget.prefix != null) ...[
                  const SizedBox(width: 2),
                  Text(
                    widget.prefix!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: color.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// An animated stat counter that combines a label with an animated number.
class AnimatedStatCounter extends StatelessWidget {
  final int value;
  final String label;
  final IconData? icon;
  final Color? color;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final Duration duration;

  const AnimatedStatCounter({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color,
    this.valueStyle,
    this.labelStyle,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    final statColor = color ?? AppColors.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: statColor),
          const SizedBox(height: 4),
        ],
        AnimatedCounter(
          target: value,
          duration: duration,
          style:
              valueStyle ??
              AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style:
              labelStyle ??
              AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
