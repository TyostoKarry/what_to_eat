import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_eat/components/wte_text.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatSlotMachine extends StatefulWidget {
  final List<String> restaurantNames;

  const WhereToEatSlotMachine({
    Key? key,
    required this.restaurantNames,
  }) : super(key: key);

  @override
  State<WhereToEatSlotMachine> createState() => _WhereToEatSlotMachineState();
}

class _WhereToEatSlotMachineState extends State<WhereToEatSlotMachine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late String selectedRestaurant;

  Timer? _timer;
  final Random _random = Random();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Set initial restaurant
    selectedRestaurant = widget.restaurantNames[0];

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Start animation when the widget renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRandomization();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startRandomization() {
    // Create a repetitive timer to simulate the slot machine rolling effect
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        // Pick a random restaurant index
        _currentIndex = _random.nextInt(widget.restaurantNames.length);
      });
    });

    // Stop randomization after 3 seconds
    _controller.forward().then((_) {
      _timer?.cancel();

      Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          print(_currentIndex);
          Provider.of<WhereToEatModel>(context, listen: false)
            ..setResultIndex(_currentIndex)
            ..setWhereToEatScreenState(WhereToEatScreenState.result);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WTEText(
            text: widget.restaurantNames[_currentIndex],
            color: AppColors.textPrimaryColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
