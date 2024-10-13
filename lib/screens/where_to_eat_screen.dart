import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_api_error.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_initial.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_loading.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_location_error.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_result.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_slot_machine.dart';
import 'package:what_to_eat/widgets/wte_button.dart';
import 'package:what_to_eat/widgets/wte_safe_area.dart';
import 'package:what_to_eat/widgets/wte_segmented_button.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WhereToEatScreen extends StatefulWidget {
  const WhereToEatScreen({super.key});

  @override
  State<WhereToEatScreen> createState() => _WhereToEatScreenState();
}

class _WhereToEatScreenState extends State<WhereToEatScreen> {
  List<dynamic> _restaurants = [];
  Set<String> selected = {'Restaurants'};
  final TextEditingController _cuisineController = TextEditingController();
  String? selectedCuisine;

  void _launchOpenStreetMapCopyright() async {
    final Uri searchUrl = Uri.parse('https://www.openstreetmap.org/copyright');
    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

  Future<void> getPositionAndNearbyRestaurants() async {
    final model = Provider.of<WhereToEatModel>(context, listen: false);
    model.setWhereToEatScreenState(WhereToEatScreenState.loading);
    _filterRestaurantsBasedOnSelection(model);

    Position? position;

    try {
      model.startListeningToPosition();
      position = await model.getLatestPosition();
    } catch (error) {
      return;
    }
    if (position == null) {
      return;
    }

    if (!model.searchedRestaurantsNearby.searchHasHappened) {
      _searchNearbyRestaurants(model, position);
      return;
    }

    const locationThreshold = 0.025; // Approx 25 meters
    if (Geolocator.distanceBetween(
            model.searchedRestaurantsNearby.latitude,
            model.searchedRestaurantsNearby.longitude,
            position.latitude,
            position.longitude) <
        locationThreshold) {
      if (_restaurants.isEmpty) {
        model.setWhereToEatScreenState(WhereToEatScreenState.noRestaurants);
        return;
      }
      model.setWhereToEatScreenState(WhereToEatScreenState.slotMachine);
      return;
    }

    _searchNearbyRestaurants(model, position);
  }

  Future<void> _searchNearbyRestaurants(model, position) async {
    try {
      await model.searchRestaurantsNearby(
          position.latitude, position.longitude);
      _filterRestaurantsBasedOnSelection(model);
    } catch (error) {
      model.setWhereToEatScreenState(WhereToEatScreenState.apiError);
      return;
    }

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

    if (selectedCuisine != null &&
        selectedCuisine!.isNotEmpty &&
        selectedCuisine! != 'any') {
      _restaurants = _restaurants.where((restaurant) {
        final cuisineTag = restaurant['tags']?['cuisine'];

        if (cuisineTag != null) {
          List<dynamic> cuisines = cuisineTag
              .split(RegExp(r'[;,]'))
              .map((e) => e.trim().toLowerCase())
              .toList();
          return cuisines.contains(selectedCuisine!.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  @override
  void dispose() {
    _cuisineController.dispose();
    super.dispose();
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
              SizedBox(height: 5),
              Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  bool isEnabled = model.whereToEatScreenState !=
                          WhereToEatScreenState.loading &&
                      model.whereToEatScreenState !=
                          WhereToEatScreenState.slotMachine;
                  return WTESegmentedButton(
                    options: ['Restaurants', 'Fast Food'],
                    selected: selected,
                    selectedIcons: [
                      Icons.restaurant_outlined,
                      Icons.fastfood_outlined
                    ],
                    unselectedIcons: [Icons.close, Icons.close],
                    multiSelectionEnabled: true,
                    allowEmptySelection: false,
                    isEnabled: isEnabled,
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        selected = newSelection;
                      });
                    },
                  );
                },
              ),
              Consumer<WhereToEatModel>(
                builder: (context, model, child) {
                  List<String> cuisineEntries =
                      model.cuisineEntries.map((cuisine) {
                    return cuisine.split('_').map((word) {
                      return word[0].toUpperCase() + word.substring(1);
                    }).join(' ');
                  }).toList();

                  bool isEnabled = model.whereToEatScreenState !=
                          WhereToEatScreenState.loading &&
                      model.whereToEatScreenState !=
                          WhereToEatScreenState.slotMachine;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: DropdownSearch<String>(
                      items: (filter, infiniteScrollProps) => cuisineEntries,
                      enabled: isEnabled,
                      popupProps: PopupProps.menu(
                        searchDelay: Duration(milliseconds: 100),
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints.tightFor(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 200,
                        ),
                        menuProps: MenuProps(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                      ),
                      onChanged: (value) {
                        if (value == 'Any') {
                          setState(() {
                            selectedCuisine = null;
                          });
                        } else if (value != null) {
                          setState(() {
                            selectedCuisine = value;
                          });
                        }
                      },
                      selectedItem: selectedCuisine,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          hintText: 'Select Specific Cuisine: ',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 0.3),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                          ),
                        ),
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
                        await getPositionAndNearbyRestaurants();
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
        return WhereToEatLocationError(
          titleText: "Location Service",
          subtitleText: "Is Disabled",
          buttonText: "Open Location Settings",
          onTap: () {
            Geolocator.openLocationSettings();
          },
        );
      case WhereToEatScreenState.locationPermissionDenied:
        return WhereToEatLocationError(
          titleText: "Location Permission",
          subtitleText: "Is Denied",
          buttonText: "Open App Settings",
          onTap: () {
            Geolocator.openAppSettings();
          },
        );
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
