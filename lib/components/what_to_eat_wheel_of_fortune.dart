import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';

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
  String resultText = '';

  int vetoesLeft = 0;
  List<bool> vetoUsed = [];

  String categoryName = '';
  List<String> sessionItems = [];

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
    sessionItems = List<String>.from(selectedCategory?.foodItems ?? []);

    // Determine the number of veto tickets based on the number of food items
    if (sessionItems.length >= 4) {
      vetoesLeft = 2;
    } else if (sessionItems.length == 3) {
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

        sessionItems.remove(resultText);

        resultText = '';
        spinning = false;
        vetoesLeft--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whatToEatPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: FortuneWheel(
              selected: selected.stream,
              items: [
                for (var it in sessionItems) FortuneItem(child: Text(it)),
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
                    resultText = sessionItems[resultIndex];
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
                          color: AppColors.vetoCrossColor,
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
                color: AppColors.resultBackgroundColor,
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
                child: Text(
                  resultText.isNotEmpty ? resultText : '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: resultText.isEmpty
                  ? Material(
                      color: AppColors.whatToEatSecondaryColor
                          .withOpacity(spinning ? 0.3 : 1.0),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        splashColor: spinning
                            ? Colors.transparent
                            : AppColors.splashColor,
                        borderRadius: BorderRadius.circular(12),
                        onTap: spinning
                            ? null
                            : () {
                                if (sessionItems.isNotEmpty) {
                                  final randomIndex =
                                      Fortune.randomInt(0, sessionItems.length);
                                  selected.add(randomIndex);
                                  setState(() {
                                    resultIndex = randomIndex;
                                  });
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            "Spin the Wheel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: AppColors.whatToEatSecondaryColor
                                .withOpacity(vetoesLeft > 0 ? 1.0 : 0.3),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              splashColor: vetoesLeft > 0
                                  ? AppColors.splashColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              onTap: vetoesLeft > 0 && !spinning
                                  ? () {
                                      useVeto();
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: const Text(
                                  "Use Veto",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Material(
                            color: AppColors.whatToEatSecondaryColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              splashColor: AppColors.splashColor,
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Select the result
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: const Text(
                                  "Select Food",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
