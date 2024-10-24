import 'package:flutter/material.dart';

import 'package:what_to_eat/what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/shared/theme/app_colors.dart';

class FoodItemsPopup extends StatelessWidget {
  final FoodCategory foodCategory;

  const FoodItemsPopup({
    super.key,
    required this.foodCategory,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.info_outlined,
        color: AppColors.textSecondaryColor,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 3,
            color: AppColors.textSecondaryShadowColor,
          ),
        ],
      ),
      onPressed: () {
        _showFoodItemsPopup(context);
      },
    );
  }

  void _showFoodItemsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              const Text(
                'Food Items in',
                style: TextStyle(color: AppColors.textPrimaryColor),
              ),
              Text(
                foodCategory.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: foodCategory.foodItems.map((FoodItem foodItem) {
                return ListTile(
                  title: Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  subtitle: Text(
                    foodItem.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.textPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
