import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize and fetch Remote Config defaults
  Future<void> initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults(const {
      'maintenance_mode': false,
      'app_version_name': '1.0.0',
      'currency_symbol': '₹',
    });

    await _remoteConfig.fetchAndActivate();
  }

  /// Helper Getters
  bool get isMaintenanceMode => _remoteConfig.getBool('maintenance_mode');
  String get appVersionName => _remoteConfig.getString('app_version_name');
  String get currencySymbol => _remoteConfig.getString('currency_symbol');

  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
}
