import 'package:flutter/material.dart';

enum WhoToPayScreenState {
  wheenOfFortune,
  arrowWheel,
  coinFlip,
}

class WhoToPayModel extends ChangeNotifier {
  WhoToPayScreenState _whoToPayScreenState = WhoToPayScreenState.wheenOfFortune;
  WhoToPayScreenState get whoToPayScreenState => _whoToPayScreenState;

  void setWhoToPayScreenState(WhoToPayScreenState newState) {
    _whoToPayScreenState = newState;
    notifyListeners();
  }
}
