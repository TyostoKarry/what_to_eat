import 'package:flutter/material.dart';

import 'package:what_to_eat/components/what_to_eat_categories.dart';
import 'package:what_to_eat/models/what_to_eat_model.dart';

class WhatToEatScreen extends StatefulWidget {
  const WhatToEatScreen({super.key});

  @override
  State<WhatToEatScreen> createState() => _WhatToEatScreenState();
}

class _WhatToEatScreenState extends State<WhatToEatScreen> {
  final WhatToEatModel _whatToEatModel = WhatToEatModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildBodyBasedOnStete(_whatToEatModel.whatToEatScreenState),
      ),
    );
  }
}

Widget _buildBodyBasedOnStete(WhatToEatScreenState _whatToEatScreenState) {
  switch (_whatToEatScreenState) {
    case WhatToEatScreenState.categories:
      return WhatToEatCategories();
    case WhatToEatScreenState.wheelOfFortune:
      return Text('Wheel of Fortune');
    case WhatToEatScreenState.foodSelected:
      return Text('Feed Selected');
  }
}
