import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/data/models/user_model/user_model.dart';
import 'package:journeyq/core/storage/localstorage.dart';

class ProfileRepository {
  static final authProvider = AuthProvider();
  
  // Cloudinary folder configuration
  static const String _profileImagesFolder = 'profile_pictures';

  // Complete user profile setup
  static Future<Map<String, dynamic>> completeUserSetup(
  Map<String, dynamic> setupData,
) async {
  try {
    String? profileImageUrl;
    
    // Upload profile image first if provided using Cloudinary
    if (setupData['profile_image'] != null) {
      profileImageUrl = await uploadProfileImage(
        setupData['profile_image'] as File,
      );
      setupData['profile_image_url'] = profileImageUrl;
      setupData.remove('profile_image');
    } else if (setupData['photo_url'] != null) {
      // Use existing photo URL if provided
      setupData['profile_image_url'] = setupData['photo_url'];
      setupData.remove('photo_url');
    }
    
    final response = await ApiService.post(
      '/profile/setup',
      data: setupData,
    );
    
    // Save updated user data and mark setup as complete
    if (response.data != null) {
      await setFirstTimeUser(false);
      await authProvider.completeSetup();
    }
    
    return response.data;
  } on AppException catch (e) {
    rethrow;
  } catch (e) {
    rethrow;
  }
}

// Get user profile by ID (for viewing other users' profiles)
// Get user profile by ID (for viewing other users' profiles)
static Future<Map<String, dynamic>> getProfile(String userId) async {
  try {
    final response = await ApiService.get('/profile/$userId');
    
    // Extract actual profile data from wrapped response
    if (response.data.containsKey('data') && response.data['data'] != null) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      return response.data; // Fallback if response is not wrapped
    }
  } on AppException catch (e) {
    rethrow;
  } catch (e) {
    rethrow;
  }
}

