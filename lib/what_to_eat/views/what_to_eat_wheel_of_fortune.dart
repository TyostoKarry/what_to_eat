import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/shared/widgets/wte_view_title.dart';

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
  List<bool> vetoUsed = <bool>[];

  String categoryName = '';
  List<FoodItem> sessionItems = <FoodItem>[];

  final Color primarySliceColor = AppColors.whatToEatPrimarySliceColor;
  final Color secondarySliceColor = AppColors.whatToEatSecondarySliceColor;
  final Color thirdSliceColor = AppColors.whatToEatTertiarySliceColor;

  // Function to generate color pattern based on the number of items
  List<Color> generateColorPattern(int itemCount) {
    List<Color> colorPattern = <Color>[];

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
    selected.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final FoodCategory? selectedCategory =
        Provider.of<WhatToEatModel>(context, listen: false).selectedCategory;
    categoryName = selectedCategory?.name ?? 'No category selected';
    sessionItems =
        List<FoodItem>.from(selectedCategory?.foodItems ?? <FoodItem>[]);

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

    vetoUsed = List<bool>.generate(vetoesLeft, (int index) => false);
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
          children: <Widget>[
            WTEViewTitle(
              titleText: categoryName,
            ),
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: <FortuneItem>[
                  for (int i = 0; i < sessionItems.length; i++)
                    FortuneItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: WTEText(
                          text: sessionItems[i].name,
                          color: AppColors.wheelTextColor,
                          shadowColor: AppColors.wheelTextShadowColor,
                          offset: const Offset(2, 2),
                          fontSize: 14,
                          minFontSize: 8,
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
              children: List<Widget>.generate(vetoUsed.length, (int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Transform.rotate(
                          angle: 30 * 3.14 / 180,
                          child: const Icon(
                            Icons.local_activity,
                            color: AppColors.vetoTicketColor,
                            size: 40,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: AppColors.vetoTicketShadowColor,
                              ),
                            ],
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: vetoUsed[index] ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: const Icon(
                            Icons.block,
                            color: AppColors.wteDanger,
                            size: 70,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: AppColors.vetoTicketShadowColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.foodItemBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedOpacity(
                  opacity: resultFoodItem != null ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Center(
                    child: WTEText(
                      text: resultFoodItem != null ? resultFoodItem!.name : '',
                      color: AppColors.textPrimaryColor,
                      shadowColor: AppColors.textPrimaryShadowColor,
                      offset: const Offset(2, 2),
                      fontSize: 20,
                      minFontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AnimatedCrossFade(
                firstChild: WTEButton(
                  text: "Spin the Wheel",
                  gradient: AppColors.getWhatToEatButtonBackground(),
                  textColor: AppColors.textSecondaryColor,
                  colorEnabled: !spinning,
                  splashEnabled: !spinning,
                  tapEnabled: !spinning,
                  onTap: () {
                    if (sessionItems.isNotEmpty) {
                      final int randomIndex =
                          Fortune.randomInt(0, sessionItems.length);
                      selected.add(randomIndex);
                      setState(
                        () {
                          resultIndex = randomIndex;
                        },
                      );
                    }
                  },
                ),
                secondChild: VetoOrResult(
                  vetoesLeft: vetoesLeft,
                  spinning: spinning,
                  useVeto: useVeto,
                  resultFoodItem: resultFoodItem,
                ),
                crossFadeState: resultFoodItem == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VetoOrResult extends StatelessWidget {
  final int vetoesLeft;
  final bool spinning;
  final Function useVeto;
  final FoodItem? resultFoodItem;

  const VetoOrResult({
    super.key,
    required this.vetoesLeft,
    required this.spinning,
    required this.useVeto,
    required this.resultFoodItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: WTEButton(
            text: "Use Veto",
            gradient: AppColors.getWhatToEatButtonBackground(),
            textColor: AppColors.textSecondaryColor,
            colorEnabled: vetoesLeft > 0,
            splashEnabled: vetoesLeft > 0,
            tapEnabled: vetoesLeft > 0,
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
            gradient: AppColors.getWhatToEatButtonBackground(),
            textColor: AppColors.textSecondaryColor,
            colorEnabled: !spinning,
            splashEnabled: !spinning,
            tapEnabled: !spinning,
            onTap: () {
              if (resultFoodItem != null) {
                Provider.of<WhatToEatModel>(context, listen: false)
                    .setSelectedFood(resultFoodItem!);
              }
            },
          ),
        ),
      ],
    );
  }
}
