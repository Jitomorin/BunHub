import 'package:flutter/material.dart';

class HeartAnim extends StatefulWidget {
  final bool isAnimating;
  final bool smallLike;
  final VoidCallback? onEnd;

  final Widget child;
  final Duration duration;

  const HeartAnim({
    Key? key,
    required this.isAnimating,
    required this.child,
    this.onEnd,
    this.smallLike = false,
    this.duration = const Duration(milliseconds: 170),
  }) : super(key: key);

  @override
  State<HeartAnim> createState() => _HeartAnimState();
}

class _HeartAnimState extends State<HeartAnim>
    with SingleTickerProviderStateMixin {
  late Animation<double> scale;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant HeartAnim oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      beginAnimation();
    }
  }

  void beginAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await animationController.forward();
      await animationController.reverse();

      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
