import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class WhereToEatApiError extends StatelessWidget {
  const WhereToEatApiError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 60,
          color: AppColors.textPrimaryColor,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 3,
              color: Color.fromARGB(140, 110, 110, 110),
            ),
          ],
        ),
        SizedBox(height: 20),
        WTEText(
          text: "Failed to load restaurants",
          color: AppColors.textPrimaryColor,
          maxLines: 2,
        ),
        SizedBox(height: 10),
        WTEText(
          text: "Please check your",
          color: AppColors.textPrimaryColor,
          fontSize: 24,
        ),
        WTEText(
          text: "connection and try again.",
          color: AppColors.textPrimaryColor,
          fontSize: 24,
        ),
        SizedBox(height: 20),
        WTEText(
          text: "This could be due to your internet connection",
          color: AppColors.textPrimaryColor.withOpacity(0.8),
          fontSize: 14,
          minFontSize: 14,
        ),
        WTEText(
          text: "or an issue with the OpenStreetMap API.",
          color: AppColors.textPrimaryColor.withOpacity(0.8),
          fontSize: 14,
          minFontSize: 14,
        ),
      ],
    );
  }
}
