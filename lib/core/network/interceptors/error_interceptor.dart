// error_interceptor.dart
import 'package:dio/dio.dart';
import 'package:journeyq/core/errors/exception.dart'; // Your AppException classes

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map DioException to AppException
    final appException = _mapToAppException(err);
    
    // Create a new DioException with our custom exception
    final customDioException = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    );
    
    handler.next(customDioException);
  }
  
  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
          code: 408,
        );
        
      case DioExceptionType.sendTimeout:
        return NetworkException(
          'Request timeout. Please try again.',
          code: 408,
        );
        
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Server response timeout. Please try again.',
          code: 408,
        );
        
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network settings.',
          code: 503,
        );
           
      case DioExceptionType.badCertificate:
        return NetworkException(
          'Security certificate error. Please try again.',
          code: 495,
        );
        
      case DioExceptionType.cancel:
        return NetworkException(
          'Request was cancelled.',
          code: 499,
        );
        
      case DioExceptionType.badResponse:
        return _mapHttpErrorToAppException(err);
        
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'An unexpected error occurred. Please try again.',
          code: 500,
        );
    }
  }
  
  AppException _mapHttpErrorToAppException(DioException err) {
    final statusCode = err.response?.statusCode ?? 500;
    final responseMessage = _extractResponseMessage(err.response?.data);
    final message = 'Status Code: $statusCode, Message: ${responseMessage ?? 'Unknown error'}';
    
    switch (statusCode) {
      case 400:
        return ServerException(
          message,
          code: 400,
        );
        
      case 401:
        return AuthException(
          message,
          code: 401,
        );
        
      case 403:
        return AuthException(
          message,
          code: 403,
        );
        
      case 404:
        return ServerException(
          message,
          code: 404,
        );
        
      case 422:
        return ValidationException(
          message,
          code: 422,
        );
        
      case 429:
        return ServerException(
          message,
          code: 429,
        );
        
      case 500:
        return ServerException(
          message,
          code: 500,
        );
        
      case 502:
        return ServerException(
          message,
          code: 502,
        );
        
      case 503:
        return ServerException(
          message,
          code: 503,
        );
        
      case 504:
        return ServerException(
          message,
          code: 504,
        );
        
      default:
        return ServerException(
          message,
          code: statusCode,
        );
    }
  }
  
  String? _extractResponseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? 
             data['error'] ?? 
             data['detail'] ?? 
             data['msg'] ??
             data['error_description'];
    }
    if (data is String) {
      return data;
    }
    return null;
  }
}