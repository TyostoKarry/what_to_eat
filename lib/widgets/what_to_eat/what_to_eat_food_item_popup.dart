import 'package:flutter/material.dart';

import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class FoodItemsPopup extends StatelessWidget {
  final FoodCategory foodCategory;

  const FoodItemsPopup({
    super.key,
    required this.foodCategory,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.info_outlined,
        color: AppColors.textSecondaryColor,
        shadows: [
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
            children: [
              Text(
                'Food Items in',
                style: TextStyle(color: AppColors.textPrimaryColor),
              ),
              Text(
                foodCategory.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: foodCategory.foodItems.map((foodItem) {
                return ListTile(
                  title: Text(foodItem.name,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryColor)),
                  subtitle: Text(
                    foodItem.description,
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textPrimaryColor),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
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
