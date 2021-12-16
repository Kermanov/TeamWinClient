import 'package:flutter/material.dart';

class ThrobbingWidget extends StatefulWidget {
  final Duration duration;
  final double minSize;
  final double maxSize;
  final Widget child;

  ThrobbingWidget({
    @required this.duration,
    @required this.minSize,
    @required this.maxSize,
    @required this.child,
  });

  @override
  _ThrobbingWidgetState createState() => _ThrobbingWidgetState();
}

class _ThrobbingWidgetState extends State<ThrobbingWidget>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    Animation<double> curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
    _animation = Tween(
      begin: widget.minSize,
      end: widget.maxSize,
    ).animate(curve);
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
    );
  }
}
