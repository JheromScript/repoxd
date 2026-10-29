import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';
import 'espacios.dart';

abstract final class AppTheme {
  static const _formaCompleta = StadiumBorder();

  static const Size tamanoBotonL = Size.fromHeight(Espacios.botonL);

  static ButtonStyle estiloBotonL() => ButtonStyle(
    minimumSize: WidgetStatePropertyAll(tamanoBotonL),
    textStyle: WidgetStatePropertyAll(AppText.textTheme.titleMedium),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: Espacios.e24),
    ),
  );

  static ThemeData get oscuro {
    const cs = AppColors.esquema;
    final textos = AppText.textTheme.apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );

    final botonM = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(64, Espacios.botonM)),
      shape: const WidgetStatePropertyAll(_formaCompleta),
      textStyle: WidgetStatePropertyAll(textos.labelLarge),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Espacios.e24),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      canvasColor: cs.surface,
      fontFamily: 'Poppins',
      // 48 dp de área táctil también en web y escritorio (accesibilidad).
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: textos,
      extensions: const [ColoresEstado.oscuro, DegradadosImagen.oscuro],
      cardTheme: CardThemeData(
        color: cs.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Radios.brMedium),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: Radios.brSmall),
        labelStyle: textos.labelLarge,
        side: BorderSide(color: cs.outline),
        selectedColor: cs.secondaryContainer,
        checkmarkColor: cs.onSecondaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: Radios.brExtraSmall,
          borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        ),
        labelStyle: textos.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
        helperStyle: textos.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        errorStyle: textos.bodySmall?.copyWith(color: cs.error),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(borderRadius: Radios.brExtraLarge),
        titleTextStyle: textos.headlineSmall,
        contentTextStyle: textos.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: botonM),
      elevatedButtonTheme: ElevatedButtonThemeData(style: botonM),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: botonM.copyWith(
          side: WidgetStatePropertyAll(BorderSide(color: cs.outline)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: botonM.copyWith(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Espacios.e12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surfaceContainer,
        indicatorColor: cs.secondaryContainer,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((estados) {
          return estados.contains(WidgetState.selected)
              ? textos.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                )
              : textos.labelMedium?.copyWith(color: cs.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          final activo = estados.contains(WidgetState.selected);
          return IconThemeData(
            color: activo ? cs.onSecondaryContainer : cs.onSurfaceVariant,
          );
        }),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textos.titleLarge,
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: WidgetStateProperty.resolveWith((estados) {
          return estados.contains(WidgetState.selected)
              ? Icon(Icons.check, size: 16, color: cs.primary)
              : null;
        }),
        thumbColor: WidgetStateProperty.resolveWith((estados) {
          if (estados.contains(WidgetState.disabled)) {
            return cs.onSurface.withValues(alpha: 0.38);
          }
          return estados.contains(WidgetState.selected)
              ? cs.onPrimary
              : cs.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((estados) {
          if (estados.contains(WidgetState.disabled)) {
            return cs.onSurface.withValues(alpha: 0.12);
          }
          return estados.contains(WidgetState.selected)
              ? cs.primary
              : cs.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((estados) {
          return estados.contains(WidgetState.selected)
              ? Colors.transparent
              : cs.outline;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(borderRadius: Radios.brExtraSmall),
        side: WidgetStateBorderSide.resolveWith((estados) {
          if (estados.contains(WidgetState.error)) {
            return BorderSide(color: cs.error, width: 2);
          }
          if (estados.contains(WidgetState.selected)) {
            return const BorderSide(color: Colors.transparent);
          }
          return BorderSide(color: cs.onSurfaceVariant, width: 2);
        }),
        fillColor: WidgetStateProperty.resolveWith((estados) {
          if (estados.contains(WidgetState.disabled)) {
            return cs.onSurface.withValues(alpha: 0.38);
          }
          return estados.contains(WidgetState.selected)
              ? cs.primary
              : Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(cs.onPrimary),
      ),
    );
  }
}
