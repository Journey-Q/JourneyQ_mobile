import 'dart:io';
import 'package:dio/dio.dart';
import 'package:journeyq/core/network/interceptors/error_interceptor.dart';
import 'package:journeyq/core/network/interceptors/auth_interceptor.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/core/services/image_save_service.dart';

class MarketplaceService {
  static late Dio _dio;
  static late AuthProvider _authProvider;

  static Future<void> initialize(AuthProvider authProvider) async {
    _authProvider = authProvider;

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://serviceprovidersservice-production-8f10.up.railway.app',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );


  }

  // GET request
  static Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      print('🌐 MarketplaceService GET Request:');
      print('   URL: ${_dio.options.baseUrl}$path');
      print('   Headers: ${_dio.options.headers}');
      print('   Query Params: $queryParameters');

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      print('✅ Response Status: ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      print('❌ DioException Details:');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');
      print('   Request URL: ${e.requestOptions.uri}');
      print('   Request Headers: ${e.requestOptions.headers}');
      print('   Error Type: ${e.type}');
      print('   Error Message: ${e.message}');

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
      print('🌐 MarketplaceService POST Request:');
      print('   URL: ${_dio.options.baseUrl}$path');
      print('   Headers: ${_dio.options.headers}');
      print('   Query Params: $queryParameters');
      print('   Request Body: $data');
      print('   Request Body Type: ${data.runtimeType}');

      // Ensure we're sending JSON with proper content type
      final requestOptions = options ?? Options(
        contentType: 'application/json',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
      );

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ DioException Details:');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');
      print('   Request URL: ${e.requestOptions.uri}');
      print('   Request Headers: ${e.requestOptions.headers}');
      print('   Request Body: ${e.requestOptions.data}');
      print('   Error Type: ${e.type}');
      print('   Error Message: ${e.message}');

      if (e.error is AppException) {
        throw e.error as AppException;
      }

      // Throw detailed error message from backend
      if (e.response?.data != null) {
        final errorMessage = e.response!.data.toString();
        throw ServerException('Server error (${e.response?.statusCode}): $errorMessage');
      }

      throw ServerException('Unexpected error occurred: ${e.message}');
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

  /// Upload a single image to Cloudinary
  static Future<String?> uploadImage({
    required File imageFile,
    required String subfolderName,
    String? customFileName,
  }) async {
    try {
      return await ImageSaveService.saveImage(
        imageFile: imageFile,
        subfolderName: subfolderName,
        customFileName: customFileName,
      );
    } catch (e) {
      throw ServerException('Failed to upload image: $e');
    }
  }

  /// Upload multiple images to Cloudinary
  static Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String subfolderName,
    List<String>? customFileNames,
    Function(int uploaded, int total)? onProgress,
  }) async {
    try {
      return await ImageSaveService.saveMultipleImages(
        imageFiles: imageFiles,
        subfolderName: subfolderName,
        customFileNames: customFileNames,
        onProgress: onProgress,
      );
    } catch (e) {
      throw ServerException('Failed to upload images: $e');
    }
  }

  /// Delete a single image from Cloudinary
  static Future<bool> deleteImage({
    required String imageUrl,
  }) async {
    try {
      return await ImageSaveService.deleteImage(imageUrl: imageUrl);
    } catch (e) {
      throw ServerException('Failed to delete image: $e');
    }
  }

  /// Delete multiple images from Cloudinary
  static Future<List<bool>> deleteMultipleImages({
    required List<String> imageUrls,
  }) async {
    try {
      return await ImageSaveService.deleteMultipleImages(imageUrls: imageUrls);
    } catch (e) {
      throw ServerException('Failed to delete images: $e');
    }
  }

  /// Check if image exists
  static Future<bool> doesImageExist({
    required String imageUrl,
  }) async {
    try {
      return await ImageSaveService.doesImageExist(imageUrl: imageUrl);
    } catch (e) {
      throw ServerException('Failed to check image existence: $e');
    }
  }

  /// Get image file size
  static Future<int> getImageFileSize({
    required String imageUrl,
  }) async {
    try {
      return await ImageSaveService.getImageFileSize(imageUrl: imageUrl);
    } catch (e) {
      throw ServerException('Failed to get image size: $e');
    }
  }
}

