import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class WTEButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final bool colorEnabled;
  final bool splashEnabled;
  final bool tapEnabled;

  const WTEButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.colorEnabled = true,
    this.splashEnabled = true,
    this.tapEnabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Material(
        color: colorEnabled ? color : color.withOpacity(0.3),
        elevation: colorEnabled ? 4 : 0,
        borderRadius: BorderRadius.circular(12),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
