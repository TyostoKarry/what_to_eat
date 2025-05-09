import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class WTEButton extends StatelessWidget {
  final String text;
  final LinearGradient gradient;
  final Color textColor;
  final VoidCallback onTap;
  final bool colorEnabled;
  final bool splashEnabled;
  final bool tapEnabled;

  const WTEButton({
    required this.text,
    required this.gradient,
    required this.textColor,
    required this.onTap,
    this.colorEnabled = true,
    this.splashEnabled = true,
    this.tapEnabled = true,
    super.key,
  });

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
            gradient: colorEnabled ? gradient : null,
            color: colorEnabled ? null : Colors.grey.withOpacity(0.3),
          ),
          child: InkWell(
            splashColor:
                splashEnabled ? AppColors.splashColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            onTap: tapEnabled ? onTap : null,
            child: Center(
              child: WTEText(
                text: text,
                color: textColor,
                shadowColor: AppColors.textSecondaryShadowColor,
                offset: const Offset(2, 2),
                fontSize: 20,
                minFontSize: 12,
                fontWeight: FontWeight.bold,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
