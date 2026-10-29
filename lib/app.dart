import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'l10n/l10n.dart';
import 'models/ruta.dart';
import 'screens/bienvenida/bienvenida_screen.dart';
import 'screens/como_llegar/como_llegar_screen.dart';
import 'screens/galeria/galeria_screen.dart';
import 'screens/reserva/confirmacion_screen.dart';
import 'screens/reserva/datos_screen.dart';
import 'screens/reserva/fecha_horario_screen.dart';
import 'screens/reserva/resumen_screen.dart';
import 'screens/reserva/trajinera_screen.dart';
import 'screens/reservacion/cambiar_reservacion_screen.dart';
import 'screens/reservacion/detalle_reservacion_screen.dart';
import 'screens/rutas/detalle_ruta_screen.dart';
import 'screens/seguridad/seguridad_screen.dart';
import 'screens/shell/shell_screen.dart';
import 'screens/tradiciones/tradiciones_screen.dart';
import 'state/preferencias_controller.dart';

abstract final class RutasApp {
  static const String bienvenida = '/';
  static const String shell = '/inicio';

  static const String detalleRuta = '/ruta';
  static const String tradiciones = '/tradiciones';

  static const String comoLlegar = '/como-llegar';
  static const String seguridad = '/seguridad';

  static const String reservar = '/reservar';
  static const String fechaHorario = '/reservar/fecha';
  static const String datos = '/reservar/datos';
  static const String resumen = '/reservar/resumen';

  static const String confirmacion = '/reservar/confirmacion';

  static const String detalleReservacion = '/reservacion';

  static const String cambiarReservacion = '/reservacion/cambiar';

  static const String galeria = '/galeria';
}

class TrajinerasApp extends StatelessWidget {
  const TrajinerasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appNombre,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.oscuro,
      themeMode: ThemeMode.dark,
      locale: Locale(idioma),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: RutasApp.bienvenida,
      onGenerateRoute: _generarRuta,
    );
  }

  static Route<dynamic> _generarRuta(RouteSettings ajustes) {
    final Widget pantalla = switch (ajustes.name) {
      RutasApp.shell => ShellScreen(key: ShellScreen.llave),
      RutasApp.detalleRuta => switch (ajustes.arguments) {
        final Ruta ruta => DetalleRutaScreen(ruta: ruta),
        _ => const BienvenidaScreen(),
      },
      RutasApp.tradiciones => const TradicionesScreen(),
      RutasApp.comoLlegar => ComoLlegarScreen(
        embarcaderoId: ajustes.arguments as String?,
      ),
      RutasApp.seguridad => const SeguridadScreen(),
      RutasApp.reservar => const TrajineraScreen(),
      RutasApp.fechaHorario => const FechaHorarioScreen(),
      RutasApp.datos => const DatosScreen(),
      RutasApp.resumen => const ResumenScreen(),
      RutasApp.confirmacion => switch (ajustes.arguments) {
        final String folio => ConfirmacionScreen(folio: folio),
        _ => const BienvenidaScreen(),
      },
      RutasApp.detalleReservacion => switch (ajustes.arguments) {
        final String folio => DetalleReservacionScreen(folio: folio),
        _ => const BienvenidaScreen(),
      },
      RutasApp.cambiarReservacion => switch (ajustes.arguments) {
        final String folio => CambiarReservacionScreen(folio: folio),
        _ => const BienvenidaScreen(),
      },
      RutasApp.galeria when kDebugMode => const GaleriaScreen(),
      _ => const BienvenidaScreen(),
    };
    return MaterialPageRoute(settings: ajustes, builder: (_) => pantalla);
  }
}
