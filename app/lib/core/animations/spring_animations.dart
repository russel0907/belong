import 'package:flutter/material.dart';

/// Spring animation presets inspired by Apple's motion design.
/// These provide natural, responsive animations with elastic feel.
class SpringCurves {
  SpringCurves._();

  /// Gentle spring - for subtle UI movements (0.5s settle)
  static const gentle = SpringDescription(
    mass: 1.0,
    stiffness: 180,
    damping: 22,
  );

  /// Snappy spring - for interactive elements (0.3s settle)
  static const snappy = SpringDescription(
    mass: 1.0,
    stiffness: 300,
    damping: 25,
  );

  /// Bouncy spring - for celebratory effects (0.6s settle with overshoot)
  static const bouncy = SpringDescription(
    mass: 1.0,
    stiffness: 150,
    damping: 14,
  );

  /// Smooth spring - for page transitions (0.4s settle)
  static const smooth = SpringDescription(
    mass: 1.0,
    stiffness: 220,
    damping: 24,
  );

  /// Elastic spring - for press feedback (quick, slight overshoot)
  static const elastic = SpringDescription(
    mass: 1.0,
    stiffness: 400,
    damping: 20,
  );

  /// Heavy spring - for large elements (slower, more weight)
  static const heavy = SpringDescription(
    mass: 2.5,
    stiffness: 200,
    damping: 28,
  );
}

/// Creates a spring-based animation controller.
/// Returns an AnimationController configured with spring physics.
AnimationController createSpringController(
  TickerProvider vsync, {
  SpringDescription spring = SpringCurves.snappy,
}) {
  return AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 500),
  );
}

/// A widget that applies a spring scale effect on press.
/// Wraps any child with press-scale animation.
class SpringPressEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleAmount;
  final SpringDescription spring;

  const SpringPressEffect({
    super.key,
    required this.child,
    this.onTap,
    this.scaleAmount = 0.97,
    this.spring = SpringCurves.elastic,
  });

  @override
  State<SpringPressEffect> createState() => _SpringPressEffectState();
}

class _SpringPressEffectState extends State<SpringPressEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = _controller.drive(
      Tween<double>(begin: 1.0, end: widget.scaleAmount),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

/// A spring-based scale transition for widgets entering the screen.
class SpringScaleTransition extends StatefulWidget {
  final Widget child;
  final SpringDescription spring;
  final double beginScale;
  final bool animate;

  const SpringScaleTransition({
    super.key,
    required this.child,
    this.spring = SpringCurves.gentle,
    this.beginScale = 0.95,
    this.animate = true,
  });

  @override
  State<SpringScaleTransition> createState() => _SpringScaleTransitionState();
}

class _SpringScaleTransitionState extends State<SpringScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = _controller.drive(
      Tween<double>(begin: widget.beginScale, end: 1.0),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SpringScaleTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Opacity(opacity: _animation.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}

/// A spring-based slide transition for widgets entering the screen.
class SpringSlideTransition extends StatefulWidget {
  final Widget child;
  final SpringDescription spring;
  final Offset beginOffset;
  final bool animate;

  const SpringSlideTransition({
    super.key,
    required this.child,
    this.spring = SpringCurves.smooth,
    this.beginOffset = const Offset(0, 0.1),
    this.animate = true,
  });

  @override
  State<SpringSlideTransition> createState() => _SpringSlideTransitionState();
}

class _SpringSlideTransitionState extends State<SpringSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = _controller.drive(
      Tween<Offset>(begin: widget.beginOffset, end: Offset.zero),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SpringSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value * MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: 1.0 - (_animation.value.dy.abs() * 2).clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// A staggered animation helper that animates children one after another.
class StaggerAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final SpringDescription spring;
  final Axis axis;

  const StaggerAnimation({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.spring = SpringCurves.gentle,
    this.axis = Axis.vertical,
  });

  @override
  State<StaggerAnimation> createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          widget.staggerDelay * widget.children.length +
          const Duration(milliseconds: 400),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.children.length, (index) {
        final delay = widget.staggerDelay * index;
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay.inMilliseconds / _controller.duration!.inMilliseconds,
            1.0,
            curve: Curves.easeOutCubic,
          ),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final t = animation.value;
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: widget.axis == Axis.vertical
                    ? Offset(0, (1 - t) * 20)
                    : Offset((1 - t) * 20, 0),
                child: child,
              ),
            );
          },
          child: widget.children[index],
        );
      }),
    );
  }
}
