import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';

  // Token expires in 30 minutes
  static const int tokenExpiryMinutes = 30;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // User data management
  static Future<void> saveUser(User user) async {
    await _prefs?.setString('user_data', jsonEncode(user.toJson()));
  }

  static User? getUser() {
    final userData = _prefs?.getString('user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  static Future<void> deleteUser() async {
    await _prefs?.remove('user_data');
  }

  // App settings
  static Future<void> setFirstLaunch(bool isFirst) async {
    await _prefs?.setBool('first_launch', isFirst);
  }

  static bool isFirstLaunch() {
    return _prefs?.getBool('first_launch') ?? true;
  }

  // Camera settings
  static Future<void> setFlashEnabled(bool enabled) async {
    await _prefs?.setBool('flash_enabled', enabled);
  }

  static bool isFlashEnabled() {
    return _prefs?.getBool('flash_enabled') ?? false;
  }

  // Branch management
  static Future<void> saveSelectedBranchId(String branchId) async {
    await _prefs?.setString('selected_branch_id', branchId);
  }

  static Future<String?> getSelectedBranchId() async {
    return _prefs?.getString('selected_branch_id');
  }

  // Save authentication data
  static Future<void> saveAuthData(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(
      Duration(minutes: tokenExpiryMinutes),
    );

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_tokenExpiryKey, expiryTime.toIso8601String());
    await prefs.setString(_userDataKey, userData.toString());
  }

  // Get stored token if not expired
  static Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryString = prefs.getString(_tokenExpiryKey);

    if (token == null || expiryString == null) {
      return null;
    }

    final expiryTime = DateTime.parse(expiryString);
    if (DateTime.now().isAfter(expiryTime)) {
      // Token expired, clear storage
      await clearAuthData();
      return null;
    }

    return token;
  }

  // Check if user is logged in and token is valid
  static Future<bool> isLoggedIn() async {
    final token = await getValidToken();
    return token != null;
  }

  // Clear all authentication data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_userDataKey);
  }

  // Get stored user data
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataKey);
  }

  // Update token expiry (refresh the 30-minute timer)
  static Future<void> refreshTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null) {
      final newExpiryTime = DateTime.now().add(
        Duration(minutes: tokenExpiryMinutes),
      );
      await prefs.setString(_tokenExpiryKey, newExpiryTime.toIso8601String());
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await deleteToken();
    await deleteUser();
    await _prefs?.clear();
  }
}
