import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:my_spend/services/dynamic_icon_service.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize and fetch Remote Config defaults
  Future<void> initRemoteConfig() async {
    try {
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
        'gemini_api_key': '',
        'app_icon_theme': 'default',
      });

      await _remoteConfig.fetchAndActivate();

      // Apply dynamic icon received from Remote Config
      final iconTheme = appIconTheme;
      if (iconTheme.isNotEmpty) {
        await DynamicIconService.changeIcon(iconTheme);
      }
    } catch (e) {
      debugPrint("RemoteConfig init error: $e");
    }
  }

  /// Helper Getters
  bool get isMaintenanceMode => _remoteConfig.getBool('maintenance_mode');
  String get appVersionName => _remoteConfig.getString('app_version_name');
  String get currencySymbol => _remoteConfig.getString('currency_symbol');
  String get appIconTheme => _remoteConfig.getString('app_icon_theme');

  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
}
