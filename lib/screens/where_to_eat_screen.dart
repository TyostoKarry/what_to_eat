import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_view_title.dart';
import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

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
      model.setWhereToEatScreenState(WhereToEatScreenState.rolling);
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
                    text: "Where To Eat",
                    textColor: AppColors.textSecondaryColor,
                    gradientColors: [
                      AppColors.whereToEatButtonPrimaryColor,
                      AppColors.whereToEatButtonSecondaryColor
                    ],
                    colorEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.rolling,
                    splashEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.rolling,
                    tapEnabled: model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.rolling,
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
        return Center(
          child: Text("Initial"),
        );
      case WhereToEatScreenState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case WhereToEatScreenState.locationServiceDisabled:
        return Center(
          child: Text("locationServiceDisabled"),
        );
      case WhereToEatScreenState.apiError:
        return Center(
          child: Text("apiError"),
        );
      case WhereToEatScreenState.rolling:
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      case WhereToEatScreenState.result:
        if (_restaurants.isEmpty) {
          return const Center(
            child: Text("No restaurants found"),
          );
        } else {
          return Center(
            child: Text(_restaurants[0]['tags']['name']),
          );
        }
    }
  }
}
