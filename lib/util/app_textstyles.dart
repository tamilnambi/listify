import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listify/util/app_colors.dart';

class AppTextStyles {
  // Calculates text size based on screen width
  static double responsiveSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / 375.0) * baseSize; // 375 is the reference width (e.g., iPhone X)
  }

  // Heading Style - Roboto
  static TextStyle heading(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: responsiveSize(context, 40),
      fontWeight: FontWeight.bold,
      color: AppColors.customBlue,
    );
  }

  // Subheading Style - Roboto
  static TextStyle subheading(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: responsiveSize(context, 18), // Base size: 18
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    );
  }

  // Body Text Style - Open Sans
  static TextStyle body(BuildContext context) {
    return GoogleFonts.openSans(
      fontSize: responsiveSize(context, 16), // Base size: 16
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    );
  }

  // Small Text Style - Open Sans
  static TextStyle smallText(BuildContext context) {
    return GoogleFonts.openSans(
      fontSize: responsiveSize(context, 12), // Base size: 12
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    );
  }
}
