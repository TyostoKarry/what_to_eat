enum WhatToEatScreenState { categories, wheelOfFortune, foodSelected }

class FoodCategory {
  final String name;
  final List<String> foodItems;
  const FoodCategory({
    required this.name,
    required this.foodItems,
  });
}

class WhatToEatModel {
  WhatToEatScreenState _whatToEatScreenState = WhatToEatScreenState.categories;
  WhatToEatScreenState get whatToEatScreenState => _whatToEatScreenState;
  void setWhatToEatScreenState(WhatToEatScreenState newState) {
    _whatToEatScreenState = newState;
  }

  static const List<FoodCategory> foodCategories = [
    FoodCategory(
        name: 'Category 1', foodItems: ['C1 Food 1', 'C1 Food 2', 'C1 Food 3']),
    FoodCategory(
        name: 'Category 2', foodItems: ['C2 Food 1', 'C2 Food 2', 'C2 Food 3']),
    FoodCategory(
        name: 'Category 3', foodItems: ['C3 Food 1', 'C3 Food 2', 'C3 Food 3']),
    FoodCategory(
        name: 'Category 4', foodItems: ['C4 Food 1', 'C4 Food 2', 'C4 Food 3']),
    FoodCategory(
        name: 'Category 5', foodItems: ['C5 Food 1', 'C5 Food 2', 'C5 Food 3']),
    FoodCategory(
        name: 'Category 6', foodItems: ['C6 Food 1', 'C6 Food 2', 'C6 Food 3']),
  ];
}
