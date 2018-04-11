import 'package:redux/redux.dart';
import '../model/app_state.dart';
import '../store/app_reducer.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState.loading(),
);