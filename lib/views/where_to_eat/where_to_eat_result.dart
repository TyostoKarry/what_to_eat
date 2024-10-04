import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_text.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatResult extends StatelessWidget {
  final List<dynamic> restaurants;
  const WhereToEatResult({Key? key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WTEText(
          text: restaurants[model.resultIndex]['tags']['name'],
          color: AppColors.textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        if (restaurants[model.resultIndex]['tags']['addr:street'] != null &&
            restaurants[model.resultIndex]['tags']['addr:housenumber'] != null)
          WTEText(
            text:
                "${restaurants[model.resultIndex]['tags']['addr:street']}, ${restaurants[model.resultIndex]['tags']['addr:housenumber']}",
            color: AppColors.textPrimaryColor,
          ),
        if (restaurants[model.resultIndex]['tags']['cuisine'] != null)
          WTEText(
            text: restaurants[model.resultIndex]['tags']['cuisine'],
            color: AppColors.textPrimaryColor,
          ),
        if (restaurants[model.resultIndex]['tags']['phone'] != null)
          WTEText(
            text: restaurants[model.resultIndex]['tags']['phone'],
            color: AppColors.textPrimaryColor,
          ),
        if (restaurants[model.resultIndex]['tags']['website'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: WTEButton(
              text: "Visit Restaurants Website",
              textColor: AppColors.textSecondaryColor,
              onTap: () {},
              gradientColors: [
                AppColors.whereToEatButtonPrimaryColor,
                AppColors.whereToEatButtonSecondaryColor
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: WTEButton(
              text: "Search The Restaurant On Google",
              textColor: AppColors.textSecondaryColor,
              onTap: () {},
              gradientColors: [
                AppColors.whereToEatButtonPrimaryColor,
                AppColors.whereToEatButtonSecondaryColor
              ],
            ),
          ),
      ],
    );
  }
}
