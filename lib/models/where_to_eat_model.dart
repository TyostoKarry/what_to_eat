import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

enum WhereToEatScreenState {
  initial,
  loading,
  locationServiceDisabled,
  apiError,
  slotMachine,
  noRestaurants,
  result
}

class RestaurantsNearby {
  List<dynamic> allRestaurants;
  List<dynamic> regularRestaurants;
  List<dynamic> fastFoodRestaurants;
  double latitude = 0;
  double longitude = 0;

  RestaurantsNearby({
    required this.allRestaurants,
    required this.regularRestaurants,
    required this.fastFoodRestaurants,
    required this.latitude,
    required this.longitude,
  });
}

class WhereToEatModel extends ChangeNotifier {
  WhereToEatScreenState _whereToEatScreenState = WhereToEatScreenState.initial;
  WhereToEatScreenState get whereToEatScreenState => _whereToEatScreenState;

  RestaurantsNearby _searchedRestaurantsNearby = RestaurantsNearby(
    allRestaurants: [],
    regularRestaurants: [],
    fastFoodRestaurants: [],
    latitude: 0,
    longitude: 0,
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

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> searchRestaurantsNearby(double lat, double lon) async {
    String overpassUrl = 'https://overpass-api.de/api/interpreter';

    String overpassQuery = """
  [out:json];
  node
    ["amenity"~"restaurant|fast_food"]
    (around:200,$lat,$lon);
  out body;
  """;

    try {
      final response = await http.post(
        Uri.parse(overpassUrl),
        body: {'data': overpassQuery},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final json = jsonDecode(decodedBody);

        List<dynamic> allRestaurants = json['elements'];
        List<dynamic> fastFoodRestaurants = allRestaurants
            .where((element) => element['tags']['amenity'] == 'fast_food')
            .toList();
        List<dynamic> regularRestaurants = allRestaurants
            .where((element) => element['tags']['amenity'] == 'restaurant')
            .toList();

        _searchedRestaurantsNearby = RestaurantsNearby(
          allRestaurants: allRestaurants,
          regularRestaurants: regularRestaurants,
          fastFoodRestaurants: fastFoodRestaurants,
          latitude: lat,
          longitude: lon,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data');
    }
  }
}
