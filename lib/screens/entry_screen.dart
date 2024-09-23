import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class EntryScreen extends StatelessWidget {
  final Function onItemTapped;

  EntryScreen({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Material(
              color: AppColors.whatToEatPrimaryColor,
              child: InkWell(
                onTap: () {
                  onItemTapped(2);
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_sharp,
                        size: 36,
                        color: AppColors.textPrimaryColor,
                      ),
                      Text(
                        'What',
                        style: TextStyle(
                            fontSize: 36, color: AppColors.textPrimaryColor),
                      ),
                      Text(
                        'to Eat',
                        style: TextStyle(
                            fontSize: 36, color: AppColors.textPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: AppColors.whereToEatPrimaryColor,
              child: InkWell(
                onTap: () {
                  onItemTapped(3);
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on,
                          size: 36, color: AppColors.textPrimaryColor),
                      Text(
                        'Where',
                        style: TextStyle(
                            fontSize: 36, color: AppColors.textPrimaryColor),
                      ),
                      Text(
                        'to Eat',
                        style: TextStyle(
                            fontSize: 36, color: AppColors.textPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