static Future<Map<String, dynamic>> updateCompleteProfile(
  Map<String, dynamic> updateData,
) async {
  try {
    String? profileImageUrl;
    
    // Upload profile image first if provided using Cloudinary
    if (updateData['profile_image'] != null) {
      profileImageUrl = await uploadProfileImage(
        updateData['profile_image'] as File,
      );
      updateData['profile_image_url'] = profileImageUrl;
      updateData.remove('profile_image');
    }
    
    final response = await ApiService.put(
      '/profile/update',
      data: updateData,
    );
    
    // Save updated user data
    if (response.data != null) {
      await saveProfileResponse(response.data);
    }
    
    return response.data;
  } on AppException catch (e) {
    rethrow;
  } catch (e) {
    rethrow;
  }
}


  // Upload profile image using Cloudinary
  static Future<String> uploadProfileImage(File imageFile) async {
    try {
      // Generate unique filename for the user
      final userId = authProvider.user?.userId ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final customFileName = 'profile_${userId}_$timestamp';
      
      final imageUrl = await ApiService.uploadImage(
        imageFile: imageFile,
        subfolderName: _profileImagesFolder,
        customFileName: customFileName,
      );

      return imageUrl ?? '';
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Update user preferences
  static Future<Map<String, dynamic>> updateUserPreferences({
    List<String>? tripMoods,
    List<String>? favoriteActivities,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (tripMoods != null) data['trip_moods'] = tripMoods;
      if (favoriteActivities != null) data['favorite_activities'] = favoriteActivities;

      final response = await ApiService.put(
        '/user/preferences',
        data: data,
      );

      if (response.data != null) {
        await saveProfileResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    String? displayName,
    String? bio,
    File? profileImage,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (displayName != null) data['display_name'] = displayName;
      if (bio != null) data['bio'] = bio;

      // Upload new profile image if provided using Cloudinary
      if (profileImage != null) {
        // Delete old profile image first (if exists)
        try {
          final cachedUser = await getCachedUserData();
          if (cachedUser != null && cachedUser['profile_image_url'] != null) {
            await deleteProfileImageFromCloudinary(cachedUser['profile_image_url']);
          }
        } catch (e) {
          // Continue even if deletion fails
        }

        // Upload new image
        final imageUrl = await uploadProfileImage(profileImage);
        data['profile_image_url'] = imageUrl;
      }

      final response = await ApiService.put(
        '/user/profile',
        data: data,
      );
      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiService.get('/user/profile');

      if (response.data != null) {
        await saveProfileResponse(response.data);
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Check if user profile is complete
  static Future<bool> isProfileComplete() async {
    try {
      // First check locally
      final isFirstTime = await isFirstTimeUser();
      if (!isFirstTime) return true;

      // If still marked as first time, check with server
      final response = await ApiService.get('/user/profile/completion-status');

      if (response.data != null) {
        final isComplete = response.data['is_complete'] ?? false;
        
        if (isComplete) {
          await setFirstTimeUser(false);
          await authProvider.completeSetup();
        }
        
        return isComplete;
      }
      
      return false;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Delete user profile image from Cloudinary
  static Future<void> deleteProfileImage() async {
    try {
      // Get current user data to find the image URL
      final cachedUser = await getCachedUserData();
      String? currentImageUrl;
      
      if (cachedUser != null && cachedUser['profile_image_url'] != null) {
        currentImageUrl = cachedUser['profile_image_url'];
      }

      // Delete from Cloudinary
      if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
        await deleteProfileImageFromCloudinary(currentImageUrl);
      }

      // Update profile on server to remove image URL
      final response = await ApiService.put(
        '/user/profile',
        data: {'profile_image_url': null},
      );

      if (response.data != null) {
        await saveProfileResponse(response.data);
      }
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to delete image from Cloudinary
  static Future<void> deleteProfileImageFromCloudinary(String imageUrl) async {
    try {
      await ApiService.deleteImage(imageUrl: imageUrl);
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Delete user profile image (simplified method)
  static Future<bool> deleteAllUserProfileImages() async {
    try {
      // For Cloudinary, we'll just delete the current profile image
      // since there's typically only one profile image per user
      final cachedUser = await getCachedUserData();
      
      if (cachedUser != null && cachedUser['profile_image_url'] != null) {
        await deleteProfileImageFromCloudinary(cachedUser['profile_image_url']);
        return true;
      }
      
      return true; // No image to delete
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Get user travel statistics
  static Future<Map<String, dynamic>> getUserTravelStats() async {
    try {
      final response = await ApiService.get('/user/travel-stats');
      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Update travel experience level
  static Future<void> updateTravelExperience(String experienceLevel) async {
    try {
      final response = await ApiService.put(
        '/user/travel-experience',
        data: {'experience_level': experienceLevel},
      );

      if (response.data != null) {
        await saveProfileResponse(response.data);
      }
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is first-time
  static Future<bool> isFirstTimeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      return await localStorage.isFirstTimeUser();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Mark user as not first-time
  static Future<void> setFirstTimeUser(bool isFirstTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      await localStorage.setFirstTimeUser(isFirstTime);
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Save profile response and update AuthProvider
  static Future<void> saveProfileResponse(
    Map<String, dynamic> profileResponse,
  ) async {
    try {
      // Update cached user data if user info is in response
      if (profileResponse['user'] != null) {
        await cacheUserData(profileResponse['user']);
        
        // Update AuthProvider with new user data
        try {
          final userModel = User.fromJson(profileResponse['user']);
          authProvider.setUser(userModel);
        } catch (e) {
          // Continue even if user model creation fails
        }
      }
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Cache user data locally
  static Future<void> cacheUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
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
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Clear all profile-related cached data
  static Future<void> clearProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('first_time_user');
      
      // Optionally delete all user images from Cloudinary
      try {
        await deleteAllUserProfileImages();
      } catch (e) {
        // Continue even if image deletion fails
      }
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Image service is always available with Cloudinary
  static bool get isImageServiceAvailable => true;
}

/// Model classes for API responses
class ProfileSetupResponse {
  final bool success;
  final String message;
  final UserProfile? user;

  ProfileSetupResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory ProfileSetupResponse.fromJson(Map<String, dynamic> json) {
    return ProfileSetupResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? UserProfile.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}

class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String? bio;
  final String? profileImageUrl;
  final List<String> tripMoods;
  final List<String> favoriteActivities;
  final bool isProfileComplete;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.bio,
    this.profileImageUrl,
    required this.tripMoods,
    required this.favoriteActivities,
    required this.isProfileComplete,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? json['displayName'] ?? '',
      bio: json['bio'],
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'],
      tripMoods: List<String>.from(
        json['trip_moods'] ?? json['tripMoods'] ?? 
        (json['trip_mood'] != null ? [json['trip_mood']] : []),
      ),
      favoriteActivities: List<String>.from(
        json['favorite_activities'] ?? json['favoriteActivities'] ?? [],
      ),
      isProfileComplete: json['is_profile_complete'] ?? 
                        json['isProfileComplete'] ?? false,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : (json['completedAt'] != null 
              ? DateTime.parse(json['completedAt'])
              : null),
      createdAt: DateTime.parse(
        json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'trip_moods': tripMoods,
      'favorite_activities': favoriteActivities,
      'is_profile_complete': isProfileComplete,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? bio,
    String? profileImageUrl,
    List<String>? tripMoods,
    List<String>? favoriteActivities,
    bool? isProfileComplete,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      tripMoods: tripMoods ?? this.tripMoods,
      favoriteActivities: favoriteActivities ?? this.favoriteActivities,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, email: $email)';
  }
}

