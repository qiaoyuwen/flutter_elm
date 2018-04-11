import '../model/user.dart';

class UpdateGeoHashAction {
  final String geoHash;
  UpdateGeoHashAction(this.geoHash);
}

class LoginAction {
  final User user;
  LoginAction(this.user);
}