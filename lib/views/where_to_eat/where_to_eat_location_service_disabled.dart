import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/wte_button.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WhereToEatLocationServiceDisabled extends StatelessWidget {
  const WhereToEatLocationServiceDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
            text: "Location Service",
            color: AppColors.textPrimaryColor,
          ),
          WTEText(
            text: "Is Disabled",
            color: AppColors.textPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: WTEButton(
                text: "Enable Location Service",
                textColor: AppColors.textSecondaryColor,
                gradientColors: [
                  AppColors.whereToEatButtonPrimaryColor,
                  AppColors.whereToEatButtonSecondaryColor
                ],
                onTap: () {
                  Geolocator.openLocationSettings();
                }),
          ),
        ],
      ),
    );
  }
}
