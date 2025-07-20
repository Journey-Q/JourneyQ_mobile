import 'dart:io';
import 'package:dio/dio.dart';
import 'package:journeyq/core/network/interceptors/error_interceptor.dart';
import 'package:journeyq/core/network/interceptors/auth_interceptor.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:journeyq/core/services/image_upload_service.dart';

class ApiService {
  static late Dio _dio;
  static late AuthProvider _authProvider;
  static bool _isImageServiceInitialized = false;

  static Future<void> initialize(AuthProvider authProvider) async {
    _authProvider = authProvider;

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://socialmediaservice-production.up.railway.app',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Add interceptors in order
    _dio.interceptors.add(AuthInterceptor(authProvider)); // Add auth token
    _dio.interceptors.add(ErrorInterceptor()); // Handle errors

    // Initialize Supabase Image Service
    await _initializeImageService();
  }

  /// Initialize Supabase Image Service
  static Future<void> _initializeImageService() async {
    try {
      _isImageServiceInitialized = await SupabaseImageService.initialize();
      if (!_isImageServiceInitialized) {
        print('Warning: Supabase Image Service failed to initialize');
      }
    } catch (e) {
      print('Error initializing Supabase Image Service: $e');
      _isImageServiceInitialized = false;
    }
  }

  // GET request
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw ServerException('Unexpected error occurred');
    }
  }

  // POST request
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw ServerException('Unexpected error occurred');
    }
  }

  // PUT request
  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw ServerException('Unexpected error occurred');
    }
  }

  // DELETE request
  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw ServerException('Unexpected error occurred');
    }
  }



  /// Upload a single image to Supabase storage
  static Future<String?> uploadImage({
    required File imageFile,
    required String bucketName,
    String? folder,
  }) async {
    _ensureImageServiceInitialized();

    try {
      final urls = await SupabaseImageService.uploadMultipleImages(
        imageFiles: [imageFile],
        bucketName: bucketName,
        folder: folder,
      );

      return urls.isNotEmpty ? urls.first : null;
    } catch (e) {
      throw ServerException('Failed to upload image: $e');
    }
  }

  /// Upload multiple images to Supabase storage
  static Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String bucketName,
    String? folder,
    Function(int uploaded, int total)? onProgress,
  }) async {
    _ensureImageServiceInitialized();

    try {
      return await SupabaseImageService.uploadMultipleImages(
        imageFiles: imageFiles,
        bucketName: bucketName,
        folder: folder,
        onProgress: onProgress,
      );
    } catch (e) {
      throw ServerException('Failed to upload images: $e');
    }
  }

  /// Delete a single image by URL
  static Future<bool> deleteImage({
    required String bucketName,
    required String imageUrl,
  }) async {
    _ensureImageServiceInitialized();

    try {
      final results = await SupabaseImageService.deleteMultipleImagesByUrl(
        bucketName: bucketName,
        imageUrls: [imageUrl],
      );

      return results.isNotEmpty ? results.first : false;
    } catch (e) {
      throw ServerException('Failed to delete image: $e');
    }
  }

  /// Delete multiple images by URLs
  static Future<List<bool>> deleteMultipleImages({
    required String bucketName,
    required List<String> imageUrls,
  }) async {
    _ensureImageServiceInitialized();

    try {
      return await SupabaseImageService.deleteMultipleImagesByUrl(
        bucketName: bucketName,
        imageUrls: imageUrls,
      );
    } catch (e) {
      throw ServerException('Failed to delete images: $e');
    }
  }

  /// Delete all images for the current user in a specific folder
  static Future<bool> deleteAllUserImages({
    required String bucketName,
    String? folder,
  }) async {
    _ensureImageServiceInitialized();

    try {
      final userId = SupabaseService.client.auth.currentUser?.id ?? 'anonymous';
      final basePath = folder ?? 'uploads';
      final folderPath = '$basePath/$userId/';

      // List all files in the user's folder
      final files = await SupabaseService.client.storage
          .from(bucketName)
          .list(path: folderPath);

      if (files.isEmpty) return true;

      // Create full file paths
      final filePaths = files.map((file) => '$folderPath${file.name}').toList();

      // Delete all files
      await SupabaseService.client.storage.from(bucketName).remove(filePaths);

      return true;
    } catch (e) {
      throw ServerException('Failed to delete all user images: $e');
    }
  }

  /// Check if image service is available
  static bool get isImageServiceAvailable => _isImageServiceInitialized;

  /// Ensure image service is initialized before use
  static void _ensureImageServiceInitialized() {
    if (!_isImageServiceInitialized) {
      throw ServerException(
        'Image service not initialized. Call ApiService.initialize() first.',
      );
    }
  }
}

// SUPABASE SERVICE CLASSES (Include these in your project)

class SupabaseService {
  static SupabaseClient? _client;
  static bool _isInitialized = false;

  // Configuration (set these values)
  static const String _url = 'https://mfxraojgoupyqlixftlo.supabase.co';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1meHJhb2pnb3VweXFsaXhmdGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwNzUwODAsImV4cCI6MjA2MzY1MTA4MH0.0kTHydukdN4Xv6xsBnBk84sDXX1LO-qT0R44Ow0FCFc';

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
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
  }

  /// Initialize Supabase with project credentials
  static Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      await Supabase.initialize(url: _url, anonKey: _anonKey);

      _client = Supabase.instance.client;
      _isInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }
}
