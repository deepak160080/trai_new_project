import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DeviceType { mobile, desktop, tablet }

class ResponsiveTextTheme {
  static TextTheme getResponsiveTextTheme(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    
    // Determine device type based on width
    DeviceType deviceType = size.width < 600 
        ? DeviceType.mobile
        : size.width < 900 
            ? DeviceType.tablet 
            : DeviceType.desktop;
            
    // Calculate dynamic base size that scales with screen width
    double baseFontSize = size.width * 0.02; // 2% of screen width
    baseFontSize = baseFontSize.clamp(14, 20); // Prevent extremes
    
    return TextTheme(
      // 1. Logo Text
      displaySmall: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.desktop 
            ? baseFontSize * 2.2  // ~44
            : deviceType == DeviceType.tablet 
                ? baseFontSize * 1.5  // ~30
                : baseFontSize * 1.3,  // ~26
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      
      // 2. "Not a member yet? Join"
      bodySmall: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.tablet 
            ? baseFontSize * 0.9  // ~18
            : baseFontSize * 0.8,  // ~16
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      
      // 3. "Log in" Title
      headlineSmall: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.desktop 
            ? baseFontSize * 1.4  // ~28
            : deviceType == DeviceType.tablet 
                ? baseFontSize * 1.3  // ~26
                : baseFontSize * 1.1,  // ~22
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      
      // 4 & 5. Labels and Input Text
      bodyMedium: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.tablet 
            ? baseFontSize * 1  // ~20
            : baseFontSize * 0.9,  // ~18
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      
      // 6. "Forgot Password?"
      labelSmall: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.tablet 
            ? baseFontSize * 0.9  // ~18
            : baseFontSize * 0.8,  // ~16
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      
      // 7. Primary Button
      labelLarge: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.mobile 
            ? baseFontSize * 0.8  // ~16
            : baseFontSize * 0.9,  // ~18
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      
      // 8. Secondary Buttons
      labelMedium: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.tablet 
            ? baseFontSize * 0.9  // ~18
            : baseFontSize * 0.8,  // ~16
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      
      // 9. Large Placeholder Text
      headlineMedium: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.desktop 
            ? baseFontSize * 1.8  // ~36
            : deviceType == DeviceType.tablet 
                ? baseFontSize * 1.4  // ~28
                : baseFontSize * 1.3,  // ~26
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      
      // 10. Body Text Below Icon
      bodyLarge: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.mobile 
            ? baseFontSize * 0.9  // ~18
            : baseFontSize,  // ~20
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      
      // 11. Additional Paragraph Text
      titleMedium: GoogleFonts.quicksand(
        fontSize: deviceType == DeviceType.desktop 
            ? baseFontSize  // ~20
            : deviceType == DeviceType.tablet 
                ? baseFontSize * 0.9  // ~18
                : baseFontSize * 0.8,  // ~16
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    );
  }
}