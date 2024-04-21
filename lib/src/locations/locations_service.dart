import 'dart:async';

import '../../constants.dart';
import '../../utils.dart';

class LocationsService {
  String? _lastLocation;
  String? get lastLocation => _lastLocation;
  void setLastLocation(String? value) {
    if (value == _lastLocation) return;
    writeAppState(kLastLocation, value).then((_) {
      _lastLocationController.add(true);
      _lastLocation = value;
    });
  }

  final _lastLocationController = StreamController<bool>.broadcast();
  Stream<bool> get lastLocationChanged => _lastLocationController.stream;

  Set<String> _favLocations = {};
  Set<String> get favLocations => _favLocations;
  bool isFavLocation(String value) => _favLocations.contains(value);
  final _favLocationsController = StreamController<bool>.broadcast();
  Stream<bool> get favLocationsChanged => _favLocationsController.stream;

  void addFavLocation(String name) {
    if (favLocations.contains(name)) return;
    _favLocations.add(name);
    writeStringIterable(
      iterable: _favLocations,
      filename: kFavLocationsFileName,
    ).then((_) => _favLocationsController.add(true));
  }

  Future<void> removeFavLocation(String name) async {
    if (!favLocations.contains(name)) return;
    _favLocations.remove(name);
    return writeStringIterable(
      iterable: _favLocations,
      filename: kFavLocationsFileName,
    ).then((_) => _favLocationsController.add(true));
  }

  Future<void> init() async {
    _lastLocation = (await readAppState(kLastLocation)) as String?;
    _favLocations = Set.from(
      (await readStringIterable(filename: kFavLocationsFileName) ?? <String>{}),
    );
  }

  Future<void> dispose() async {
    await _favLocationsController.close();
    await _lastLocationController.close();
  }
}
