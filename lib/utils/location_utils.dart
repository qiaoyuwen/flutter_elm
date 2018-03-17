import 'package:location/location.dart';

class LocationUtils {
  static final location = new Location();

  static getLocation() async {
    var current;
    try {
      current = await location.getLocation;
    } catch (e) {
      print('getLocation error: $e');
    }
    return current;
  }
}