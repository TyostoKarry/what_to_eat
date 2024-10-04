import 'package:flutter/material.dart';

import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatLoading extends StatelessWidget {
  const WhereToEatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 3.0,
            child: CircularProgressIndicator(
              color: AppColors.textPrimaryColor,
            ),
          ),
          SizedBox(height: 100),
          WTEText(
            text: "Searching For",
            color: AppColors.textPrimaryColor,
          ),
          WTEText(
            text: "Nearby Restaurants",
            color: AppColors.textPrimaryColor,
          ),
        ],
      ),
    );
  }
}
