import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/shared/widgets/wte_view_title.dart';

class WhatToEatFoodSelected extends StatelessWidget {
  const WhatToEatFoodSelected({super.key});

  Future<void> _launchGoogleSearch(String query) async {
    final Uri searchUrl = Uri.parse(
        'https://www.google.com/search?q=${Uri.encodeComponent(query)}');

    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final WhatToEatModel model = context.watch<WhatToEatModel>();
    final SelectedFood selectedFood = model.selectedFood ??
        const SelectedFood(
            foodItem: FoodItem(name: '', image: '', description: ''));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhatToEatBackground(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const WTEViewTitle(
              titleText: 'Today I Will Eat',
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/images/${selectedFood.foodItem.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.foodItemBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: WTEText(
                        text: selectedFood.foodItem.name,
                        color: AppColors.textPrimaryColor,
                        shadowColor: AppColors.textPrimaryShadowColor,
                        offset: const Offset(2, 2),
                        fontSize: 20,
                        minFontSize: 12,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                if (selectedFood.foodItem.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 155,
                      child: SingleChildScrollView(
                        child: WTEText(
                          text: selectedFood.foodItem.description,
                          color: AppColors.textPrimaryColor,
                          shadowColor: Colors.transparent,
                          fontSize: 18,
                          minFontSize: 18,
                          maxLines: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: WTEButton(
                text: "Search The Web",
                textColor: AppColors.textSecondaryColor,
                onTap: () {
                  _launchGoogleSearch(selectedFood.foodItem.name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
