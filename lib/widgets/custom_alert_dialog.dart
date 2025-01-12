import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomConfirmationDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Builder(
            builder: (context) {
              // Get the size of the screen
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: width * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Message
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: width * 0.04, // Responsive font size
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Action Buttons (Confirm & Cancel)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: 'Confirm',
                        width: width * 0.25,
                        onPressed: () {
                          onConfirm();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        color: Colors.red, // Confirm action color
                      ),
                      CustomButton(
                        text: 'Cancel',
                        width: width * 0.3,
                        onPressed: () {
                          if (onCancel != null) {
                            onCancel();
                          }
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
