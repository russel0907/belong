import 'package:flutter/material.dart';

class SharedAxisTransition extends PageTransitionsBuilder {
  final Axis axis;

  const SharedAxisTransition({this.axis = Axis.vertical});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _SharedAxisPageTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      axis: axis,
      child: child,
    );
  }
}

class _SharedAxisPageTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
  final Axis axis;

  const _SharedAxisPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final anim = animation;
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final t = anim.value;
        final opacity = t;
        final transform = switch (axis) {
          Axis.horizontal =>
            Matrix4.identity()..translateByDouble((1 - t) * 40, 0.0, 0.0, 1.0),
          Axis.vertical =>
            Matrix4.identity()..translateByDouble(0.0, (1 - t) * 20, 0.0, 1.0),
        };

        return Opacity(
          opacity: opacity,
          child: Transform(transform: transform, child: child),
        );
      },
      child: child,
    );
  }
}

class BelongAnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const BelongAnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  const FadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class SlideTransitionBuilder extends PageTransitionsBuilder {
  final Axis axis;

  const SlideTransitionBuilder({this.axis = Axis.horizontal});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: axis == Axis.horizontal
            ? const Offset(0.3, 0)
            : const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    );
  }
}
