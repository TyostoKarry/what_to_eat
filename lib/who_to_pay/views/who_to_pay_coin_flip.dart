import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/who_to_pay/models/who_to_pay_model.dart';

class WhoToPayCoinFlip extends StatefulWidget {
  const WhoToPayCoinFlip({super.key});

  @override
  State<WhoToPayCoinFlip> createState() => _WhoToPayCoinFlipState();
}

class _WhoToPayCoinFlipState extends State<WhoToPayCoinFlip>
    with SingleTickerProviderStateMixin {
  WhoToPayModel? model;
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isFront = true;
  int spinCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_controller.value > 0.5) {
            isFront = false;
          } else {
            isFront = true;
          }
        });
      });
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
    model?.removeListener(_checkSpin);
    _controller.dispose();
    super.dispose();
  }

  void _checkSpin() {
    if (model?.isSpinning == true) {
      _flipCoin();
    }
  }

  void _flipCoin() async {
    spinCount = 7 + Random().nextInt(2);

    if (spinCount % 2 != 0 && !isFront) {
      await _controller.reverse();
    }

    for (int i = 0; i < spinCount; i++) {
      if (i % 2 == 0) {
        await _controller.forward();
      } else {
        await _controller.reverse();
      }
    }

    if (mounted) {
      model?.setSpinning(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(_animation.value),
                  child: isFront ? const CoinFront() : const CoinBack(),
                );
              },
            ),
          ),
        ),
        const WTEText(
          text: 'Select heads or tails',
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
        const WTEText(
          text: 'and flip the coin!',
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
      ],
    );
  }
}

class CoinFront extends StatelessWidget {
  const CoinFront({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.wheelTextShadowColor,
            offset: Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/who_to_pay/coin_heads.png',
      ),
    );
  }
}

class CoinBack extends StatelessWidget {
  const CoinBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.wheelTextShadowColor,
            offset: Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0),
        child: Image.asset(
          'assets/images/who_to_pay/coin_tails.png',
        ),
      ),
    );
  }
}
