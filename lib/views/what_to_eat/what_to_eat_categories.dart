import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/what_to_eat/what_to_eat_food_item_popup.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final whatToEatModel =
          Provider.of<WhatToEatModel>(context, listen: false);
      whatToEatModel
        ..clearCustomCategory()
        ..addFoodToCustomCategory(whatToEatModel.defaultCustomFoodItem);
    });
  }

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
              padding: EdgeInsets.only(top: 60, bottom: 20),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: WhatToEatModel.foodCategories.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: AppColors.whatToEatPrimaryColor,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            splashColor: AppColors.splashColor,
                            onTap: () {
                              Provider.of<WhatToEatModel>(context,
                                  listen: false)
                                ..setSelectedCategory(
                                    WhatToEatModel.foodCategories[index])
                                ..setWhatToEatScreenState(WhatToEatModel
                                    .foodCategories[index].nextState);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: AutoSizeText(
                                  WhatToEatModel.foodCategories[index].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimaryColor),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  minFontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
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
          ],
        ),
      ),
    );
  }
}
