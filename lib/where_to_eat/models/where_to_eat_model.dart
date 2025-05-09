import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

enum WhereToEatScreenState {
  initial,
  loading,
  locationServiceDisabled,
  locationPermissionDenied,
  apiError,
  slotMachine,
  listRestaurants,
  result
}

class RestaurantsNearby {
  List<dynamic> allRestaurants;
  double latitude = 0;
  double longitude = 0;
  bool searchHasHappened = false;

  RestaurantsNearby({
    required this.allRestaurants,
    required this.latitude,
    required this.longitude,
    required this.searchHasHappened,
  });
}

class WhereToEatModel extends ChangeNotifier {
  WhereToEatScreenState _whereToEatScreenState = WhereToEatScreenState.initial;
  WhereToEatScreenState get whereToEatScreenState => _whereToEatScreenState;

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;

  RestaurantsNearby _searchedRestaurantsNearby = RestaurantsNearby(
    allRestaurants: <dynamic>[],
    latitude: 0,
    longitude: 0,
    searchHasHappened: false,
  );
  RestaurantsNearby get searchedRestaurantsNearby => _searchedRestaurantsNearby;

  int _resultIndex = 0;
  int get resultIndex => _resultIndex;

  double _nameTextHeight = 0.0;
  double get nameTextHeight => _nameTextHeight;

  void setWhereToEatScreenState(WhereToEatScreenState newState) {
    _whereToEatScreenState = newState;
    notifyListeners();
  }

  void setResultIndex(int newIndex) {
    _resultIndex = newIndex;
    notifyListeners();
  }

  void setNameTextHeight(double newHeight) {
    _nameTextHeight = newHeight;
    notifyListeners();
  }

  void startListeningToPosition() async {
    bool permissionGranted = await _handleLocationPermission();
    if (!permissionGranted) {
      return Future<void>.error('Location permissions are denied');
    }

    if (_positionStreamSubscription != null) {
      return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<Position?> getLatestPosition() async {
    bool permissionGranted = await _handleLocationPermission();
    if (!permissionGranted) {
      return Future<Position>.error('Location permissions are denied');
    }

    if (_currentPosition == null) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition();
      } catch (error) {
        return Future<Position>.error('Failed to get location');
      }
    }
    return _currentPosition;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setWhereToEatScreenState(WhereToEatScreenState.locationServiceDisabled);
      return Future<bool>.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setWhereToEatScreenState(
          WhereToEatScreenState.locationPermissionDenied,
        );
        return Future<bool>.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setWhereToEatScreenState(WhereToEatScreenState.locationServiceDisabled);
      return Future<bool>.error('Location permissions are permanently denied.');
    }

