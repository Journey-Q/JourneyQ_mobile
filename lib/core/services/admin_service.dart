// File: lib/core/services/admin_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  static const String baseUrl = 'https://adminservice-production-19d3.up.railway.app';
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add request interceptor for logging
  static void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('📡 Admin API Request: ${options.method} ${options.uri}');
          debugPrint('📋 Request Headers: ${options.headers}');
          if (options.data != null) {
            debugPrint('📦 Request Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ Admin API Response: ${response.statusCode}');
          debugPrint('📦 Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ Admin API Error: ${error.message}');
          debugPrint('Status Code: ${error.response?.statusCode}');
          debugPrint('Error Data: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    _setupInterceptors();
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      debugPrint('❌ Admin GET Error on $endpoint: ${e.message}');
      rethrow;
    }
  }

  // POST request
  static Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _setupInterceptors();
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      debugPrint('❌ Admin POST Error on $endpoint: ${e.message}');
      rethrow;
    }
  }

  // PUT request
  static Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _setupInterceptors();
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      debugPrint('❌ Admin PUT Error on $endpoint: ${e.message}');
      rethrow;
    }
  }

  // DELETE request
  static Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    _setupInterceptors();
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      debugPrint('❌ Admin DELETE Error on $endpoint: ${e.message}');
      rethrow;
    }
  }
}
