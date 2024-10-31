import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/who_to_pay/models/who_to_pay_model.dart';

class WhoToPayArrowWheel extends StatefulWidget {
  const WhoToPayArrowWheel({super.key});

  @override
  State<WhoToPayArrowWheel> createState() => _WhoToPayArrowWheelState();
}

class _WhoToPayArrowWheelState extends State<WhoToPayArrowWheel>
    with SingleTickerProviderStateMixin {
  WhoToPayModel? model;
  late AnimationController _controller;
  late Animation<double> _animation;
  final Duration _animationDuration = const Duration(seconds: 5);
  double _currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final WhoToPayModel newModel =
        Provider.of<WhoToPayModel>(context, listen: false);

    if (model != newModel) {
      model?.removeListener(_checkSpin);
      model = newModel;
      model?.addListener(_checkSpin);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    model?.removeListener(_checkSpin);
    super.dispose();
  }

  void _checkSpin() {
    if (model?.isSpinning == true) {
      _spinArrow();

      Future<void>.delayed(_animationDuration, () {
        if (mounted) {
          model?.setSpinning(false);
        }
      });
    }
  }

  void _spinArrow() {
    final Random random = Random();
    double additionalSpins = 10 + random.nextDouble();
    double targetAngle = _currentAngle + (2 * pi * additionalSpins);

    _animation = Tween<double>(begin: _currentAngle, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint),
    );
    _controller.reset();
    _controller.forward();

    _currentAngle = targetAngle % (2 * pi);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whoToPayButtonPrimaryColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.wheelTextShadowColor,
                    offset: Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _animation.value,
                          child: LayoutBuilder(
                            builder: (
                              BuildContext context,
                              BoxConstraints constraints,
                            ) {
                              return Icon(
                                Icons.trending_flat,
                                color: AppColors.textPrimaryColor,
                                size: constraints.biggest.width,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(3, 0),
                                    blurRadius: 6,
                                    color: AppColors.wheelTextShadowColor,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.whoToPayButtonSecondaryColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.wheelTextShadowColor,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const WTEText(
          text: 'Place the phone on a flat surface and',
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
        const WTEText(
          text: 'see who the arrow picks to pay!',
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
      ],
    );
  }
}
