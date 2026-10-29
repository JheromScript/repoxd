import 'package:flutter/material.dart';

abstract final class AppText {
  static const String _pacifico = 'Pacifico';
  static const String _poppins = 'Poppins';

  static TextStyle _estilo(
    String familia,
    FontWeight peso,
    double tamano,
    double interlineado,
    double espaciado,
  ) {
    return TextStyle(
      fontFamily: familia,
      fontWeight: peso,
      fontSize: tamano,
      height: interlineado / tamano,
      letterSpacing: espaciado,
    );
  }

  static final TextTheme textTheme = TextTheme(
    displayLarge: _estilo(_pacifico, FontWeight.w400, 57, 64, -0.25),
    displayMedium: _estilo(_pacifico, FontWeight.w400, 45, 52, 0),
    displaySmall: _estilo(_pacifico, FontWeight.w400, 36, 44, 0),
    headlineLarge: _estilo(_pacifico, FontWeight.w400, 32, 40, 0),
    headlineMedium: _estilo(_pacifico, FontWeight.w400, 28, 36, 0),
    headlineSmall: _estilo(_poppins, FontWeight.w600, 24, 32, 0),
    titleLarge: _estilo(_poppins, FontWeight.w600, 22, 28, 0),
    titleMedium: _estilo(_poppins, FontWeight.w500, 16, 24, 0.15),
    titleSmall: _estilo(_poppins, FontWeight.w500, 14, 20, 0.1),
    bodyLarge: _estilo(_poppins, FontWeight.w400, 16, 24, 0.5),
    bodyMedium: _estilo(_poppins, FontWeight.w400, 14, 20, 0.25),
    bodySmall: _estilo(_poppins, FontWeight.w400, 12, 16, 0.4),
    labelLarge: _estilo(_poppins, FontWeight.w500, 14, 20, 0.1),
    labelMedium: _estilo(_poppins, FontWeight.w500, 12, 16, 0.5),
    labelSmall: _estilo(_poppins, FontWeight.w500, 11, 16, 0.5),
  );
}
