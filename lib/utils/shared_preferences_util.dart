import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Utility - Local storage yönetimi
class SharedPreferencesUtil {
  static SharedPreferencesUtil? _instance;
  SharedPreferences? _prefs;

  SharedPreferencesUtil._internal();

  static Future<SharedPreferencesUtil> getInstance() async {
    _instance ??= SharedPreferencesUtil._internal();
    _instance!._prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Token yönetimi
  Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  String? getToken() {
    return _prefs?.getString('token');
  }

  Future<void> removeToken() async {
    await _prefs?.remove('token');
  }

  // User ID yönetimi
  Future<void> setUserId(int userId) async {
    await _prefs?.setInt('userId', userId);
  }

  int? getUserId() {
    return _prefs?.getInt('userId');
  }

  Future<void> removeUserId() async {
    await _prefs?.remove('userId');
  }

  // Generic get/set metodları
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> removeAll() async {
    await _prefs?.clear();
  }
}

