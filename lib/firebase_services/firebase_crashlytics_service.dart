import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics Error Handlers
  Future<void> initCrashlytics() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }

    // Flutter framework unhandled UI errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _crashlytics.recordFlutterFatalError(details);
    };

    // Asynchronous background errors
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Manually record a non-fatal or fatal error
  Future<void> recordError(
    dynamic error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Set User ID for Crash Reports
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Log Custom Message
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
