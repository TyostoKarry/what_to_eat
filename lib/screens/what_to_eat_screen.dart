import 'package:flutter/material.dart';

import 'package:what_to_eat/components/what_to_eat_categories.dart';

enum WhatToEatScreenState { categories, wheelOfFortune, foodSelected }

class WhatToEatScreen extends StatefulWidget {
  const WhatToEatScreen({super.key});

  @override
  State<WhatToEatScreen> createState() => _WhatToEatScreenState();
}

class _WhatToEatScreenState extends State<WhatToEatScreen> {
  WhatToEatScreenState _currentState = WhatToEatScreenState.categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildBodyBasedOnStete(_currentState),
      ),
    );
  }
}

Widget _buildBodyBasedOnStete(WhatToEatScreenState _currentState) {
  switch (_currentState) {
    case WhatToEatScreenState.categories:
      return WhatToEatCategories();
    case WhatToEatScreenState.wheelOfFortune:
      return Text('Wheel of Fortune');
    case WhatToEatScreenState.foodSelected:
      return Text('Feed Selected');
  }
}
