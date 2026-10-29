import 'package:flutter/material.dart';

/// Colección "M3 · Color" de Figma, copiada 1:1 (sin `ColorScheme.fromSeed`).
abstract final class AppColors {
  static const ColorScheme esquema = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF28C1B),
    onPrimary: Color(0xFF2E1500),
    primaryContainer: Color(0xFF6E3A00),
    onPrimaryContainer: Color(0xFFFFDCC0),
    inversePrimary: Color(0xFF8F4E00),
    secondary: Color(0xFF1FB5A8),
    onSecondary: Color(0xFF00201D),
    secondaryContainer: Color(0xFF00504A),
    onSecondaryContainer: Color(0xFF8DF5E8),
    tertiary: Color(0xFFFFB0CD),
    onTertiary: Color(0xFF5D1137),
    tertiaryContainer: Color(0xFF7A294E),
    onTertiaryContainer: Color(0xFFFFD9E4),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFF4E0),
    onSurfaceVariant: Color(0xFFD8C7B5),
    surfaceDim: Color(0xFF0D0B10),
    surfaceBright: Color(0xFF3A2D4A),
    surfaceContainerLowest: Color(0xFF0B090E),
    surfaceContainerLow: Color(0xFF18131D),
    surfaceContainer: Color(0xFF1F1828),
    surfaceContainerHigh: Color(0xFF2B1A3D),
    surfaceContainerHighest: Color(0xFF37264B),
    outline: Color(0xFFA08E7C),
    outlineVariant: Color(0xFF4E4357),
    inverseSurface: Color(0xFFFFF4E0),
    onInverseSurface: Color(0xFF2B1A3D),
    scrim: Color(0xFF000000),
  );
}

@immutable
class ColoresEstado extends ThemeExtension<ColoresEstado> {
  const ColoresEstado({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.neutralContainer,
    required this.onNeutralContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color neutralContainer;
  final Color onNeutralContainer;

  static const ColoresEstado oscuro = ColoresEstado(
    success: Color(0xFF7DDA94),
    onSuccess: Color(0xFF00391A),
    successContainer: Color(0xFF1C4D2C),
    onSuccessContainer: Color(0xFFA6F5B6),
    warning: Color(0xFFFFC453),
    warningContainer: Color(0xFF5A4100),
    onWarningContainer: Color(0xFFFFDFA0),
    neutralContainer: Color(0xFF3A3540),
    onNeutralContainer: Color(0xFFC9C2CF),
  );

  @override
  ColoresEstado copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? neutralContainer,
    Color? onNeutralContainer,
  }) {
    return ColoresEstado(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
    );
  }

  @override
  ColoresEstado lerp(ThemeExtension<ColoresEstado>? other, double t) {
    if (other is! ColoresEstado) return this;
    return ColoresEstado(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      neutralContainer: Color.lerp(
        neutralContainer,
        other.neutralContainer,
        t,
      )!,
      onNeutralContainer: Color.lerp(
        onNeutralContainer,
        other.onNeutralContainer,
        t,
      )!,
    );
  }
}

@immutable
class DegradadosImagen extends ThemeExtension<DegradadosImagen> {
  const DegradadosImagen({
    required this.animas,
    required this.cempasuchil,
    required this.trajinera,
    required this.leyenda,
    required this.mapa,
    required this.embarcadero,
  });

  final List<Color> animas;
  final List<Color> cempasuchil;
  final List<Color> trajinera;
  final List<Color> leyenda;
  final List<Color> mapa;
  final List<Color> embarcadero;

  static const DegradadosImagen oscuro = DegradadosImagen(
    animas: [Color(0xFF1A1027), Color(0xFF4A1F4F), Color(0xFFC25A1A)],
    cempasuchil: [Color(0xFF7A3200), Color(0xFFF28C1B), Color(0xFFFFC453)],
    trajinera: [Color(0xFF0B3B38), Color(0xFF1FB5A8), Color(0xFF2B1A3D)],
    leyenda: [Color(0xFF0D0B10), Color(0xFF2B1A3D), Color(0xFF5B3A7A)],
    mapa: [Color(0xFF1C2A2A), Color(0xFF2E4A46), Color(0xFF1C2A2A)],
    embarcadero: [Color(0xFF2B1A3D), Color(0xFF00504A), Color(0xFF1FB5A8)],
  );

  @override
  DegradadosImagen copyWith({
    List<Color>? animas,
    List<Color>? cempasuchil,
    List<Color>? trajinera,
    List<Color>? leyenda,
    List<Color>? mapa,
    List<Color>? embarcadero,
  }) {
    return DegradadosImagen(
      animas: animas ?? this.animas,
      cempasuchil: cempasuchil ?? this.cempasuchil,
      trajinera: trajinera ?? this.trajinera,
      leyenda: leyenda ?? this.leyenda,
      mapa: mapa ?? this.mapa,
      embarcadero: embarcadero ?? this.embarcadero,
    );
  }

  @override
  DegradadosImagen lerp(ThemeExtension<DegradadosImagen>? other, double t) {
    if (other is! DegradadosImagen) return this;
    return t < 0.5 ? this : other;
  }
}
