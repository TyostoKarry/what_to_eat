import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Add action for left button
              },
              child: Container(
                color: AppColors.whatToEatButtonColor,
                child: Center(
                  child: Text('What to Eat'),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                // Add action for right button
              },
              child: Container(
                color: AppColors.whereToEatButtonColor,
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
