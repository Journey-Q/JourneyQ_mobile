import 'package:flutter/material.dart';

class SnackBarService {
  static void showMessage(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess
            ? Theme.of(context).primaryColor
            : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }

  /// Show critical message at top (for emergencies/errors)
  static void showTopMessage(
    BuildContext context, {
    required String message,
    bool isError = true,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.warning : Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError 
            ? Colors.red.shade700 
            : Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: topPadding + 8,
          left: 16,
          right: 16,
          bottom: mediaQuery.size.height - topPadding - 100,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }

  /// Quick success message
  static void showSuccess(BuildContext context, String message) {
    showMessage(context, message: message, isSuccess: true);
  }

  /// Quick error message  
  static void showError(BuildContext context, String message) {
    showMessage(context, message: message, isSuccess: false);
  }

  /// Critical error at top
  static void showCriticalError(BuildContext context, String message) {
    showTopMessage(context, message: message, isError: true);
  }
}