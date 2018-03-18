import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/place.dart';

class LocalStorage {
  static const String PlaceHistoryKey = 'PlaceHistoryKey';

  static getPlaceHistory() async {
    List<Place> results = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var json = prefs.getString(PlaceHistoryKey);
      if (json != null) {
        var data = JSON.decode(json) as List;
        results = data.map((item) {
          return new Place.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getPlaceHistory error: $e');
    }
    return results;
  }

  static setPlaceHistory(List<Place> places) async {
    var result = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PlaceHistoryKey, JSON.encode(places));
    } catch (e) {
      result = false;
      print('setPlaceHistory error: $e');
    }
    return result;
  }
}