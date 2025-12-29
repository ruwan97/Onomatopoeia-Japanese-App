import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Curve curve;
  final bool fadeIn;
  final Offset offset;

  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = 0,
    this.curve = Curves.easeOut,
    this.fadeIn = true,
    this.offset = Offset.zero,
  });

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(
      begin: widget.fadeIn ? 0.0 : 1.0,
      end: widget.fadeIn ? 1.0 : 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _offset = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    // Start animation after delay
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _offset.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StaggeredFadeAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final int delayBetween;
  final Curve curve;
  final Axis direction;

  const StaggeredFadeAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.delayBetween = 100,
    this.curve = Curves.easeOut,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(
        children: List.generate(children.length, (index) {
          return Expanded(
            child: FadeAnimation(
              duration: duration,
              delay: index * delayBetween,
              curve: curve,
              child: children[index],
            ),
          );
        }),
      );
    }

    return Column(
      children: List.generate(children.length, (index) {
        return FadeAnimation(
          duration: duration,
          delay: index * delayBetween,
          curve: curve,
          child: children[index],
        );
      }),
    );
  }
}

class FadeInUp extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Curve curve;

  const FadeInUp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = 0,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      duration: duration,
      delay: delay,
      curve: curve,
      offset: const Offset(0, 20),
      child: child,
    );
  }
}

class FadeInDown extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Curve curve;

  const FadeInDown({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = 0,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      duration: duration,
      delay: delay,
      curve: curve,
      offset: const Offset(0, -20),
      child: child,
    );
  }
}

class FadeInLeft extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Curve curve;

  const FadeInLeft({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = 0,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      duration: duration,
      delay: delay,
      curve: curve,
      offset: const Offset(20, 0),
      child: child,
    );
  }
}

class FadeInRight extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Curve curve;

  const FadeInRight({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = 0,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      duration: duration,
      delay: delay,
      curve: curve,
      offset: const Offset(-20, 0),
      child: child,
    );
  }
}