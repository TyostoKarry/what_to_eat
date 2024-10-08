import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/widgets/where_to_eat/where_to_eat_slot_machine_result_animation.dart';
import 'package:what_to_eat/widgets/where_to_eat/where_to_eat_slot_machine_scroll_animation.dart';

class WhereToEatSlotMachine extends StatefulWidget {
  final List<String> restaurantNames;

  const WhereToEatSlotMachine({
    super.key,
    required this.restaurantNames,
  });

  @override
  State<WhereToEatSlotMachine> createState() => _WhereToEatSlotMachineState();
}

class _WhereToEatSlotMachineState extends State<WhereToEatSlotMachine> {
  late List<String> _shuffledRestaurants;
  late String _finalRestaurantName;
  bool _showResult = false;

  final int _minItems = 19;
  final int _singleItemHalfAnimationDuration = 1000;
  final int _delayBetweenItems = 300;

  @override
  void initState() {
    super.initState();

    _shuffledRestaurants =
        _prepareShuffledRestaurantList(widget.restaurantNames);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finalRestaurantName = _selectFinalRestaurantName();

      int lastItemDelay = (_shuffledRestaurants.length) * _delayBetweenItems;
      Future.delayed(
          Duration(milliseconds: lastItemDelay + _delayBetweenItems - 125), () {
        if (mounted) {
          setState(() {
            _showResult = true;
          });
        }
      });
    });
  }

  List<String> _prepareShuffledRestaurantList(List<String> originalList) {
    List<String> shuffledList = List.from(originalList)..shuffle();

    while (shuffledList.length < _minItems) {
      shuffledList.addAll(List.from(originalList)..shuffle());
    }

    shuffledList = shuffledList.take(_minItems).toList();
    return _removeConsecutiveDuplicates(shuffledList);
  }

  List<String> _removeConsecutiveDuplicates(List<String> list) {
    for (int i = 1; i < list.length; i++) {
      if (list[i] == list[i - 1]) {
        int swapIndex = (i + 1) % list.length;
        if (swapIndex != i && list[swapIndex] != list[i]) {
          String temp = list[i];
          list[i] = list[swapIndex];
          list[swapIndex] = temp;
        }
      }
    }

    if (list[list.length - 1] == list[list.length - 2]) {
      String temp = list[list.length - 1];
      list[list.length - 1] = list[0];
      list[0] = temp;
    }

    return list;
  }

  String _selectFinalRestaurantName() {
    String lastShuffledItem = _shuffledRestaurants.last;

    List<MapEntry<int, String>> candidates = widget.restaurantNames
        .asMap()
        .entries
        .where((entry) => entry.value != lastShuffledItem)
        .toList();

    candidates.shuffle();

    Provider.of<WhereToEatModel>(context, listen: false)
        .setResultIndex(candidates.first.key);

    return candidates.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(_shuffledRestaurants.length, (index) {
            return WhereToEatSlotMachineScrollAnimation(
              restaurantName: _shuffledRestaurants[index],
              animationDuration:
                  Duration(milliseconds: _singleItemHalfAnimationDuration * 2),
              delayBetweenItems: _delayBetweenItems,
              index: index,
              totalItems: _shuffledRestaurants.length,
            );
          }),
          if (_showResult)
            WhereToEatSlotMachineResultAnimation(
              finalRestaurantName: _finalRestaurantName,
              animationDuration:
                  Duration(milliseconds: _singleItemHalfAnimationDuration),
            ),
        ],
      ),
    );
  }
}
