import '../model/app_state.dart';
import 'app_action.dart';

AppState appReducer(AppState state, action) {
  if (action is UpdateGeoHashAction) {
    return state.copyWith(geoHash: action.geoHash);
  }
  return state;
}