    return true;
  }

  Future<void> searchRestaurantsNearby(double lat, double lon) async {
    String overpassUrl = 'https://overpass-api.de/api/interpreter';

    String overpassQuery = """
  [out:json];
  node
    ["amenity"~"restaurant|fast_food"]
    (around:10000,$lat,$lon);
  out body;
  """;

    try {
      final http.Response response = await http.post(
        Uri.parse(overpassUrl),
        body: <String, String>{'data': overpassQuery},
      );

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final dynamic json = jsonDecode(decodedBody);

        List<dynamic> allRestaurants = json['elements']
            .where((dynamic restaurant) => restaurant['tags']['name'] != null)
            .toList();

        for (dynamic restaurant in allRestaurants) {
          double restaurantLat = restaurant['lat'];
          double restaurantLon = restaurant['lon'];
          List<String> vegan = <String>[];
          List<String> diets = <String>[];

          double distance = Geolocator.distanceBetween(
            lat,
            lon,
            restaurantLat,
            restaurantLon,
          );

          restaurant['tags'].forEach((String key, dynamic value) {
            if (key.startsWith('diet:') &&
                (value == 'yes' || value == 'only')) {
              String dietType = key.split(':')[1];

              String formattedDiet = dietType[0].toUpperCase() +
                  dietType.substring(1).replaceAll('_', ' ');

              if (value == 'only') {
                formattedDiet += " (Only)";
              }

              if (dietType == 'vegetarian' ||
                  dietType == 'vegan' ||
                  dietType == 'pescetarian' ||
                  dietType == 'lacto_vegetarian' ||
                  dietType == 'ovo_vegetarian' ||
                  dietType == 'fruitarian') {
                vegan.add(formattedDiet);
              } else {
                diets.add(formattedDiet);
              }
            }
          });

          restaurant['tags']['vegan'] = vegan;
          restaurant['tags']['diets'] = diets;
          restaurant['tags']['distance'] = distance;
        }

        allRestaurants.sort(
          (dynamic a, dynamic b) =>
              a['tags']['distance'].compareTo(b['tags']['distance']),
        );

        _searchedRestaurantsNearby = RestaurantsNearby(
          allRestaurants: allRestaurants,
          latitude: lat,
          longitude: lon,
          searchHasHappened: true,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data');
    }
  }

  List<dynamic> filterRestaurantsBasedOnSelection(
    Set<String> selected,
    Position position,
    int searchRange,
    String? selectedCuisine,
  ) {
    List<dynamic> restaurants = filterAnenity(selected);

    restaurants = _filterDistance(restaurants, searchRange, position);

    restaurants = filterCuisine(restaurants, selectedCuisine);

    return restaurants;
  }

  List<dynamic> filterAnenity(Set<String> selected) {
    List<dynamic> filteredRestaurants = <dynamic>[];

    if (selected.contains('Restaurants')) {
      filteredRestaurants = searchedRestaurantsNearby.allRestaurants
          .where(
            (dynamic element) => element['tags']['amenity'] == 'restaurant',
          )
          .toList();
    }
    if (selected.contains('Fast Food')) {
      filteredRestaurants = searchedRestaurantsNearby.allRestaurants
          .where((dynamic element) => element['tags']['amenity'] == 'fast_food')
          .toList();
    }
    if (selected.length == 2) {
      filteredRestaurants = searchedRestaurantsNearby.allRestaurants;
    }

    return filteredRestaurants;
  }

  List<dynamic> _filterDistance(
    List<dynamic> restaurants,
    int searchRange,
    Position position,
  ) {
    List<dynamic> filteredRestaurants = restaurants.where((dynamic restaurant) {
      double restaurantLat = restaurant['lat'];
      double restaurantLon = restaurant['lon'];
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        restaurantLat,
        restaurantLon,
      );

      restaurant['tags']['distance'] = distance;
      return distance <= searchRange;
    }).toList();

    filteredRestaurants.sort(
      (dynamic a, dynamic b) =>
          a['tags']['distance'].compareTo(b['tags']['distance']),
    );

    return filteredRestaurants;
  }

  List<dynamic> filterCuisine(
    List<dynamic> restaurants,
    String? selectedCuisine,
  ) {
    if (selectedCuisine == null ||
        selectedCuisine.isEmpty ||
        selectedCuisine == 'any') {
      return restaurants;
    }

    return restaurants.where((dynamic restaurant) {
      final dynamic cuisineTag = restaurant['tags']?['cuisine'];

      if (cuisineTag != null) {
        List<dynamic> cuisines = cuisineTag
            .split(RegExp(r'[;,]'))
            .map((dynamic e) => e.trim().toLowerCase())
            .toList();
        return cuisines.contains(selectedCuisine.toLowerCase());
      }
      return false;
    }).toList();
  }

  List<dynamic> filterDistanceWithoutPosition(
    List<dynamic> restaurants,
    int searchRange,
  ) {
    List<dynamic> filteredRestaurants = restaurants
        .where(
          (dynamic restaurant) =>
              restaurant['tags']['distance'] != null &&
              restaurant['tags']['distance'] < searchRange,
        )
        .toList();

    filteredRestaurants.sort(
      (dynamic a, dynamic b) =>
          a['tags']['distance'].compareTo(b['tags']['distance']),
    );

    return filteredRestaurants;
  }

  List<String> cuisineEntries = <String>[
    "any",
    "açaí",
    "arepa",
    "bagel",
    "beef",
    "beef_bowl",
    "beef_noodle",
    "bubble_tea",
    "burger",
    "cachapa",
    "cake",
    "chicken",
    "chili",
    "chocolate",
    "churro",
    "coffee_shop",
    "couscous",
    "crepe",
    "curry",
    "donut",
    "dumpling",
    "empanada",
    "falafel",
    "fish",
    "fish_and_chips",
    "fondue",
    "fried_chicken",
    "fries",
    "frozen_yogurt",
    "gyoza",
    "gyros",
    "hot_dog",
    "hotpot",
    "ice_cream",
    "juice",
    "kebab",
    "meat",
    "noodle",
    "pancake",
    "pasta",
    "pastry",
    "piadina",
    "pie",
    "pita",
    "pizza",
    "poke",
    "potato",
    "pretzel",
    "ramen",
    "salad",
    "sandwich",
    "sausage",
    "savory_pancakes",
    "seafood",
    "shawarma",
    "smoothie",
    "smørrebrød",
    "soba",
    "soup",
    "souvlaki",
    "steak",
    "sushi",
    "tacos",
    "takoyaki",
    "tea",
    "udon",
    "waffle",
    "wings",
    "yakitori",
    "bakery",
    "bar_and_grill",
    "barbecue",
    "basque_ciderhouse",
    "bistro",
    "brasserie",
    "breakfast",
    "brunch",
    "buffet",
    "buschenschank",
    "cafe",
    "deli",
    "dessert",
    "diner",
    "fast_food",
    "fine_dining",
    "fried_food",
    "friture",
    "fusion",
    "grill",
    "heuriger",
    "international",
    "local",
    "lunch",
    "mongolian_grill",
    "pub",
    "regional",
    "snack",
    "steak_house",
    "tapas",
    "yakiniku",
    "afghan",
    "african",
    "american",
    "arab",
    "argentinian",
    "armenian",
    "asian",
    "australian",
    "austrian",
    "balkan",
    "bangladeshi",
    "basque",
    "bavarian",
    "belgian",
    "bolivian",
    "brazilian",
    "british",
    "bulgarian",
    "cajun",
    "cambodian",
    "cantonese",
    "caribbean",
    "catalan",
    "chinese",
    "colombian",
    "croatian",
    "cuban",
    "czech",
    "danish",
    "dutch",
    "egyptian",
    "ethiopian",
    "european",
    "filipino",
    "french",
    "georgian",
    "german",
    "greek",
    "hawaiian",
    "hungarian",
    "indian",
    "indonesian",
    "irish",
    "italian",
    "jamaican",
    "japanese",
    "jewish",
    "korean",
    "lao",
    "latin_american",
    "lebanese",
    "malagasy",
    "malaysian",
    "mediterranean",
    "mexican",
    "middle_eastern",
    "mongolian",
    "moroccan",
    "nepalese",
    "oriental",
    "pakistani",
    "persian",
    "peruvian",
    "polish",
    "portuguese",
    "romanian",
    "russian",
    "salvadoran",
    "senegalese",
    "serbian",
    "singaporean",
    "south_indian",
    "southern",
    "spanish",
    "sri_lankan",
    "swedish",
    "swiss",
    "syrian",
    "taiwanese",
    "tex-mex",
    "thai",
    "tibetan",
    "tunisian",
    "turkish",
    "ukrainian",
    "uzbek",
    "venezuelan",
    "vietnamese",
    "western",
  ];
}
