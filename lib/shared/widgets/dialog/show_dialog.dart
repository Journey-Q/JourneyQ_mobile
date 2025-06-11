import 'package:flutter/material.dart';

class TopSnackBarService {
  static void show(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
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
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              120,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        duration: Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
      

        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: isSuccess?Theme.of(context).primaryColor:Colors.red,
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
