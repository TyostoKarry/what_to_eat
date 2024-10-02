import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';

class WhereToEatScreen extends StatefulWidget {
  const WhereToEatScreen({super.key});

  @override
  State<WhereToEatScreen> createState() => _WhereToEatScreenState();
}

class _WhereToEatScreenState extends State<WhereToEatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<WhereToEatModel>(
          builder: (context, model, child) {
            return _buildBodyBasedOnState(model.whereToEatScreenState);
          },
        ),
      ),
    );
  }

  Widget _buildBodyBasedOnState(WhereToEatScreenState _whereToEatScreenState) {
    switch (_whereToEatScreenState) {
      case WhereToEatScreenState.landing:
        return Text("Landing Screen");
      case WhereToEatScreenState.restaurantSelected:
        return Text("Restaurant Selected Screen");
    }
  }
}
