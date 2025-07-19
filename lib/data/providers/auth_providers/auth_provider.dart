import 'package:flutter/foundation.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart';
import 'package:journeyq/data/models/user_model/user_model.dart';
import 'package:journeyq/core/services/api_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  // Private constructor
  AuthProvider._internal();
  
  // Single instance
  static final AuthProvider _instance = AuthProvider._internal();
  
  // Factory constructor returns the same instance
  factory AuthProvider() {
    return _instance;
  }

  AuthStatus status = AuthStatus.initial;
  User? user;
  String? accessToken;
  String? refreshToken;
  String? errorMessage;

  // Getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  
  // Additional getter for interceptors
  String? getAccessToken() => accessToken;
  bool get isTokenValid => accessToken != null;

  // Initialize auth state
  Future<void> initialize() async {
    try {
      setStatus(AuthStatus.loading);
      ApiService.initialize(this);

      // Load tokens from storage
      accessToken = await AuthRepository.getAccessToken();

      if (accessToken != null) {
        // Try to load user data if token exists
        await verifyAndLoadUser();
        setStatus(AuthStatus.authenticated);
      } else {
        setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      setError('Failed to initialize authentication');
      setStatus(AuthStatus.unauthenticated);
    }
  }

  Future<bool> verifyAndLoadUser() async {
    try {
      final cachedUser = await AuthRepository.getCachedUserData();
      if (cachedUser != null) {
        user = User.fromJson(cachedUser);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAuthData() async {
    accessToken = null;
    refreshToken = null;
    user = null;
    await AuthRepository.clearTokens();
    setStatus(AuthStatus.unauthenticated);
  }

  // Method to set tokens (useful for login)
  Future<void> setTokens(String accessToken) async {
    this.accessToken = accessToken;
    if (refreshToken != null) {
      this.refreshToken = refreshToken;
    }
    
    // Save tokens to storage
    await AuthRepository.saveTokens(accessToken);
    setStatus(AuthStatus.authenticated);
  }

  // Method to update tokens (useful for token refresh)
  

  void setStatus(AuthStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  void setUser(User newUser) {
    user = newUser;
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  void setError(String message) {
    errorMessage = message;
    status = AuthStatus.error;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    if (status == AuthStatus.error) {
      setStatus(
        accessToken != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
    }
  }

  // Method to handle logout
  Future<void> logout() async {
    try {
      setStatus(AuthStatus.loading);
      await clearAuthData();
      // Optionally call logout API here
    } catch (e) {
      setError('Failed to logout');
    }
  }
}