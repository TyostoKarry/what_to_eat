import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhatToEatCustomCategory extends StatefulWidget {
  const WhatToEatCustomCategory({super.key});

  @override
  _WhatToEatCustomCategory createState() => _WhatToEatCustomCategory();
}

class _WhatToEatCustomCategory extends State<WhatToEatCustomCategory> {
  List<TextEditingController> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _addFoodField();
  }

  void _addFoodField() {
    setState(() {
      _foodItems.add(TextEditingController());
    });
  }

  void _removeFoodField(int index) {
    setState(() {
      _foodItems[index].dispose();
      _foodItems.removeAt(index);
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Create Custom Category',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(_foodItems.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Text(
                              '${index + 1}.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.foodItemBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  controller: _foodItems[index],
                                  decoration: InputDecoration(
                                    labelText: 'Enter food name',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.wteDanger,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.textPrimaryColor,
                              ),
                              onPressed: () {
                                _removeFoodField(index);
                              },
                            ),
                          ),
                        ],
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
                color: AppColors.whatToEatPrimaryColor,
                textColor: AppColors.textPrimaryColor,
                onTap: _addFoodField,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: WTEButton(
                text: "Save and Proceed to Wheel",
                color: AppColors.whatToEatPrimaryColor,
                textColor: AppColors.textPrimaryColor,
                onTap: _saveCustomCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
