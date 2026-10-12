import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class FirebaseAppCheckService {
  final FirebaseAppCheck _appCheck = FirebaseAppCheck.instance;

  /// Initialize and Activate Firebase App Check
  Future<void> initAppCheck() async {
    await _appCheck.activate(
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode
          ? AppleProvider.debug
          : AppleProvider.deviceCheck,
    );
  }
}
