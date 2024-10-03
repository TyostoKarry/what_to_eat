import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

enum WhereToEatScreenState {
  initial,
  loading,
  locationServiceDisabled,
  apiError,
  rolling,
  result
}

class WhereToEatModel extends ChangeNotifier {
  WhereToEatScreenState _whereToEatScreenState = WhereToEatScreenState.initial;
  WhereToEatScreenState get whereToEatScreenState => _whereToEatScreenState;

  void setWhereToEatScreenState(WhereToEatScreenState newState) {
    _whereToEatScreenState = newState;
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

  Future<List<dynamic>> searchRestaurantsNearby(double lat, double lon) async {
    String overpassUrl = 'https://overpass-api.de/api/interpreter';

    String overpassQuery = """
  [out:json];
  node
    ["amenity"="restaurant"]
    (around:200,$lat,$lon);
  out body;
  """;

    final response = await http.post(
      Uri.parse(overpassUrl),
      body: {'data': overpassQuery},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['elements'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
