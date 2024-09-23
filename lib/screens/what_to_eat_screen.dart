import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/what_to_eat/what_to_eat_categories.dart';
import 'package:what_to_eat/components/what_to_eat/what_to_eat_food_selected.dart';
import 'package:what_to_eat/components/what_to_eat/what_to_eat_wheel_of_fortune.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';

class WhatToEatScreen extends StatefulWidget {
  const WhatToEatScreen({super.key});

  @override
  State<WhatToEatScreen> createState() => _WhatToEatScreenState();
}

class _WhatToEatScreenState extends State<WhatToEatScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WhatToEatModel>(context, listen: false)
          .setWhatToEatScreenState(WhatToEatScreenState.categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<WhatToEatModel>(
          builder: (context, model, child) {
            return _buildBodyBasedOnState(model.whatToEatScreenState);
          },
        ),
      ),
    );
  }

  Widget _buildBodyBasedOnState(WhatToEatScreenState _whatToEatScreenState) {
    switch (_whatToEatScreenState) {
      case WhatToEatScreenState.categories:
        return WhatToEatCategories();
      case WhatToEatScreenState.wheelOfFortune:
        return WhatToEatWheelOfFortune();
      case WhatToEatScreenState.foodSelected:
        return WhatToEatFoodSelected();
    }
  }
}
