import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_view_title.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhatToEatCustomCategory extends StatefulWidget {
  const WhatToEatCustomCategory({super.key});

  @override
  _WhatToEatCustomCategory createState() => _WhatToEatCustomCategory();
}

class _WhatToEatCustomCategory extends State<WhatToEatCustomCategory> {
  List<TextEditingController> _foodItems = [];
  List<double> _foodItemOpacities = [];
  bool _isAnimating = false;

  static const Duration disableButtonDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _addFoodField();
  }

  void _addFoodField() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _foodItems.add(TextEditingController());
      _foodItemOpacities.add(0.0);
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _foodItemOpacities[_foodItemOpacities.length - 1] = 1.0;
      });
    });

    await Future.delayed(disableButtonDuration);
    setState(() {
      _isAnimating = false;
    });
  }

  void _removeFoodField(int index) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _foodItemOpacities[index] = 0.0;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _foodItems[index].dispose();
        _foodItems.removeAt(index);
        _foodItemOpacities.removeAt(index);
      });
    });

    await Future.delayed(disableButtonDuration);
    setState(() {
      _isAnimating = false;
    });
  }

  void _saveCustomCategory() {
    final whatToEatModel = Provider.of<WhatToEatModel>(context, listen: false);

    whatToEatModel.clearCustomCategory();

    int validFoodItemsCount = 0;

    for (var foodItem in _foodItems) {
      if (foodItem.text.isNotEmpty) {
        validFoodItemsCount++;
        whatToEatModel.addFoodToCustomCategory(FoodItem(
          name: foodItem.text,
          image: 'empty_plate.jpg',
          description: '',
        ));
      }
    }
    if (validFoodItemsCount < 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Not Enough Items'),
            content: const Text(
                'You need at least 2 food items in order to spin the wheel.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      whatToEatModel.setSelectedCategory(whatToEatModel.customCategory);
      whatToEatModel
          .setWhatToEatScreenState(WhatToEatScreenState.wheelOfFortune);
    }
  }

  @override
  void dispose() {
    // Dispose all TextEditingControllers to prevent memory leaks
    for (var foodItem in _foodItems) {
      foodItem.dispose();
    }
    super.dispose();
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
              titleText: 'Create Custom Category',
              padding: EdgeInsets.only(top: 60, bottom: 20),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(_foodItems.length, (index) {
                    return AnimatedOpacity(
                      opacity: _foodItemOpacities[index],
                      duration: Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimaryColor,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      color: AppColors.textPrimaryShadowColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.foodItemBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textPrimaryColor,
                                    width: 0.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: TextField(
                                          controller: _foodItems[index],
                                          style: TextStyle(
                                            color: AppColors.textPrimaryColor,
                                          ),
                                          cursorWidth: 1.3,
                                          decoration: InputDecoration(
                                            labelText: 'Enter food name',
                                            labelStyle: TextStyle(
                                              color: AppColors.textPrimaryColor
                                                  .withOpacity(0.6),
                                            ),
                                            floatingLabelStyle: TextStyle(
                                              color: AppColors.textPrimaryColor
                                                  .withOpacity(0.6),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.textPrimaryColor,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 3,
                                            color: AppColors
                                                .textPrimaryShadowColor,
                                          ),
                                        ],
                                      ),
                                      onPressed: _isAnimating
                                          ? null
                                          : () {
                                              _removeFoodField(index);
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: WTEButton(
                text: "Add Food Item",
                textColor: AppColors.textSecondaryColor,
                onTap: _addFoodField,
                splashEnabled: !_isAnimating,
                tapEnabled: !_isAnimating,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: WTEButton(
                text: "Save and Proceed to Wheel",
                textColor: AppColors.textSecondaryColor,
                onTap: _saveCustomCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
