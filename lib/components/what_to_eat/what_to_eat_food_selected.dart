import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

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
    final model = context.watch<WhatToEatModel>();
    final selectedFood = model.selectedFood ??
        SelectedFood(foodItem: FoodItem(name: '', description: ''));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhatToEatBackground(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Center(
                child: AutoSizeText(
                  'Today I Will Eat',
                  style: const TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.resultBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AutoSizeText(
                        selectedFood.foodItem.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AutoSizeText(
                    selectedFood.foodItem.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Material(
                  elevation: 4,
                  color: AppColors.whatToEatPrimaryColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    splashColor: AppColors.splashColor,
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _launchGoogleSearch(selectedFood.foodItem.name);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        "Search The Web",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
