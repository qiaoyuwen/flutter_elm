import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/place.dart';
import '../model/user.dart';

class LocalStorage {
  static const String PlaceHistoryKey = 'PlaceHistoryKey';
  static const String UserKey = 'UserKey';

  static getPlaceHistory() async {
    List<Place> results = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var json = prefs.getString(PlaceHistoryKey);
      if (json != 'null') {
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

  static getUser() async {
    User user;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var json = prefs.getString(UserKey);
      if (json != 'null') {
        user = new User.fromJson(JSON.decode(json));
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
      prefs.setString(UserKey, JSON.encode(user));
    } catch (e) {
      result = false;
      print('setUser error: $e');
    }
    return result;
  }
}