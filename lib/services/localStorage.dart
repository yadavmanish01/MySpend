import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final _storage = const FlutterSecureStorage();

  static const String _authTokenKey = 'auth_token';

  /// Save Auth Token securely
  Future<bool> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
    return true;
  }

  /// Read Auth Token securely
  Future<String?> readAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  /// Clear Auth Token
  Future<bool> clearAuthToken() async {
    await _storage.delete(key: _authTokenKey);
    return true;
  }

  /// Sets a key-value pair in secure local storage.
  Future<bool> setValue(String key, String value) async {
    await _storage.write(key: key, value: value);
    return true;
  }

  /// Reads value associated with key
  Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Clears key
  Future<bool> clearValue(String key) async {
    await _storage.delete(key: key);
    return true;
  }
}
