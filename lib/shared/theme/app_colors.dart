import "package:flutter/material.dart";

class AppColors {
  // General colors
  static const Color whatToEatButtonPrimaryColor =
      Color.fromARGB(255, 29, 94, 179);
  static const Color whatToEatButtonSecondaryColor =
      Color.fromARGB(255, 9, 78, 167);
  static const Color whereToEatButtonPrimaryColor =
      Color.fromARGB(255, 30, 148, 9);
  static const Color whereToEatButtonSecondaryColor =
      Color.fromARGB(255, 15, 104, 7);
  static const Color textPrimaryColor = Color.fromARGB(255, 0, 0, 0);
  static const Color textPrimaryShadowColor = Color.fromARGB(25, 0, 0, 0);
  static const Color textSecondaryColor = Color.fromARGB(255, 211, 211, 211);
  static const Color textSecondaryShadowColor = Color.fromARGB(200, 0, 0, 0);
  static const Color splashColor = Color.fromARGB(40, 255, 255, 128);
  static const Color foodItemBackgroundColor =
      Color.fromARGB(255, 255, 255, 255);
  static const Color wteDanger = Color.fromARGB(255, 218, 43, 30);
  static const Color cursorColor = Color.fromARGB(255, 0, 0, 0);
  static const Color selectionHandleColor = Color.fromARGB(255, 0, 0, 0);

  // main.dart
  static const Color navBarBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color navBarSelectedColor = Color.fromARGB(255, 33, 150, 243);
  static const Color navBarUnselectedColor = Color.fromARGB(255, 158, 158, 158);

  // what_to_eat_wheel_of_fortune.dart
  static const Color vetoTicketColor = Color.fromARGB(255, 156, 39, 176);
  static const Color vetoTicketShadowColor = Color.fromARGB(75, 0, 0, 0);
  static const Color primarySliceColor = Color.fromARGB(255, 64, 123, 239);
  static const Color secondarySliceColor = Color.fromARGB(255, 49, 103, 212);
  static const Color thirdSliceColor = Color.fromARGB(255, 57, 113, 225);
  static const Color wheelTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color wheelTextShadowColor = Color.fromARGB(100, 0, 0, 0);

  //wte_safe_area.dart
  static const Color safeAreaBackgroundColor = Color.fromARGB(255, 0, 0, 0);

  // Gradients
  static LinearGradient getWhatToEatBackground() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.fromARGB(255, 86, 204, 242),
        Color.fromARGB(255, 47, 128, 237),
      ],
    );
  }

  static LinearGradient getWhereToEatBackground() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.fromARGB(255, 174, 241, 97),
        Color.fromARGB(255, 116, 201, 25),
      ],
    );
  }

  static LinearGradient getWhereToEatButtonBackground() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        whereToEatButtonPrimaryColor,
        whereToEatButtonSecondaryColor,
      ],
    );
  }

  static LinearGradient getWhereToEatResultBackground() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.fromARGB(255, 202, 255, 141),
        Color.fromARGB(255, 185, 255, 110),
      ],
    );
  }
}
