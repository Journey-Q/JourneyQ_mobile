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
  
  // Setup completion tracking
  bool _isSetupCompleted = false;
  bool _isInitialized = false;

  // Getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSetupCompleted => _isSetupCompleted;
  bool get isInitialized => _isInitialized;
  
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
        
        // Check if setup is completed
        _isSetupCompleted = !(await AuthRepository.isFirstTimeUser());
        
        setStatus(AuthStatus.authenticated);
      } else {
        setStatus(AuthStatus.unauthenticated);
        _isSetupCompleted = false;
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      setError('Failed to initialize authentication');
      setStatus(AuthStatus.unauthenticated);
      _isInitialized = true;
      notifyListeners();
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
    _isSetupCompleted = false;
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
    
    // Check setup status for authenticated user
    _isSetupCompleted = !(await AuthRepository.isFirstTimeUser());
    
    setStatus(AuthStatus.authenticated);
  }

  // Method to complete setup
  Future<void> completeSetup() async {
    try {
      await AuthRepository.setFirstTimeUser(false);
      _isSetupCompleted = true;
      notifyListeners();
    } catch (e) {
      setError('Failed to complete setup');
    }
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