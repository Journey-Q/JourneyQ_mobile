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
      error: appException, // Attach our custom exception
      message: appException.message,
    );
    
    handler.next(customDioException);
  }
  
  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
          code: 'CONNECTION_TIMEOUT',
        );
        
      case DioExceptionType.sendTimeout:
        return NetworkException(
          'Request timeout. Please try again.',
          code: 'SEND_TIMEOUT',
        );
        
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Server response timeout. Please try again.',
          code: 'RECEIVE_TIMEOUT',
        );
        
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network settings.',
          code: 'CONNECTION_ERROR',
        );
        
      case DioExceptionType.badCertificate:
        return NetworkException(
          'Certificate error. Please contact support.',
          code: 'BAD_CERTIFICATE',
        );
        
      case DioExceptionType.cancel:
        return NetworkException(
          'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
        );
        
      case DioExceptionType.badResponse:
        return _mapHttpErrorToAppException(err);
        
      case DioExceptionType.unknown:
      default:
        return ServerException(
          'An unexpected error occurred. Please try again.',
          code: 'UNKNOWN_ERROR',
        );
    }
  }
  
  AppException _mapHttpErrorToAppException(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    
    switch (statusCode) {
      case 400:
        final message = _extractErrorMessage(data) ?? 
            'Invalid request. Please check your input.';
        return ValidationException(
          message,
          code: 'BAD_REQUEST',
          errors: _extractValidationErrorsMap(data),
        );
        
      case 401:
        return AuthException(
          'Session expired. Please login again.',
          code: 'UNAUTHORIZED',
        );
        
      case 403:
        return AuthException(
          'Access denied. You don\'t have permission to perform this action.',
          code: 'FORBIDDEN',
        );
        
      case 404:
        return ServerException(
          'Requested resource not found.',
          code: 'NOT_FOUND',
        );
        
      case 422:
        final message = _extractValidationErrors(data) ?? 
            'Validation failed. Please check your input.';
        return ValidationException(
          message,
          code: 'VALIDATION_ERROR',
          errors: _extractValidationErrorsMap(data),
        );
        
      case 429:
        return ServerException(
          'Too many requests. Please wait a moment and try again.',
          code: 'RATE_LIMIT_EXCEEDED',
        );
        
      case 500:
        return ServerException(
          'Internal server error. Our team has been notified.',
          code: 'INTERNAL_SERVER_ERROR',
        );
        
      case 502:
        return ServerException(
          'Bad gateway. Server is temporarily unavailable.',
          code: 'BAD_GATEWAY',
        );
        
      case 503:
        return ServerException(
          'Service temporarily unavailable. Please try again later.',
          code: 'SERVICE_UNAVAILABLE',
        );
        
      case 504:
        return ServerException(
          'Gateway timeout. Please try again later.',
          code: 'GATEWAY_TIMEOUT',
        );
        
      default:
        return ServerException(
          'Server error (${statusCode ?? 'unknown'}). Please try again.',
          code: 'HTTP_ERROR_$statusCode',
        );
    }
  }
  
  String? _extractErrorMessage(dynamic data) {
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
  
  String? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'] ?? data['validation_errors'];
      
      if (errors is Map<String, dynamic>) {
        final errorMessages = <String>[];
        errors.forEach((field, messages) {
          if (messages is List) {
            errorMessages.addAll(messages.map((msg) => '$field: $msg'));
          } else if (messages is String) {
            errorMessages.add('$field: $messages');
          }
        });
        return errorMessages.join('\n');
      } else if (errors is List) {
        return errors.join('\n');
      }
      
      return _extractErrorMessage(data);
    }
    return null;
  }
  
  Map<String, List<String>>? _extractValidationErrorsMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'] ?? data['validation_errors'];
      
      if (errors is Map<String, dynamic>) {
        final validationErrors = <String, List<String>>{};
        errors.forEach((field, messages) {
          if (messages is List) {
            validationErrors[field] = messages.map((msg) => msg.toString()).toList();
          } else if (messages is String) {
            validationErrors[field] = [messages];
          }
        });
        return validationErrors.isNotEmpty ? validationErrors : null;
      }
    }
    return null;
  }
}