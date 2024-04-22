import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class AppModel extends SafeChangeNotifier {
  AppModel({required Connectivity connectivity})
      : _connectivity = connectivity,
        _countryCode = WidgetsBinding
            .instance.platformDispatcher.locale.countryCode
            ?.toLowerCase();

  final String? _countryCode;
  String? get countryCode => _countryCode;

  final Connectivity _connectivity;
  StreamSubscription? _subscription;
  ConnectivityResult? _result;

  bool get isOnline =>
      _result == ConnectivityResult.wifi ||
      _result == ConnectivityResult.ethernet ||
      _result == ConnectivityResult.vpn ||
      _result == ConnectivityResult.bluetooth ||
      _result == ConnectivityResult.mobile;

  Future<void> init() async {
    _subscription ??=
        _connectivity.onConnectivityChanged.listen(_updateConnectivity);
    return _connectivity.checkConnectivity().then(_updateConnectivity);
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    if (_result == result.firstOrNull) return;
    _result = result.firstOrNull;
    notifyListeners();
  }

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int value) {
    if (value == _tabIndex) return;
    _tabIndex = value;
    notifyListeners();
  }
}
