import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_view_title.dart';
import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_api_error.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_initial.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_loading.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_location_service_disabled.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_result.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_slot_machine.dart';

class WhereToEatScreen extends StatefulWidget {
  const WhereToEatScreen({super.key});

  @override
  State<WhereToEatScreen> createState() => _WhereToEatScreenState();
}

class _WhereToEatScreenState extends State<WhereToEatScreen> {
  List<dynamic> _restaurants = [];

  Future<void> _searchNearbyRestaurants() async {
    final model = Provider.of<WhereToEatModel>(context, listen: false);
    model.setWhereToEatScreenState(WhereToEatScreenState.loading);
    Position position;

    if (_restaurants.isNotEmpty) {
      model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
      return;
    }

    try {
      position = await model.getUserLocation();
    } catch (error) {
      print("Error getting user location: $error");
      model.setWhereToEatScreenState(
          WhereToEatScreenState.locationServiceDisabled);
      return;
    }

    try {
      List<dynamic> restaurants = await model.searchRestaurantsNearby(
          position.latitude, position.longitude);

      setState(() {
        _restaurants = restaurants;
      });
      model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
      return;
    } catch (error) {
      print("Error getting restaurants: $error");
      model.setWhereToEatScreenState(WhereToEatScreenState.apiError);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getWhereToEatBackground(),
        ),
        child: Column(
          children: [
            WTEViewTitle(
              titleText: "Where To Eat",
              padding: EdgeInsets.only(top: 60, bottom: 20),
            ),
            Expanded(
              child: Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  return _buildContent(model.whereToEatScreenState);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  return WTEButton(
                    text: model.whereToEatScreenState ==
                            WhereToEatScreenState.apiError
                        ? "Retry"
                        : "Where To Eat",
                    textColor: AppColors.textSecondaryColor,
                    gradientColors: [
                      AppColors.whereToEatButtonPrimaryColor,
                      AppColors.whereToEatButtonSecondaryColor
                    ],
                    colorEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.slotMachine,
                    splashEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.slotMachine,
                    tapEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.slotMachine,
                    onTap: () async {
                      await _searchNearbyRestaurants();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(WhereToEatScreenState _WhereToEatScreenState) {
    switch (_WhereToEatScreenState) {
      case WhereToEatScreenState.initial:
        return WhereToEatInitial();
      case WhereToEatScreenState.loading:
        return WhereToEatLoading();
      case WhereToEatScreenState.locationServiceDisabled:
        return WhereToEatLocationServiceDisabled();
      case WhereToEatScreenState.apiError:
        return WhereToEatApiError();
      case WhereToEatScreenState.slotMachine:
        final List<String> restaurantNames = _restaurants
            .where((restaurant) => restaurant['tags']['name'] != null)
            .map((restaurant) => restaurant['tags']['name'] as String)
            .toList();
        return WhereToEatSlotMachine(restaurantNames: restaurantNames);
      case WhereToEatScreenState.result:
        if (_restaurants.isEmpty) {
          return WhereToEatNoRestaurants();
        } else {
          return WhereToEatResult(restaurants: _restaurants);
        }
    }
  }
}
