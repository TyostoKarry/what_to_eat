import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button.dart';
import 'package:what_to_eat/shared/widgets/wte_safe_area.dart';
import 'package:what_to_eat/shared/widgets/wte_segmented_button.dart';
import 'package:what_to_eat/shared/widgets/wte_view_title.dart';
import 'package:what_to_eat/who_to_pay/models/who_to_pay_model.dart';
import 'package:what_to_eat/who_to_pay/views/who_to_pay_wheel_of_fortune.dart';

class WhoToPayScreen extends StatefulWidget {
  const WhoToPayScreen({super.key});

  @override
  State<WhoToPayScreen> createState() => _WhoToPayScreenState();
}

class _WhoToPayScreenState extends State<WhoToPayScreen> {
  Set<String> selected = <String>{'Wheel'};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WhoToPayModel>(
        context,
        listen: false,
      ).setSpinning(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WTESafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.getWhoToPayBackground(),
          ),
          child: Column(
            children: <Widget>[
              const WTEViewTitle(
                titleText: 'Who To Pay',
              ),
              Expanded(
                child: Consumer<WhoToPayModel>(
                  builder: (
                    BuildContext context,
                    WhoToPayModel model,
                    Widget? child,
                  ) {
                    return _buildContent(model.whoToPayScreenState);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: WTESegmentedButton(
                  options: const <String>["Wheel", "Arrow", "Coin Flip"],
                  selectedIcons: const <IconData>[
                    Icons.attractions,
                    Icons.arrow_back,
                    Icons.paid,
                  ],
                  unselectedIcons: const <IconData>[
                    Icons.attractions,
                    Icons.arrow_back,
                    Icons.paid,
                  ],
                  height: 60,
                  selectedColors: const <Color>[
                    AppColors.whoToPayButtonPrimaryColor,
                    AppColors.whoToPayButtonSecondaryColor,
                  ],
                  unselectedColor:
                      AppColors.whoToPayButtonPrimaryColor.withOpacity(0.8),
                  selected: selected,
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      selected = newSelection;
                    });
                    if (newSelection.contains('Wheel')) {
                      Provider.of<WhoToPayModel>(
                        context,
                        listen: false,
                      ).setWhoToPayScreenState(
                        WhoToPayScreenState.wheenOfFortune,
                      );
                    } else if (newSelection.contains('Arrow')) {
                      Provider.of<WhoToPayModel>(
                        context,
                        listen: false,
                      ).setWhoToPayScreenState(
                        WhoToPayScreenState.arrowWheel,
                      );
                    } else if (newSelection.contains('Coin Flip')) {
                      Provider.of<WhoToPayModel>(
                        context,
                        listen: false,
                      ).setWhoToPayScreenState(
                        WhoToPayScreenState.coinFlip,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Consumer<WhoToPayModel>(
                  builder: (
                    BuildContext context,
                    WhoToPayModel model,
                    Widget? child,
                  ) {
                    bool isEnabled = !model.isSpinning;
                    return WTEButton(
                      text: 'Who To Pay',
                      gradient: AppColors.getWhoToPayButtonBackground(),
                      textColor: AppColors.textSecondaryColor,
                      onTap: () {
                        model.startSpin();
                      },
                      colorEnabled: isEnabled,
                      splashEnabled: isEnabled,
                      tapEnabled: isEnabled,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(WhoToPayScreenState whoToPayScreenState) {
    switch (whoToPayScreenState) {
      case WhoToPayScreenState.wheenOfFortune:
        return const WhoToPayWheelOfFortune();
      case WhoToPayScreenState.arrowWheel:
        return Container();
      case WhoToPayScreenState.coinFlip:
        return Container();
    }
  }
}
