import 'package:flutter/material.dart';

enum WhereToEatScreenState { search, restaurantSelected }

class WhereToEatModel extends ChangeNotifier {
  WhereToEatScreenState _whereToEatScreenState = WhereToEatScreenState.search;
  WhereToEatScreenState get whereToEatScreenState => _whereToEatScreenState;

  void setWhereToEatScreenState(WhereToEatScreenState newState) {
    _whereToEatScreenState = newState;
    notifyListeners();
  }
}
