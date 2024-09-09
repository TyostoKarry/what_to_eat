import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: AppColors.whatToEatButtonColor,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add action for left button
                  },
                  child: Text('What to Eat'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.whereToEatButtonColor,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add action for right button
                  },
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
