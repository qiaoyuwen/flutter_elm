import '../model/app_state.dart';
import 'app_action.dart';

AppState appReducer(AppState state, action) {
  if (action is UpdateGeoHashAction) {
    return state.copyWith(geoHash: action.geoHash);
  } else if (action is LoginAction) {
    return state.copyWith(user: action.user);
  }
  return state;
}