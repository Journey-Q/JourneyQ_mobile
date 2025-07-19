import 'package:dio/dio.dart';
import 'package:journeyq/core/network/interceptors/error_interceptor.dart';
import 'package:journeyq/core/network/interceptors/auth_interceptor.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';

class ApiService {
  static late Dio _dio;
  static late AuthProvider _authProvider;

  static void initialize(AuthProvider authProvider) {
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

  // Upload file
  static Future<Response> uploadFile(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw ServerException('Unexpected error occurred');
    }
  }
}
