import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

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

  // Clear all data
  static Future<void> clearAllData() async {
    await deleteToken();
    await deleteUser();
    await _prefs?.clear();
  }
}
