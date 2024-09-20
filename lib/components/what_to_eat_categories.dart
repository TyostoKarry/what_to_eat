import 'package:flutter/material.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhatToEatCategories extends StatelessWidget {
  final List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whatToEatPrimaryColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: const Center(
              child: Text(
                'Select Food Category',
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // square-shaped items
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: AppColors.whatToEatSecondaryColor,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      splashColor: AppColors.splashColor,
                      onTap: () {
                        // Handle the onTap event here
                      },
                      child: Center(
                        child: Text(
                          categories[index], // Use the category from the list
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
