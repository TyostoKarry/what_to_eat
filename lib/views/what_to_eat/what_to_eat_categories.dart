import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/what_to_eat/what_to_eat_food_item_popup.dart';
import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/components/wte_view_title.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhatToEatCategories extends StatefulWidget {
  const WhatToEatCategories({super.key});

  @override
  _WhatToEatCategoriesState createState() => _WhatToEatCategoriesState();
}

class _WhatToEatCategoriesState extends State<WhatToEatCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhatToEatBackground(),
        ),
        child: Column(
          children: [
            WTEViewTitle(
              titleText: 'Select Food Category',
              padding: EdgeInsets.only(top: 60),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.7,
                  ),
                  itemCount: WhatToEatModel.foodCategories.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.whatToEatButtonPrimaryColor,
                                    AppColors.whatToEatButtonSecondaryColor
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              splashColor: AppColors.splashColor,
                              onTap: () {
                                Provider.of<WhatToEatModel>(context,
                                        listen: false)
                                    .setSelectedCategory(
                                        WhatToEatModel.foodCategories[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: WTEText(
                                    text: WhatToEatModel
                                        .foodCategories[index].name,
                                    color: AppColors.textSecondaryColor,
                                    shadowColor:
                                        AppColors.textSecondaryShadowColor,
                                    offset: Offset(2, 2),
                                    fontSize: 20,
                                    minFontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: 4,
                            child: FoodItemsPopup(
                              foodCategory:
                                  WhatToEatModel.foodCategories[index],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: WTEButton(
                text: 'Create Custom Category',
                textColor: AppColors.textSecondaryColor,
                onTap: () {
                  Provider.of<WhatToEatModel>(context, listen: false)
                      .setWhatToEatScreenState(
                          WhatToEatScreenState.customCategory);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
