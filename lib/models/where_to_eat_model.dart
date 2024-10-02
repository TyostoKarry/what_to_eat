import 'package:flutter/material.dart';

enum WhereToEatScreenState { landing, restaurantSelected }

class WhereToEatModel extends ChangeNotifier {
  WhereToEatScreenState _whereToEatScreenState = WhereToEatScreenState.landing;
  WhereToEatScreenState get whereToEatScreenState => _whereToEatScreenState;

  void setWhereToEatScreenState(WhereToEatScreenState newState) {
    _whereToEatScreenState = newState;
    notifyListeners();
  }
}
