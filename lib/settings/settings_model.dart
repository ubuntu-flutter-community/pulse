import 'dart:async';

import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'settings_service.dart';

class SettingsModel extends SafeChangeNotifier {
  SettingsModel({
    required SettingsService service,
  }) : _service = service;

  final SettingsService _service;

  StreamSubscription<bool>? _propertiesChangedSub;

  String? getString({required String key}) => _service.getString(key: key);
  Future<String?> getStringSecure({required String key}) =>
      _service.getStringSecure(key: key);
  void setString({
    required String key,
    required String value,
    bool secure = false,
  }) async =>
      _service.setString(
        key: key,
        value: value,
        secure: secure,
      );

  void init() => _propertiesChangedSub ??=
      _service.propertiesChanged.listen((_) => notifyListeners());

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
