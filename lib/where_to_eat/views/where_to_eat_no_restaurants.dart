import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class WhereToEatNoRestaurants extends StatelessWidget {
  const WhereToEatNoRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_off,
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
          text: "No Restaurants",
          color: AppColors.textPrimaryColor,
        ),
        WTEText(
          text: "Found Near You",
          color: AppColors.textPrimaryColor,
        ),
        SizedBox(height: 10),
        WTEText(
          text: "Consider expanding your",
          color: AppColors.textPrimaryColor,
          fontSize: 18,
          minFontSize: 18,
        ),
        WTEText(
          text: "search criteria down below",
          color: AppColors.textPrimaryColor,
          fontSize: 18,
          minFontSize: 18,
        ),
      ],
    );
  }
}
