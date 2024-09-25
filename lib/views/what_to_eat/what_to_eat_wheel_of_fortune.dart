import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhatToEatWheelOfFortune extends StatefulWidget {
  const WhatToEatWheelOfFortune({super.key});

  @override
  State<WhatToEatWheelOfFortune> createState() =>
      _WhatToEatWheelOfFortuneState();
}

class _WhatToEatWheelOfFortuneState extends State<WhatToEatWheelOfFortune> {
  final StreamController<int> selected = StreamController<int>();
  bool spinning = false;
  int resultIndex = -1;
  FoodItem? resultFoodItem;

  int vetoesLeft = 0;
  List<bool> vetoUsed = [];

  String categoryName = '';
  List<FoodItem> sessionItems = [];

  final Color primarySliceColor = AppColors.primarySliceColor;
  final Color secondarySliceColor = AppColors.secondarySliceColor;
  final Color thirdSliceColor = AppColors.thirdSliceColor;

  // Function to generate color pattern based on the number of items
  List<Color> generateColorPattern(int itemCount) {
    List<Color> colorPattern = [];

    // Alternate between primaryColor and secondaryColor
    for (int i = 0; i < itemCount; i++) {
      if (itemCount % 2 != 0 && i == itemCount - 1) {
        // If odd number of items, assign thirdColor to the last item
        colorPattern.add(thirdSliceColor);
      } else {
        // Otherwise alternate between primary and secondary colors
        colorPattern.add(i % 2 == 0 ? primarySliceColor : secondarySliceColor);
      }
    }

    return colorPattern;
  }

  @override
  void dispose() {
    // Close the StreamController to avoid memory leaks
    selected.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedCategory =
        Provider.of<WhatToEatModel>(context, listen: false).selectedCategory;
    categoryName = selectedCategory?.name ?? 'No category selected';
    sessionItems = List<FoodItem>.from(selectedCategory?.foodItems ?? []);

    // Determine the number of veto tickets based on the number of food items
    if (sessionItems.length >= 12) {
      vetoesLeft = 3;
    } else if (sessionItems.length >= 7) {
      vetoesLeft = 2;
    } else if (sessionItems.length >= 3) {
      vetoesLeft = 1;
    } else {
      vetoesLeft = 0;
    }

    vetoUsed = List.generate(vetoesLeft, (index) => false);
  }

  void useVeto() {
    if (vetoesLeft > 0) {
      setState(() {
        int currentVetoesLeft = vetoUsed.length - vetoesLeft;
        vetoUsed[currentVetoesLeft] = true;

        sessionItems.remove(resultFoodItem);

        resultFoodItem = null;
        spinning = false;
        vetoesLeft--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorPattern = generateColorPattern(sessionItems.length);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhatToEatBackground(),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: AutoSizeText(
                categoryName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: [
                  for (int i = 0; i < sessionItems.length; i++)
                    FortuneItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: AutoSizeText(
                          sessionItems[i].name,
                          style:
                              const TextStyle(color: AppColors.wheelTextColor),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: FortuneItemStyle(
                        color: colorPattern[i],
                        borderWidth: 0,
                      ),
                    ),
                ],
                physics: NoPanPhysics(),
                animateFirst: false,
                onAnimationStart: () {
                  setState(() {
                    spinning = true;
                  });
                },
                onAnimationEnd: () {
                  setState(() {
                    if (resultIndex >= 0 && resultIndex < sessionItems.length) {
                      resultFoodItem = sessionItems[resultIndex];
                    }
                    spinning = false;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(vetoUsed.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: 30 * 3.14 / 180,
                          child: Icon(
                            Icons.local_activity,
                            color: AppColors.vetoTicketColor,
                            size: 40,
                          ),
                        ),
                        if (vetoUsed[index])
                          Icon(
                            Icons.block,
                            color: AppColors.wteDanger,
                            size: 70,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.all(12),
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
                child: Center(
                  child: AutoSizeText(
                    resultFoodItem != null ? resultFoodItem!.name : '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: resultFoodItem == null
                  ? WTEButton(
                      text: "Spin the Wheel",
                      color: AppColors.whatToEatPrimaryColor,
                      textColor: AppColors.textPrimaryColor,
                      isEnabled: !spinning,
                      onTap: () {
                        if (sessionItems.isNotEmpty) {
                          final randomIndex =
                              Fortune.randomInt(0, sessionItems.length);
                          selected.add(randomIndex);
                          setState(() {
                            resultIndex = randomIndex;
                          });
                        }
                      },
                    )
                  : Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: WTEButton(
                            text: "Use Veto",
                            color: AppColors.whatToEatPrimaryColor,
                            textColor: AppColors.textPrimaryColor,
                            isEnabled: vetoesLeft > 0,
                            onTap: () {
                              if (!spinning) {
                                useVeto();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: WTEButton(
                            text: "Select Food",
                            color: AppColors.whatToEatPrimaryColor,
                            textColor: AppColors.textPrimaryColor,
                            isEnabled: !spinning,
                            onTap: () {
                              if (resultFoodItem != null) {
                                Provider.of<WhatToEatModel>(context,
                                    listen: false)
                                  ..setSelectedFood(resultFoodItem!)
                                  ..setWhatToEatScreenState(
                                      WhatToEatScreenState.foodSelected);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
