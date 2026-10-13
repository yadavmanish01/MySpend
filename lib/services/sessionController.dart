import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'localStorage.dart';

class SessionController {
  final LocalStorage _localStorage = LocalStorage();

  static final SessionController _session = SessionController._internal();
  static bool? isLogin;
  static String? userId;
  static Map<String, dynamic>? userDetails;

  SessionController._internal() {
    isLogin = false;
  }

  factory SessionController() {
    return _session;
  }

  /// Saves user session in secure local storage
  Future<void> saveUserInPreference(Map<String, dynamic> user) async {
    final token = user['uid'] ?? user['id'] ?? '';
    await _localStorage.saveAuthToken(token.toString());
    await _localStorage.setValue('user_details', jsonEncode(user));
    await _localStorage.setValue('isLogin', 'true');
    isLogin = true;
    userId = token.toString();
    userDetails = user;
  }

  /// Retrieves user data from local storage
  Future<void> getUserFromPreference() async {
    try {
      final token = await _localStorage.readAuthToken();
      final loginStatus = await _localStorage.readValue('isLogin');
      final userJson = await _localStorage.readValue('user_details');

      if (token != null && token.isNotEmpty && loginStatus == 'true') {
        isLogin = true;
        userId = token;
        if (userJson != null && userJson.isNotEmpty) {
          userDetails = jsonDecode(userJson) as Map<String, dynamic>;
        }
      } else {
        isLogin = false;
        userId = null;
        userDetails = null;
      }
    } catch (e) {
      debugPrint("Error reading session: $e");
      isLogin = false;
      userId = null;
      userDetails = null;
    }
  }

  /// Clears user session on logout
  Future<void> clearSession() async {
    await _localStorage.clearAuthToken();
    await _localStorage.clearValue('user_details');
    await _localStorage.clearValue('isLogin');
    isLogin = false;
    userId = null;
    userDetails = null;
  }
}
