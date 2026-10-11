import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Notifications & Request User Permission
  Future<void> initNotifications() async {
    // Request permission (iOS and Web)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          // Foreground notification received
        }
      });

      // Handle notification open app from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // App opened from notification
      });
    }
  }

  /// Get FCM Device Token
  Future<String?> getDeviceToken() async {
    try {
      return await _messaging.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Subscribe to Topic (e.g. 'budget_alerts', 'daily_reminders')
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
}
