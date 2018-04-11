import 'package:meta/meta.dart';
import 'user.dart';

@immutable
class AppState {
  final String geoHash;
  final User user;

  AppState({
    this.geoHash = '',
    this.user,
  });

  factory AppState.loading() => new AppState();

  AppState copyWith({
    String geoHash,
    User user,
  }) {
    return new AppState(
      geoHash: geoHash ?? this.geoHash,
      user: user ?? this.user,
    );
  }

  @override
  int get hashCode =>
      geoHash.hashCode ^
      user.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          geoHash == other.geoHash &&
          user == other.user;

  @override
  String toString() {
    return 'AppState{geoHash: $geoHash, user: $user}';
  }
}
