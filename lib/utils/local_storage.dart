import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/place.dart';
import '../model/user.dart';

class LocalStorage {
  static const String PlaceHistoryKey = 'PlaceHistoryKey';
  static const String UserKey = 'UserKey';
  static const String SearchHistoryKey = 'SearchHistoryKey';

  static getPlaceHistory() async {
    List<Place> results = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonStr = prefs.getString(PlaceHistoryKey);
      if (jsonStr != 'null') {
        var data = json.decode(jsonStr) as List;
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
      prefs.setString(PlaceHistoryKey, json.encode(places));
    } catch (e) {
      result = false;
      print('setPlaceHistory error: $e');
    }
    return result;
  }

  static getUser() async {
    User user;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonStr = prefs.getString(UserKey);
      if (jsonStr != 'null') {
        user = new User.fromJson(json.decode(jsonStr));
      }
    } catch (e) {
      print('getUser error: $e');
    }
    return user;
  }

  static setUser(User user) async {
    var result = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(UserKey, json.encode(user));
    } catch (e) {
      result = false;
      print('setUser error: $e');
    }
    return result;
  }

  static getSearchHistory() async {
    List<String> history = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonStr = prefs.getString(SearchHistoryKey);
      if (jsonStr != null) {
        (json.decode(jsonStr) as List).forEach((item) => history.add(item));
      }
    } catch (e) {
      print('getSearchHistory error: $e');
    }
    return history;
  }

  static setSearchHistory(List<String> history) async {
    var result = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SearchHistoryKey, json.encode(history));
    } catch (e) {
      result = false;
      print('setSearchHistory error: $e');
    }
    return result;
  }
}