import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class EntryScreen extends StatelessWidget {
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
                  // Add action for left button
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Text('What to Eat'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: AppColors.whereToEatButtonColor,
              child: InkWell(
                onTap: () {
                  // Add action for right button
                },
                splashColor: AppColors.splashColor,
                child: Center(
                  child: Text('Where to Eat'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
