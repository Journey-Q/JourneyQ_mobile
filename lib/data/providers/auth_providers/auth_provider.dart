import 'package:flutter/foundation.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart';
import 'package:journeyq/data/models/user_model/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus status = AuthStatus.initial;
  User? user;
  String? accessToken;
  String? refreshToken;
  String? errorMessage;

  // Getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  // Initialize auth state
  Future<void> initialize() async {
    try {
      setStatus(AuthStatus.loading);

      // Load tokens from storage
      accessToken = await AuthRepository.getAccessToken();
      refreshToken = await AuthRepository.getRefreshToken();

      if (accessToken != null) {
        // Verify token and load user data
        final isValid = await verifyAndLoadUser();
        if (isValid) {
          setStatus(AuthStatus.authenticated);
        } else {
          // Try to refresh token
          final refreshed = await refreshTokenSilently();
          if (refreshed) {
            setStatus(AuthStatus.authenticated);
          } else {
            await clearAuthData();
            setStatus(AuthStatus.unauthenticated);
          }
        }
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
      }

      await AuthRepository.verifyToken();
      await loadUserProfile();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final response = await AuthRepository.getProfile();
      if (response['user'] != null || response['data'] != null) {
        final userData = response['user'] ?? response['data'];
        user = User.fromJson(userData);
        await AuthRepository.cacheUserData(userData);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<bool> refreshTokenSilently() async {
    if (refreshToken == null) return false;

    try {
      final response = await AuthRepository.refreshToken(refreshToken!);

      if (response['access_token'] != null) {
        accessToken = response['access_token'];
        refreshToken = response['refresh_token'] ?? refreshToken;

        await AuthRepository.saveTokens(accessToken!, refreshToken!);
        await loadUserProfile();
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
  }

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
      setStatus(accessToken != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated);
    }
  }
}
