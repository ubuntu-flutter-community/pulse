import 'dart:async';

import '../settings/settings_service.dart';

class LocationsService {
  LocationsService({
    required SettingsService settingsService,
  }) : _settingsService = settingsService;
  final SettingsService _settingsService;

  String? get lastLocation =>
      _settingsService.getString(key: SettingKeys.lastLocation);
  void setLastLocation(String? value) {
    if (value == null) return;
    _settingsService.setString(key: SettingKeys.lastLocation, value: value);
  }

  Set<String> get favLocations =>
      _settingsService
          .getStrings(key: SettingKeys.favoriteLocations)
          ?.toSet() ??
      {};
  bool isFavLocation(String value) => favLocations.contains(value);

  void addFavLocation(String name) {
    if (favLocations.contains(name)) return;
    final favs = Set<String>.from(favLocations);
    favs.add(name);
    _settingsService.setStrings(
      key: SettingKeys.favoriteLocations,
      value: favs.toList(),
    );
  }

  Future<void> removeFavLocation(String name) async {
    if (!favLocations.contains(name)) return;
    final favs = Set<String>.from(favLocations);
    favs.remove(name);
    _settingsService.setStrings(
      key: SettingKeys.favoriteLocations,
      value: favs.toList(),
    );
  }

  Stream<bool> get propertiesChanged => _settingsService.propertiesChanged;
}
