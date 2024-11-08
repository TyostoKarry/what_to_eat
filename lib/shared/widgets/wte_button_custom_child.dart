import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';

class WTEButtonCustomChild extends StatelessWidget {
  final double width;
  final double height;
  final Gradient backgroundGradient;
  final Color disabledColor;
  final VoidCallback onTap;
  final bool isEnabled;
  final Widget child;

  const WTEButtonCustomChild({
    this.width = 60,
    this.height = 60,
    required this.backgroundGradient,
    required this.disabledColor,
    required this.onTap,
    this.isEnabled = true,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled ? backgroundGradient : null,
        color: isEnabled ? null : disabledColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isEnabled
            ? <BoxShadow>[
                const BoxShadow(
                  color: AppColors.textPrimaryShadowColor,
                  offset: Offset(2, 2),
                  blurRadius: 3,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: AppColors.splashColor,
          onTap: isEnabled ? onTap : null,
          child: child,
        ),
      ),
    );
  }
}
