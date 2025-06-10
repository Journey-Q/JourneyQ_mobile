import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;
  static bool _isInitialized = false;

  // Configuration (set these values)
  static const String _url = 'https://mfxraojgoupyqlixftlo.supabase.co';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1meHJhb2pnb3VweXFsaXhmdGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwNzUwODAsImV4cCI6MjA2MzY1MTA4MH0.0kTHydukdN4Xv6xsBnBk84sDXX1LO-qT0R44Ow0FCFc'; // Replace with your actual key

  // Getter with auto-initialization
  static SupabaseClient get client {
    if (_client == null || !_isInitialized) {
      _initializeSync();
    }
    return _client!;
  }

  // Internal sync initialization
  static void _initializeSync() {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call SupabaseService.initialize() first.');
    }
  }

  /// Initialize Supabase with project credentials
  static Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      await Supabase.initialize(
        url: _url,
        anonKey: _anonKey,
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }
}

class SupabaseImageService {
  static SupabaseClient get _supabase {
    if (!SupabaseService._isInitialized) {
      throw Exception('Supabase not initialized. Call SupabaseImageService.initialize() first.');
    }
    return SupabaseService.client;
  }

  /// Auto-initialize and setup the service
  static Future<bool> initialize() async {
    return await SupabaseService.initialize();
  }

  /// Upload multiple images and return URLs in order
  static Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String bucketName,
    String? folder,
    Function(int uploaded, int total)? onProgress,
  }) async {
    List<String> uploadedUrls = [];
    
    if (imageFiles.isEmpty) return uploadedUrls;

    try {
      for (int i = 0; i < imageFiles.length; i++) {
        try {
          // Generate unique filename
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final extension = imageFiles[i].path.split('.').last.toLowerCase();
          final fileName = 'img_${i}_$timestamp.$extension';
          
          // Create file path
          final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
          final basePath = folder ?? 'uploads';
          final filePath = '$basePath/$userId/$fileName';
          
          // Upload file to Supabase storage
          final response = await _supabase.storage
              .from(bucketName)
              .upload(filePath, imageFiles[i]);
          
          if (response.isNotEmpty) {
            // Get public URL
            final publicUrl = _supabase.storage
                .from(bucketName)
                .getPublicUrl(filePath);
            
            uploadedUrls.add(publicUrl);
          }

          // Call progress callback
          onProgress?.call(i + 1, imageFiles.length);

        } catch (e) {
          // Skip failed uploads, continue with others
        }
      }
    } catch (e) {
      // Handle batch error silently
    }

    return uploadedUrls;
  }

  /// Delete multiple images by URLs
  static Future<List<bool>> deleteMultipleImagesByUrl({
    required String bucketName,
    required List<String> imageUrls,
  }) async {
    List<bool> results = [];
    
    if (imageUrls.isEmpty) return results;

    try {
      for (int i = 0; i < imageUrls.length; i++) {
        try {
          final success = await _deleteImageByUrl(
            bucketName: bucketName,
            imageUrl: imageUrls[i],
          );
          
          results.add(success);
        } catch (e) {
          results.add(false);
        }
      }
    } catch (e) {
      // Handle batch error silently
    }

    return results;
  }

  /// Delete single image by URL (private helper method)
  static Future<bool> _deleteImageByUrl({
    required String bucketName,
    required String imageUrl,
  }) async {
    try {
      // Extract file path from URL
      final filePath = _extractFilePathFromUrl(imageUrl, bucketName);
      
      if (filePath.isEmpty) return false;

      await _supabase.storage
          .from(bucketName)
          .remove([filePath]);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extract file path from Supabase storage URL (private helper method)
  static String _extractFilePathFromUrl(String url, String bucketName) {
    try {
      // URL format: https://project.supabase.co/storage/v1/object/public/bucket/path/file.jpg
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      // Find bucket name in path segments
      int bucketIndex = -1;
      for (int i = 0; i < pathSegments.length; i++) {
        if (pathSegments[i] == bucketName) {
          bucketIndex = i;
          break;
        }
      }
      
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        // Return everything after bucket name
        return pathSegments.sublist(bucketIndex + 1).join('/');
      }
      
      return '';
    } catch (e) {
      return '';
    }
  }
}