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
              color: AppColors.whatToEatButtonColor,
              child: InkWell(
                onTap: () {
                  onItemTapped(2);
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fastfood_outlined, size: 36),
                      Text(
                        'What',
                        style: TextStyle(fontSize: 36),
                      ),
                      Text(
                        'to Eat',
                        style: TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: AppColors.whereToEatButtonColor,
              child: InkWell(
                onTap: () {
                  onItemTapped(3);
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_sharp, size: 36),
                      Text(
                        'Where',
                        style: TextStyle(fontSize: 36),
                      ),
                      Text(
                        'to Eat',
                        style: TextStyle(fontSize: 36),
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
