import 'package:flutter/material.dart';
import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_view_title.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatSearch extends StatefulWidget {
  const WhereToEatSearch({super.key});

  @override
  State<WhereToEatSearch> createState() => _WhereToEatSearchState();
}

class _WhereToEatSearchState extends State<WhereToEatSearch> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Dispose all TextEditingControllers to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhereToEatBackground(),
        ),
        child: Column(
          children: [
            WTEViewTitle(
              titleText: "Where To Eat",
              padding: EdgeInsets.only(top: 60, bottom: 20),
            ),
            Expanded(
              child: Text("Temp"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.foodItemBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      color: AppColors.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                    cursorWidth: 1.3,
                    decoration: InputDecoration(
                      hintText: 'Enter food type',
                      hintStyle: TextStyle(
                        color: AppColors.textPrimaryColor.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: WTEButton(
                text: "Where To Eat",
                textColor: AppColors.textSecondaryColor,
                gradientColors: [
                  AppColors.whereToEatButtonPrimaryColor,
                  AppColors.whereToEatButtonSecondaryColor
                ],
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
