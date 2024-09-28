import "package:flutter/material.dart";

class AppColors {
  // General colors
  static const Color whatToEatButtonPrimaryColor =
      Color.fromARGB(255, 31, 154, 255);
  static const Color whatToEatButtonSecondaryColor =
      Color.fromARGB(255, 81, 177, 255);
  static const Color whereToEatPrimaryColor =
      Color.fromARGB(255, 200, 230, 201);
  static const Color splashColor = Color.fromARGB(100, 255, 255, 128);
  static const Color textPrimaryColor = Color.fromARGB(255, 0, 0, 0);
  static const Color foodItemBackgroundColor =
      const Color.fromARGB(255, 255, 255, 255);
  static const Color wteDanger = const Color.fromARGB(255, 244, 67, 54);
  static const Color cursorColor = Color.fromARGB(255, 0, 0, 0);
  static const Color selectionHandleColor = Color.fromARGB(255, 0, 0, 0);

  // main.dart
  static const Color navBarBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color navBarSelectedColor =
      const Color.fromARGB(255, 33, 150, 243);
  static const Color navBarUnselectedColor =
      const Color.fromARGB(255, 158, 158, 158);

  // what_to_eat_wheel_of_fortune.dart
  static const Color vetoTicketColor = const Color.fromARGB(255, 156, 39, 176);
  static const Color primarySliceColor = Color.fromARGB(255, 164, 174, 212);
  static const Color secondarySliceColor = Color.fromARGB(255, 84, 99, 164);
  static const Color thirdSliceColor = Color.fromARGB(255, 132, 140, 188);
  static const Color wheelTextColor = Color.fromARGB(255, 255, 255, 255);

  // Gradients
  static LinearGradient getWhatToEatBackground() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color.fromARGB(255, 179, 229, 252),
        const Color.fromARGB(255, 79, 195, 247),
      ],
    );
  }

  static LinearGradient getWhereToEatBackground() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color.fromARGB(255, 197, 225, 165),
        const Color.fromARGB(255, 156, 204, 101),
      ],
    );
  }
}
