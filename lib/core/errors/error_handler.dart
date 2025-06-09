// core/errors/error_handler.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'exception.dart';
import 'failure.dart';

class ErrorHandler {
  // Convert exceptions to failures
  static Failure handleException(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message, code: exception.code);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message, code: exception.code);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message, code: exception.code);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        exception.message, 
        code: exception.code,
        errors: exception.errors,
      );
    } else if (exception is SocketException) {
      return const NetworkFailure('No internet connection');
    } else if (exception is FormatException) {
      return const ServerFailure('Invalid data format received from server');
    } else {
      return ServerFailure('An unexpected error occurred: ${exception.toString()}');
    }
  }

  // Simple error snackbar
  static void showError(BuildContext context, Failure failure) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _getIcon(failure),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getMessage(failure),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            icon: const Icon(Icons.close, color: Colors.white, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
      backgroundColor: _getColor(failure),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Get error color
  static Color _getColor(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Colors.orange.shade600;
      case AuthFailure _:
        return Colors.red.shade600;
      case ValidationFailure _:
        return Colors.amber.shade600;
      case ServerFailure _:
        return Colors.red.shade700;
      default:
        return Colors.red.shade600;
    }
  }

  // Get error icon
  static IconData _getIcon(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Icons.wifi_off;
      case AuthFailure _:
        return Icons.lock_outline;
      case ValidationFailure _:
        return Icons.warning_amber;
      case ServerFailure _:
        return Icons.error_outline;
      default:
        return Icons.error_outline;
    }
  }

  // Get error message
  static String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Check your internet connection';
      case AuthFailure _:
        return 'Authentication failed';
      case ValidationFailure _:
        return 'Please check your input';
      case ServerFailure _:
        return 'Server error occurred';
      default:
        return failure.message;
    }
  }

  // Check if error can be retried
  static bool canRetry(Failure failure) {
    return failure is NetworkFailure || failure is ServerFailure;
  }

}