import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_api_error.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_initial.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_loading.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_location_service_disabled.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_result.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_slot_machine.dart';
import 'package:what_to_eat/widgets/wte_button.dart';
import 'package:what_to_eat/widgets/wte_safe_area.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WhereToEatScreen extends StatefulWidget {
  const WhereToEatScreen({super.key});

  @override
  State<WhereToEatScreen> createState() => _WhereToEatScreenState();
}

class _WhereToEatScreenState extends State<WhereToEatScreen> {
  List<dynamic> _restaurants = [];
  Set<String> selected = {'Restaurants', 'Fast Food'};
  Set<String> previousSelected = {};

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

    _filterRestaurantsBasedOnSelection(model);

    try {
      position = await model.getUserLocation();
    } catch (error) {
      model.setWhereToEatScreenState(
          WhereToEatScreenState.locationServiceDisabled);
      return;
    }

    const locationThreshold = 0.05; // Approx 50 meters
    if (Geolocator.distanceBetween(
            model.searchedRestaurantsNearby.latitude,
            model.searchedRestaurantsNearby.longitude,
            position.latitude,
            position.longitude) <
        locationThreshold) {
      model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
      return;
    }

    if (_restaurants.isNotEmpty &&
        previousSelected.length == selected.length &&
        previousSelected.containsAll(selected)) {
      model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
      return;
    }
    previousSelected = selected;

    try {
      await model.searchRestaurantsNearby(
          position.latitude, position.longitude);
    } catch (error) {
      model.setWhereToEatScreenState(WhereToEatScreenState.apiError);
      return;
    }

    _filterRestaurantsBasedOnSelection(model);

    if (_restaurants.isEmpty) {
      model.setWhereToEatScreenState(WhereToEatScreenState.noRestaurants);
      return;
    }
    model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
    return;
  }

  void _filterRestaurantsBasedOnSelection(WhereToEatModel model) {
    if (selected.contains('Restaurants')) {
      _restaurants = model.searchedRestaurantsNearby.regularRestaurants;
    }
    if (selected.contains('Fast Food')) {
      _restaurants = model.searchedRestaurantsNearby.fastFoodRestaurants;
    }
    if (selected.length == 2) {
      _restaurants = model.searchedRestaurantsNearby.allRestaurants;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WTESafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.getWhereToEatBackground(),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: Consumer<WhereToEatModel>(
                  builder: (context, model, child) {
                    return _buildContent(model.whereToEatScreenState);
                  },
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 10),
              Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  bool isEnabled = model.whereToEatScreenState !=
                          WhereToEatScreenState.loading &&
                      model.whereToEatScreenState !=
                          WhereToEatScreenState.slotMachine;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'Restaurants',
                            label: Text('Restaurants'),
                            icon: Icon(Icons.close),
                          ),
                          ButtonSegment<String>(
                            value: 'Fast Food',
                            label: Text('Fast Food'),
                            icon: Icon(Icons.close),
                          ),
                        ],
                        selected: selected,
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.whereToEatButtonPrimaryColor
                                    .withOpacity(0.5);
                              }
                              return Colors.transparent;
                            },
                          ),
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: AppColors.textPrimaryColor,
                            ),
                          ),
                          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return TextStyle(
                                  color: AppColors.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                      color: const Color.fromARGB(20, 0, 0, 0),
                                    ),
                                  ],
                                );
                              }
                              return TextStyle(
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.normal,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                    color: const Color.fromARGB(20, 0, 0, 0),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        onSelectionChanged: isEnabled
                            ? (Set<String> newSelection) {
                                setState(() {
                                  if (newSelection.isEmpty &&
                                      selected.first == 'Restaurants') {
                                    selected = {'Fast Food'};
                                    return;
                                  }
                                  if (newSelection.isEmpty &&
                                      selected.first == 'Fast Food') {
                                    selected = {'Restaurants'};
                                    return;
                                  }
                                  selected = newSelection;
                                });
                              }
                            : null,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Consumer<WhereToEatModel>(
                  builder: (context, model, child) {
                    bool isEnabled = model.whereToEatScreenState !=
                            WhereToEatScreenState.loading &&
                        model.whereToEatScreenState !=
                            WhereToEatScreenState.slotMachine;

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
                      colorEnabled: isEnabled,
                      splashEnabled: isEnabled,
                      tapEnabled: isEnabled,
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
      ),
    );
  }

  Widget _buildContent(WhereToEatScreenState whereToEatScreenState) {
    switch (whereToEatScreenState) {
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
