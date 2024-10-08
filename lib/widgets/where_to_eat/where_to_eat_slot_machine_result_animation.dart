import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WhereToEatSlotMachineResultAnimation extends StatefulWidget {
  final String finalRestaurantName;
  final Duration animationDuration;

  const WhereToEatSlotMachineResultAnimation({
    super.key,
    required this.finalRestaurantName,
    required this.animationDuration,
  });

  @override
  State<WhereToEatSlotMachineResultAnimation> createState() =>
      _WhereToEatSlotMachineResultAnimationState();
}

class _WhereToEatSlotMachineResultAnimationState
    extends State<WhereToEatSlotMachineResultAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _paddingAnimation;
  late Animation<double> _fontSizeAnimation;

  double _nameTextHeight = 0.0;
  final GlobalKey _nameTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, -0.7),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _paddingAnimation = Tween<double>(
      begin: 60.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fontSizeAnimation = Tween<double>(
      begin: 16.0,
      end: 28.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward().then((_) {
      Future.delayed(Duration(milliseconds: 1500), () {
        if (mounted) {
          _measureTextSize();
          Provider.of<WhereToEatModel>(context, listen: false)
            ..setNameTextHeight(_nameTextHeight)
            ..setWhereToEatScreenState(WhereToEatScreenState.result);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _measureTextSize() {
    if (_nameTextKey.currentContext != null && mounted) {
      final RenderBox renderBox =
          _nameTextKey.currentContext!.findRenderObject() as RenderBox;

      if (renderBox.hasSize) {
        setState(() {
          _nameTextHeight = renderBox.size.height;
        });
      }
    }
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
                      key: _nameTextKey,
                      text: widget.finalRestaurantName,
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
