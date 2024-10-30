import 'package:flutter/material.dart';

enum WhoToPayScreenState {
  wheenOfFortune,
  arrowWheel,
  coinFlip,
}

class WhoToPayModel extends ChangeNotifier {
  WhoToPayScreenState _whoToPayScreenState = WhoToPayScreenState.wheenOfFortune;
  WhoToPayScreenState get whoToPayScreenState => _whoToPayScreenState;

  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;

  void setWhoToPayScreenState(WhoToPayScreenState newState) {
    if (_whoToPayScreenState != newState) {
      setSpinning(false);
      notifyListeners();
    }
    _whoToPayScreenState = newState;
    notifyListeners();
  }

  void startSpin() {
    if (_isSpinning) return;
    setSpinning(true);
    notifyListeners();
  }

  void setSpinning(bool value) {
    _isSpinning = value;
    notifyListeners();
  }
}
