import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class WhereToEatLocationError extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String buttonText;
  final VoidCallback onTap;

  const WhereToEatLocationError({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.location_off,
            size: 60,
            color: AppColors.textPrimaryColor,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 3,
                color: Color.fromARGB(140, 110, 110, 110),
              ),
            ],
          ),
          const SizedBox(height: 20),
          WTEText(
            text: titleText,
            color: AppColors.textPrimaryColor,
          ),
          WTEText(
            text: subtitleText,
            color: AppColors.textPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: WTEButton(
              text: buttonText,
              textColor: AppColors.textSecondaryColor,
              gradientColors: const <Color>[
                AppColors.whereToEatButtonPrimaryColor,
                AppColors.whereToEatButtonSecondaryColor,
              ],
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
