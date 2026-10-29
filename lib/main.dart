import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/reloj.dart';
import 'data/catalogo_repository.dart';
import 'data/catalogo_repository_mock.dart';
import 'data/datos_mock.dart';
import 'data/reserva_repository.dart';
import 'data/reserva_repository_memoria.dart';
import 'models/temporada.dart';
import 'state/flujo_reserva_controller.dart';
import 'state/preferencias_controller.dart';
import 'state/reservas_controller.dart';

Future<void> main() async {
  await initializeDateFormatting();

  // Para la demo se puede fijar la fecha: RelojFijo(DateTime(2026, 10, 27, 10)).
  const Reloj reloj = RelojSistema();

  // Aquí se elige la implementación de los repositorios.
  final CatalogoRepository catalogo = CatalogoRepositoryMock(reloj: reloj);
  final ReservaRepository reservas = ReservaRepositoryMemoria(
    iniciales: DatosMock.reservasSemilla(Temporada.vigente(reloj.ahora())),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<Reloj>.value(value: reloj),
        Provider<CatalogoRepository>.value(value: catalogo),
        Provider<ReservaRepository>.value(value: reservas),
        ChangeNotifierProvider(
          create: (_) => PreferenciasController(
            reloj: reloj,
            perfil: DatosMock.perfilDemo,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReservasController(
            reloj: reloj,
            reservas: reservas,
            catalogo: catalogo,
            usuarioId: DatosMock.usuarioDemoId,
            preferencias: context.read<PreferenciasController>(),
          )..cargar(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              FlujoReservaController(reloj: reloj, catalogo: catalogo)
                ..cargar(),
        ),
      ],
      child: const TrajinerasApp(),
    ),
  );
}
