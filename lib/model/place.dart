class Place {
  Place.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        geohash = json['geohash'],
        longitude = num.parse(json['longitude'].toString()),
        latitude = num.parse(json['latitude'].toString());

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
