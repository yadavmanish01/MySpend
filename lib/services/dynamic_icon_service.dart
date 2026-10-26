import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DynamicIconService {
  static const MethodChannel _channel =
      MethodChannel('com.manish.my_spend/app_icon');

  /// Changes the app icon dynamically based on the icon name provided
  static Future<void> changeIcon(String iconName) async {
    try {
      await _channel.invokeMethod('changeIcon', {'iconName': iconName});
    } catch (e) {
      debugPrint('Error changing app icon: $e');
    }
  }
}
