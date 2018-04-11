import 'package:meta/meta.dart';

@immutable
class AppState {
  final String geoHash;

  AppState({
    this.geoHash = '',
  });

  factory AppState.loading() => new AppState();

  AppState copyWith({
    String geoHash,
  }) {
    return new AppState(geoHash: geoHash ?? this.geoHash);
  }

  @override
  int get hashCode => geoHash.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          geoHash == other.geoHash;

  @override
  String toString() {
    return 'AppState{geoHash: $geoHash}';
  }
}
