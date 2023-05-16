import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color.fromARGB(255, 5, 90, 160);

// Text colors
const darkTextColor = Colors.black;
const lightTextColor = Colors.white;

// Background colors
const darkBackgroundColor = Color.fromARGB(255, 49, 49, 49);
const lightBackgroundColor = Colors.white;

TextTheme getPrimaryTextTheme(Color color) {
  return TextTheme(
    displayLarge: GoogleFonts.robotoFlex(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    displayMedium: GoogleFonts.robotoFlex(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    displaySmall: GoogleFonts.robotoFlex(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineLarge: GoogleFonts.robotoFlex(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    headlineMedium: GoogleFonts.robotoFlex(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    headlineSmall: GoogleFonts.robotoFlex(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleLarge: GoogleFonts.robotoFlex(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleMedium: GoogleFonts.robotoFlex(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleSmall: GoogleFonts.robotoFlex(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyLarge: GoogleFonts.robotoFlex(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodyMedium: GoogleFonts.robotoFlex(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodySmall: GoogleFonts.robotoFlex(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    labelLarge: GoogleFonts.robotoFlex(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    labelMedium: GoogleFonts.robotoFlex(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    labelSmall: GoogleFonts.robotoFlex(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );
}

TextTheme getSecondaryTextTheme(Color color) {
  return TextTheme(
    displayLarge: GoogleFonts.robotoMono(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    displayMedium: GoogleFonts.robotoMono(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    displaySmall: GoogleFonts.robotoMono(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineLarge: GoogleFonts.robotoMono(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    headlineMedium: GoogleFonts.robotoMono(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    headlineSmall: GoogleFonts.robotoMono(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleLarge: GoogleFonts.robotoMono(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleMedium: GoogleFonts.robotoMono(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleSmall: GoogleFonts.robotoMono(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyLarge: GoogleFonts.robotoMono(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodyMedium: GoogleFonts.robotoMono(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodySmall: GoogleFonts.robotoMono(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    labelLarge: GoogleFonts.robotoMono(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    labelMedium: GoogleFonts.robotoMono(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    labelSmall: GoogleFonts.robotoMono(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF005BC1),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD8E2FF),
  onPrimaryContainer: Color(0xFF001A41),
  secondary: Color(0xFF00696D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF6FF6FC),
  onSecondaryContainer: Color(0xFF002021),
  tertiary: Color(0xFFA7391E),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDAD2),
  onTertiaryContainer: Color(0xFF3D0700),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFDFBFF),
  onBackground: Color(0xFF001B3D),
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF001B3D),
  surfaceVariant: Color(0xFFE1E2EC),
  onSurfaceVariant: Color(0xFF44474F),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFECF0FF),
  inverseSurface: Color(0xFF003062),
  inversePrimary: Color(0xFFADC6FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF005BC1),
  outlineVariant: Color(0xFFC4C6D0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFADC6FF),
  onPrimary: Color(0xFF002E69),
  primaryContainer: Color(0xFF004494),
  onPrimaryContainer: Color(0xFFD8E2FF),
  secondary: Color(0xFF4CD9E0),
  onSecondary: Color(0xFF003739),
  secondaryContainer: Color(0xFF004F52),
  onSecondaryContainer: Color(0xFF6FF6FC),
  tertiary: Color(0xFFFFB4A3),
  onTertiary: Color(0xFF621000),
  tertiaryContainer: Color(0xFF872108),
  onTertiaryContainer: Color(0xFFFFDAD2),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF001B3D),
  onBackground: Color(0xFFD6E3FF),
  surface: Color(0xFF001B3D),
  onSurface: Color(0xFFD6E3FF),
  surfaceVariant: Color(0xFF44474F),
  onSurfaceVariant: Color(0xFFC4C6D0),
  outline: Color(0xFF8E9099),
  onInverseSurface: Color(0xFF001B3D),
  inverseSurface: Color(0xFFD6E3FF),
  inversePrimary: Color(0xFF005BC1),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFADC6FF),
  outlineVariant: Color(0xFF44474F),
  scrim: Color(0xFF000000),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  brightness: Brightness.light,
  primaryTextTheme: getPrimaryTextTheme(lightColorScheme.onSurface),
  textTheme: getSecondaryTextTheme(lightColorScheme.onSurface),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryTextTheme: getPrimaryTextTheme(darkColorScheme.onSurface),
  textTheme: getSecondaryTextTheme(darkColorScheme.onSurface),
);
