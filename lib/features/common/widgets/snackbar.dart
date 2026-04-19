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
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 1),

      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 4,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // slightly tighter
      ),

      content: Row(
        mainAxisSize: MainAxisSize.min, // 👈 important
        children: [
          Icon(iconData, color: Colors.white, size: 18), // 👈 smaller icon
          const SizedBox(width: 8), // 👈 tighter spacing
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500, // less bulky
                fontSize: 13, // 👈 smaller text
                height: 1.2, // 👈 tighter line height
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12, // 👈 THIS reduces height the most
      ),
    ),
  );
}
