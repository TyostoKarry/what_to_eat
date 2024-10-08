import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WhereToEatSlotMachineScrollAnimation extends StatefulWidget {
  final String restaurantName;
  final Duration animationDuration;
  final int delayBetweenItems;
  final int index;
  final int totalItems;

  const WhereToEatSlotMachineScrollAnimation({
    Key? key,
    required this.restaurantName,
    required this.animationDuration,
    required this.delayBetweenItems,
    required this.index,
    required this.totalItems,
  }) : super(key: key);

  @override
  State<WhereToEatSlotMachineScrollAnimation> createState() =>
      _WhereToEatSlotMachineScrollAnimationState();
}

class _WhereToEatSlotMachineScrollAnimationState
    extends State<WhereToEatSlotMachineScrollAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _paddingAnimation;
  late Animation<double> _fontSizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, -0.7),
      end: Offset(0, 0.7),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _paddingAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 60.0, end: 20.0), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 20.0, end: 60.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fontSizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 16.0, end: 32.0), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 32.0, end: 16.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(
        Duration(milliseconds: widget.index * widget.delayBetweenItems), () {
      if (mounted) {
        _controller.forward();
      }
    });
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
        return Transform.translate(
          offset: _positionAnimation.value * 200,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: _paddingAnimation.value),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.getWhereToEatResultBackground(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: WTEText(
                      text: widget.restaurantName,
                      fontSize: _fontSizeAnimation.value,
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
