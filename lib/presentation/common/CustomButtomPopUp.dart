import 'package:flutter/material.dart';
import 'dart:ui';

class CustomBottomPopup extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;
  final bool dismissible;
  final bool dismissOutside;
  final VoidCallback? onDismiss;
  final bool showCloseButton;

  CustomBottomPopup({
    this.imagePath,
    this.title,
    this.description,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    this.dismissible = true,
    this.dismissOutside = true,
    this.onDismiss,
    this.showCloseButton = false,
  });

  void _dismiss(BuildContext context) {
    if (dismissible) {
      Navigator.of(context).pop();
      if (onDismiss != null) {
        onDismiss!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissOutside ? () => _dismiss(context) : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () async => dismissible,
          child: GestureDetector(
            onTap: () {}, // This prevents taps inside the popup from dismissing it
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {}, // This prevents taps inside the popup from dismissing it
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showCloseButton)
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => _dismiss(context),
                              ),
                            ),
                          if (imagePath != null)
                            Image.asset(
                              imagePath!,
                              height: 100,
                            ),
                          if (title != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                title!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          if (description != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                description!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          if (positiveButtonText != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: onPositiveButtonPressed,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.pink,
                                    side: BorderSide(color: Colors.pink),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: Text(positiveButtonText!),
                                ),
                              ),
                            ),
                          if (negativeButtonText != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: onNegativeButtonPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: Text(negativeButtonText!),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}