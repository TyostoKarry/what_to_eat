import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_safe_area.dart';

class WTESplitScreenAnimation extends StatefulWidget {
  final bool expandLeft;

  const WTESplitScreenAnimation({
    required this.expandLeft,
    super.key,
  });

  @override
  WTESplitScreenAnimationState createState() => WTESplitScreenAnimationState();
}

class WTESplitScreenAnimationState extends State<WTESplitScreenAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // Create an animation from 0.5 (split screen) to 1.0 (one side full)
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WTESafeArea(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor:
                  widget.expandLeft ? _animation.value : 1 - _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.getWhatToEatBackground(),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor:
                  widget.expandLeft ? 1 - _animation.value : _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.getWhereToEatBackground(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
