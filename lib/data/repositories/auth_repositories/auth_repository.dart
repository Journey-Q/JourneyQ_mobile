import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepository {
  static final ErrorHandler errorHandler = ErrorHandler();

  // Login with email and password
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Login with Google/social
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final response = await ApiService.post('/auth/google-login', data: {
        // Google credentials would go here
      });
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await ApiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      });
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API fails
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Refresh authentication token
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await ApiService.post('/auth/access', data: {
        'refresh_token': refreshToken,
      });
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Verify current token
  static Future<Map<String, dynamic>> verifyToken() async {
    try {
      final response = await ApiService.get('/auth/verify');
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('/user/profile');
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? bio,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (bio != null) data['bio'] = bio;

      final response = await ApiService.put('/user/profile', data: data);
      return response.data;
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Token management helper methods
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  static Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token');
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refresh_token');
    } catch (e) {
      return null;
    }
  }

  // Cache user data locally
  static Future<void> cacheUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      throw ErrorHandler.handleException(e as Exception);
    }
  }

  // Get cached user data
  static Future<Map<String, dynamic>?> getCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return jsonDecode(userData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}