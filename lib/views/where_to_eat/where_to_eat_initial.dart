import 'package:flutter/material.dart';

import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatInitial extends StatelessWidget {
  const WhereToEatInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
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
            Icon(
              Icons.storefront,
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
          ],
        ),
        SizedBox(height: 20),
        WTEText(
          text: "Search For",
          color: AppColors.textPrimaryColor,
        ),
        WTEText(
          text: "Restaurants Near You",
          color: AppColors.textPrimaryColor,
        ),
      ],
    );
  }
}
