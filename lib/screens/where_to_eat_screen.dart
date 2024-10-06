import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_text.dart';
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

  void _launchOpenStreetMapCopyright() async {
    final Uri searchUrl = Uri.parse('https://www.openstreetmap.org/copyright');
    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

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
      if (_restaurants.isEmpty) {
        model.setWhereToEatScreenState(WhereToEatScreenState.noRestaurants);
        return;
      }
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
            Expanded(
              child: Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  return _buildContent(model.whereToEatScreenState);
                },
              ),
            ),
            GestureDetector(
              onTap: _launchOpenStreetMapCopyright,
              child: const WTEText(
                  text: "Map data from OpenStreetMap",
                  color: AppColors.textPrimaryColor,
                  fontSize: 12,
                  minFontSize: 12,
                  textDecoration: TextDecoration.underline),
            ),
            GestureDetector(
              onTap: _launchOpenStreetMapCopyright,
              child: const WTEText(
                  text: "Providing real-time location-based restaurant data",
                  color: AppColors.textPrimaryColor,
                  fontSize: 12,
                  minFontSize: 12,
                  textDecoration: TextDecoration.underline),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
      case WhereToEatScreenState.noRestaurants:
        return WhereToEatNoRestaurants();
      case WhereToEatScreenState.result:
        return WhereToEatResult(restaurants: _restaurants);
    }
  }
}
