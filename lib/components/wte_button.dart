import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class WTEButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onTap;
  final bool colorEnabled;
  final bool splashEnabled;
  final bool tapEnabled;
  final List<Color> gradientColors;

  const WTEButton({
    required this.text,
    required this.textColor,
    required this.onTap,
    this.colorEnabled = true,
    this.splashEnabled = true,
    this.tapEnabled = true,
    this.gradientColors = const [
      AppColors.whatToEatButtonPrimaryColor,
      AppColors.whatToEatButtonSecondaryColor
    ],
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        elevation: colorEnabled ? 4 : 0,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: colorEnabled
                ? LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: colorEnabled ? null : Colors.grey.withOpacity(0.3),
          ),
          child: InkWell(
            splashColor:
                splashEnabled ? AppColors.splashColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            onTap: tapEnabled ? onTap : null,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: AppColors.textSecondaryShadowColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
