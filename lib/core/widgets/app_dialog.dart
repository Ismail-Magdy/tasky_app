import 'package:flutter/material.dart';

class AppDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6332E9)),
      ),
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("خطأ"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "حسناً",
              style: TextStyle(color: Color(0xFF6332E9)),
            ),
          ),
        ],
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    VoidCallback? onSuccess,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 10),
            Text("نجاح"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onSuccess != null) onSuccess();
            },
            child: const Text(
              "استمرار",
              style: TextStyle(color: Color(0xFF6332E9)),
            ),
          ),
        ],
      ),
    );
  }
}
