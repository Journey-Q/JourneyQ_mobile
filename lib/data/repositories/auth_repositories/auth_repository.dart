import 'package:flutter/material.dart';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journeyq/data/models/user_model/user_model.dart';
import 'package:journeyq/core/storage/localstorage.dart';

class AuthRepository {
  static final authProvider = AuthProvider();

  // Login with email and password
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      // Save the complete auth response data
      if (response.data != null) {
        await saveAuthResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorage(prefs: prefs);
    return await localStorage.isFirstTimeUser();
  }

  static Future<void> setFirstTimeUser(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorage(prefs: prefs);
    return await localStorage.setFirstTimeUser(isFirstTime);
  }

  // Login with Google/social
  static Future<Map<String, dynamic>> loginWithGoogle(
    GoogleSignInAccount googleUser,
  ) async {
    try {
      final response = await ApiService.post(
        '/auth/oauth',
        data: {
          'name': googleUser.displayName ?? '',
          'email': googleUser.email,
          'photourl': googleUser.photoUrl ?? '',
        },
      );

      // Save the complete auth response data
      if (response.data != null) {
        await saveAuthResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      // Save the complete auth response data
      if (response.data != null) {
        await saveAuthResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout');
      // Clear all stored auth data
      await clearTokens();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Refresh authentication token
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await ApiService.post(
        '/auth/access',
        data: {'refresh_token': refreshToken},
      );

      // Save the refreshed auth response data
      if (response.data != null) {
        await saveAuthResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Verify current token
  static Future<Map<String, dynamic>> verifyToken() async {
    try {
      final response = await ApiService.get('/auth/verify');
      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('/user/profile');
      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile(
    BuildContext context, {
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

      // Update cached user data if profile update is successful
      if (response.data != null && response.data['user'] != null) {
        await cacheUserData(response.data['user']);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Save complete AuthResponse according to DTO structure
  static Future<void> saveAuthResponse(
    Map<String, dynamic> authResponse,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save access token to SharedPreferences
      if (authResponse['accessToken'] != null) {
        await prefs.setString('access_token', authResponse['accessToken']);
      }

      // Save token type (default to "Bearer" if not provided)
      final tokenType = authResponse['tokenType'] ?? 'Bearer';
      await prefs.setString('token_type', tokenType);

      // Save expiration time
      if (authResponse['expiresIn'] != null) {
        // Calculate absolute expiration time
        final expiresIn = authResponse['expiresIn'] as int;
        final expirationTime =
            DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
        await prefs.setInt('token_expires_at', expirationTime);
        await prefs.setInt('expires_in', expiresIn);

      }

      // Save user data to SharedPreferences
     if (authResponse['user'] != null) {
  await prefs.setString('user_data', jsonEncode(authResponse['user']));
  
  // Store whether user is set up (not inverted)
  bool isSetup = authResponse['user']['isSetup'] ?? false;
  await prefs.setBool('is_setup', isSetup);
}

      // ===== NEW: Update AuthProvider =====

      // Set access token in AuthProvider
      if (authResponse['accessToken'] != null) {
        authProvider.accessToken = authResponse['accessToken'];
      }

      // Set user data in AuthProvider
      if (authResponse['user'] != null) {
        try {
          final userModel = User.fromJson(authResponse['user']);
          authProvider.setUser(userModel);
        } catch (e) {
          // If User model creation fails, still set authenticated status
          print('Failed to create User model: $e');
          authProvider.setStatus(AuthStatus.authenticated);
        }
      } else {
        // No user data but token exists, set authenticated status
        authProvider.setStatus(AuthStatus.authenticated);
      }
    } catch (e) {
      // If something fails, set error status in AuthProvider
      authProvider.setError('Failed to save auth response: ${e.toString()}');
      throw Exception('Failed to save auth response: ${e.toString()}');
    }
  }

  // Legacy method - kept for backward compatibility
  static Future<void> saveTokens(String accessToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
    } catch (e) {
      throw Exception('Failed to save tokens: ${e.toString()}');
    }
  }

  static Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('token_type');
      await prefs.remove('expires_in');
      await prefs.remove('token_expires_at');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
      await prefs.remove('first_time_user');
      authProvider.setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      throw Exception('Failed to clear tokens: ${e.toString()}');
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

  // Get token type
  static Future<String?> getTokenType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token_type') ?? 'Bearer';
    } catch (e) {
      return 'Bearer';
    }
  }

  // Get expiration time in seconds
  static Future<int?> getExpiresIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('expires_in');
    } catch (e) {
      return null;
    }
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expirationTime = prefs.getInt('token_expires_at');

      if (expirationTime == null) return true;

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return currentTime >= expirationTime;
    } catch (e) {
      return true;
    }
  }

  // Get complete auth data
  static Future<Map<String, dynamic>?> getAuthData() async {
    try {
      final accessToken = await getAccessToken();
      final tokenType = await getTokenType();
      final expiresIn = await getExpiresIn();
      final userData = await getCachedUserData();

      if (accessToken == null) return null;

      return {
        'accessToken': accessToken,
        'tokenType': tokenType,
        'expiresIn': expiresIn,
        'user': userData,
      };
    } catch (e) {
      return null;
    }
  }

  // Get formatted authorization header
  static Future<String?> getAuthorizationHeader() async {
    try {
      final accessToken = await getAccessToken();
      final tokenType = await getTokenType();

      if (accessToken == null) return null;

      return '$tokenType $accessToken';
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
      throw Exception('Failed to cache user data: ${e.toString()}');
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
