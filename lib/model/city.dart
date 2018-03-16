import 'dart:convert';

class City {
  City.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        pinyin = json['name'],
        abbr = json['abbr'],
        areaCode = json['areaCode'],
        isMap = json['isMap'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        sort = json['sort'];

  int id;
  String name;
  String pinyin;
  String abbr;
  String areaCode;
  bool isMap;
  num longitude;
  num latitude;
  int sort;
}
