import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DominoTheme {
  static const Color backgroundColor = Color(0xFF0B0E14);
  static const Color cardColor = Color(0xFF141923);
  static const Color primaryBlue = Color(0xFF0D6EFD);
  static const Color neonBlue = Color(0xFF00D2FF);
  static const Color primaryRed = Color(0xFFDC3545);
  static const Color neonRed = Color(0xFFFF2A5F);
  static const Color gold = Color(0xFFFFC107);
  static const Color green = Color(0xFF198754);
  static const Color neonGreen = Color(0xFF2ECC71);
  static const Color textColor = Colors.white;
  static const Color textMuted = Color(0xFF8E9AA8);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryBlue,
      cardColor: cardColor,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: neonBlue,
        error: primaryRed,
        surface: cardColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0B0E14),
        selectedItemColor: neonBlue,
        unselectedItemColor: textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static BoxDecoration glassDecoration({
    Color? borderColor,
    double radius = 16,
    bool hasGradient = false,
  }) {
    return BoxDecoration(
      color: cardColor.withOpacity(0.85),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? Colors.white.withOpacity(0.08),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      gradient: hasGradient
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor,
                cardColor.withOpacity(0.6),
              ],
            )
          : null,
    );
  }

  static BoxDecoration gradientButtonDecoration({
    required List<Color> colors,
    double radius = 12,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
