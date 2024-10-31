import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button_custom_child.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/who_to_pay/models/who_to_pay_model.dart';

class WhoToPayWheelOfFortune extends StatefulWidget {
  const WhoToPayWheelOfFortune({super.key});

  @override
  State<WhoToPayWheelOfFortune> createState() => _WhoToPayWheelOfFortuneState();
}

class _WhoToPayWheelOfFortuneState extends State<WhoToPayWheelOfFortune> {
  WhoToPayModel? model;
  final StreamController<int> selected = StreamController<int>();
  List<String> sessionItems = <String>['Person 1', 'Person 2'];

  final Color primarySliceColor = AppColors.whoToPayPrimarySliceColor;
  final Color secondarySliceColor = AppColors.whoToPaySecondarySliceColor;
  final Color thirdSliceColor = AppColors.whoToPayTertiarySliceColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final WhoToPayModel newModel =
        Provider.of<WhoToPayModel>(context, listen: false);

    if (model != newModel) {
      model?.removeListener(_checkSpin);
      model = newModel;
      model?.addListener(_checkSpin);
    }
  }

  @override
  void dispose() {
    model?.removeListener(_checkSpin);
    selected.close();
    super.dispose();
  }

  void _checkSpin() {
    if (model?.isSpinning == true) {
      _spinWheel();
    }
  }

  void _spinWheel() {
    final int randomIndex = Fortune.randomInt(0, sessionItems.length);
    selected.add(randomIndex);
  }

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

  void _editSessionItem(int index) {
    TextEditingController controller =
        TextEditingController(text: sessionItems[index]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Edit Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter new name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sessionItems[index] = controller.text;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorPattern = generateColorPattern(sessionItems.length);

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FortuneWheel(
              selected: selected.stream,
              items: <FortuneItem>[
                for (int i = 0; i < sessionItems.length; i++)
                  FortuneItem(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: WTEText(
                        text: sessionItems[i],
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
                    onTap: () {
                      _editSessionItem(i);
                    },
                  ),
              ],
              physics: NoPanPhysics(),
              animateFirst: false,
              onAnimationEnd: () {
                if (mounted) {
                  model?.setSpinning(false);
                }
              },
            ),
          ),
        ),
        Consumer<WhoToPayModel>(
          builder: (BuildContext context, WhoToPayModel model, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                WTEButtonCustomChild(
                  width: 50,
                  height: 50,
                  backgroundGradient: AppColors.getWhoToPayButtonBackground(),
                  disabledColor:
                      AppColors.whoToPayButtonPrimaryColor.withOpacity(0.8),
                  isEnabled: model.isSpinning == false,
                  onTap: () {
                    setState(() {
                      sessionItems.add('Person ${sessionItems.length + 1}');
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textTertiaryColor,
                  ),
                ),
                const SizedBox(width: 50),
                WTEButtonCustomChild(
                  width: 50,
                  height: 50,
                  backgroundGradient: AppColors.getWhoToPayButtonBackground(),
                  disabledColor:
                      AppColors.whoToPayButtonPrimaryColor.withOpacity(0.8),
                  isEnabled:
                      sessionItems.length > 2 && model.isSpinning == false,
                  onTap: () {
                    if (sessionItems.length > 2) {
                      setState(() {
                        sessionItems.removeLast();
                      });
                    }
                  },
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.textTertiaryColor,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        const WTEText(
          text: 'Tap a segment to modify name',
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
      ],
    );
  }
}
