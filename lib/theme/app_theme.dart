import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Palette ──────────────────────────────────────────
  static const Color primary = Color(0xFF0097A7);
  static const Color primaryDark = Color(0xFF006978);
  static const Color primaryContainer = Color(0xFFB2EBF2);
  static const Color onPrimaryContainer = Color(0xFF00363D);
  static const Color secondary = Color(0xFF1565C0);
  static const Color secondaryContainer = Color(0xFFD6E4FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5FAFB);
  static const Color background = Color(0xFFF0F4F8);
  static const Color outline = Color(0xFFB0BEC5);
  static const Color outlineVariant = Color(0xFFE0EAED);
  static const Color onSurface = Color(0xFF1A2730);
  static const Color onSurfaceVariant = Color(0xFF546E7A);
  static const Color muted = Color(0xFF78909C);

  // ── Semantic Colors ────────────────────────────────────────
  static const Color success = Color(0xFF2D7A4F);
  static const Color successContainer = Color(0xFFDCF5E7);
  static const Color warning = Color(0xFFB45309);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFB91C1C);
  static const Color errorContainer = Color(0xFFFFE4E4);
  static const Color info = Color(0xFF1565C0);
  static const Color infoContainer = Color(0xFFD6E4FF);

  // ── Chart Colors ───────────────────────────────────────────
  static const Color chartPrimary = Color(0xFF0097A7);
  static const Color chartSecondary = Color(0xFF1565C0);
  static const Color chartTertiary = Color(0xFF00BCD4);
  static const Color chartAccent = Color(0xFF26C6DA);

  static ThemeData get lightTheme {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: Color(0xFF001849),
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        error: error,
        onError: Colors.white,
        errorContainer: errorContainer,
        onErrorContainer: Color(0xFF7F1010),
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: primary,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: outline,
        ),
        errorStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: error,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 22);
          }
          return const IconThemeData(color: muted, size: 22);
        }),
        elevation: 4,
        shadowColor: Colors.black12,
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryContainer,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4DD0E1),
        onPrimary: Color(0xFF00363D),
        primaryContainer: Color(0xFF004F58),
        onPrimaryContainer: Color(0xFFB2EBF2),
        secondary: Color(0xFF90CAF9),
        onSecondary: Color(0xFF001849),
        secondaryContainer: Color(0xFF1A3A6B),
        onSecondaryContainer: Color(0xFFD6E4FF),
        surface: Color(0xFF121C21),
        onSurface: Color(0xFFE1EEF2),
        surfaceContainerHighest: Color(0xFF1E2D34),
        outline: Color(0xFF4A6572),
        outlineVariant: Color(0xFF2A3E47),
        error: Color(0xFFEF9A9A),
        onError: Color(0xFF7F1010),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1519),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
    );
  }
}
