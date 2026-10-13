import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class FirebaseAppCheckService {
  final FirebaseAppCheck _appCheck = FirebaseAppCheck.instance;

  /// Initialize and Activate Firebase App Check gracefully
  Future<void> initAppCheck() async {
    try {
      await _appCheck.activate(
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.deviceCheck,
      );
    } catch (e) {
      debugPrint("AppCheck init notice: $e");
    }
  }
}
