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

  @override
  void dispose() {
    // Close the StreamController to avoid memory leaks
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        Provider.of<WhatToEatModel>(context).selectedCategory;

    final items = selectedCategory?.foodItems ?? [];

    return Scaffold(
      backgroundColor: AppColors.whatToEatPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              selectedCategory?.name ?? 'No category selected',
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
                for (var it in items) FortuneItem(child: Text(it)),
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
                  resultText = items[resultIndex];
                  spinning = false;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              resultText.isNotEmpty ? resultText : '',
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.whatToEatSecondaryColor
                    .withOpacity(spinning ? 0.3 : 1.0),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  splashColor:
                      spinning ? Colors.transparent : AppColors.splashColor,
                  borderRadius: BorderRadius.circular(12),
                  onTap: spinning
                      ? null
                      : () {
                          if (items.isNotEmpty) {
                            final randomIndex =
                                Fortune.randomInt(0, items.length);
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
