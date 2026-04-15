import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info, // Default to info
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Determine color and icon based on the type
  final Color backgroundColor;
  final IconData iconData;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green.shade600;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red.shade600;
      iconData = Icons.error_outline;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange.shade600;
      iconData = Icons.warning_amber_rounded;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue.shade600;
      iconData = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor, // Use the dynamic color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 4,
      ),
      duration: const Duration(seconds: 1),
    ),
  );
}
