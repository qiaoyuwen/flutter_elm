class Place {
  Place.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        geohash = json['geohash'],
        longitude = json['longitude'],
        latitude = json['latitude'];

  String name;
  String address;
  String geohash;
  num longitude;
  num latitude;

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'geohash': geohash,
    'longitude': longitude,
    'latitude': latitude,
  };
}
