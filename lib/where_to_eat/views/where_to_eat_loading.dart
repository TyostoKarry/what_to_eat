import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class WhereToEatLoading extends StatelessWidget {
  const WhereToEatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 3.0,
            child: const CircularProgressIndicator(
              color: AppColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 100),
          const WTEText(
            text: "Searching For",
            color: AppColors.textPrimaryColor,
          ),
          const WTEText(
            text: "Nearby Restaurants",
            color: AppColors.textPrimaryColor,
          ),
        ],
      ),
    );
  }
}
