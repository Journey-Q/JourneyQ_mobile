import 'package:flutter/material.dart';

class TopSnackBarService {
  static void show_message(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double topSafeArea = mediaQuery.padding.top;
    final double screenHeight = mediaQuery.size.height;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: isSuccess
            ? Theme.of(context).primaryColor
            : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: topSafeArea + 16, // Safe area top + additional margin
          left: 16,
          right: 16,
          bottom: screenHeight - topSafeArea - 100, // Properly calculated bottom margin
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: isSuccess 
                    ? Theme.of(context).primaryColor 
                    : Colors.red,
                backgroundColor: Colors.white,
                onPressed: () {
                  onActionPressed?.call();
                },
              )
            : null,
      ),
    );
  }
}