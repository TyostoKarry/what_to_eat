import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class WTESafeArea extends StatelessWidget {
  final Widget child;

  const WTESafeArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.safeAreaBackgroundColor,
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: child,
      ),
    );
  }
}
