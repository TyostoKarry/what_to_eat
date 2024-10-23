import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/what_to_eat/views/what_to_eat_categories.dart';
import 'package:what_to_eat/what_to_eat/views/what_to_eat_custom_category.dart';
import 'package:what_to_eat/what_to_eat/views/what_to_eat_food_selected.dart';
import 'package:what_to_eat/what_to_eat/views/what_to_eat_wheel_of_fortune.dart';
import 'package:what_to_eat/shared/widgets/wte_safe_area.dart';

class WhatToEatScreen extends StatefulWidget {
  const WhatToEatScreen({super.key});

  @override
  State<WhatToEatScreen> createState() => _WhatToEatScreenState();
}

class _WhatToEatScreenState extends State<WhatToEatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WTESafeArea(
        child: Center(
          child: Consumer<WhatToEatModel>(
            builder: (context, model, child) {
              return _buildBodyBasedOnState(model.whatToEatScreenState);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBodyBasedOnState(WhatToEatScreenState whatToEatScreenState) {
    switch (whatToEatScreenState) {
      case WhatToEatScreenState.categories:
        return WhatToEatCategories();
      case WhatToEatScreenState.customCategory:
        return WhatToEatCustomCategory();
      case WhatToEatScreenState.wheelOfFortune:
        return WhatToEatWheelOfFortune();
      case WhatToEatScreenState.foodSelected:
        return WhatToEatFoodSelected();
    }
  }
}
