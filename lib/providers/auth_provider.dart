import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _setLoading(true);

    try {
      // Initialize API service
      await ApiService.init();

      // Check if user is already logged in with valid token
      final isLoggedIn = await ApiService.isLoggedIn();
      if (isLoggedIn) {
        // Try to get user data (this would require implementing a getUserProfile API call)
        try {
          // For now, just set authenticated to true
          _isAuthenticated = true;
          // Note: You might want to add a getUserProfile API call here to get fresh user data
        } catch (e) {
          // If getting user data fails, clear auth
          await _clearAuthData();
        }
      }
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.login(email, password);

      if (response['user'] != null && response['access_token'] != null) {
        _user = User.fromJson(response['user']);
        _isAuthenticated = true;

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Invalid response from server');
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await ApiService.logout();
    } catch (e) {
      // Continue with logout even if API call fails
      if (kDebugMode) {
        print('Logout API call failed: $e');
      }
    }

    await _clearAuthData();
    _setLoading(false);
  }

  Future<void> _clearAuthData() async {
    _user = null;
    _isAuthenticated = false;
    await StorageService.clearAuthData();
    notifyListeners();
  }

  // Call this method on user activity to refresh session
  Future<void> refreshSession() async {
    if (_isAuthenticated) {
      await ApiService.refreshSession();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
