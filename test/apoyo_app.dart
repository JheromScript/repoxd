import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trajineras/app.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/data/catalogo_repository.dart';
import 'package:trajineras/data/catalogo_repository_mock.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/data/reserva_repository.dart';
import 'package:trajineras/data/reserva_repository_memoria.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/models/temporada.dart';
import 'package:trajineras/state/flujo_reserva_controller.dart';
import 'package:trajineras/state/preferencias_controller.dart';
import 'package:trajineras/state/reservas_controller.dart';

class EntornoDePrueba {
  EntornoDePrueba({DateTime? ahora})
    : reloj = RelojFijo(ahora ?? DateTime(2026, 10, 27, 10)) {
    catalogo = CatalogoRepositoryMock(reloj: reloj);
    repositorio = ReservaRepositoryMemoria(
      iniciales: DatosMock.reservasSemilla(Temporada.vigente(reloj.ahora())),
    );
    preferencias = PreferenciasController(
      reloj: reloj,
      perfil: DatosMock.perfilDemo,
    );
    reservas = ReservasController(
      reloj: reloj,
      reservas: repositorio,
      catalogo: catalogo,
      usuarioId: DatosMock.usuarioDemoId,
      preferencias: preferencias,
    )..cargar();
    flujo = FlujoReservaController(reloj: reloj, catalogo: catalogo)..cargar();
  }

  final RelojFijo reloj;
  late final CatalogoRepository catalogo;
  late final ReservaRepositoryMemoria repositorio;
  late final PreferenciasController preferencias;
  late final ReservasController reservas;
  late final FlujoReservaController flujo;

  Widget app({Widget? hijo}) => MultiProvider(
    providers: [
      Provider<Reloj>.value(value: reloj),
      Provider<CatalogoRepository>.value(value: catalogo),
      Provider<ReservaRepository>.value(value: repositorio),
      ChangeNotifierProvider.value(value: preferencias),
      ChangeNotifierProvider.value(value: reservas),
      ChangeNotifierProvider.value(value: flujo),
    ],
    child: hijo ?? const TrajinerasApp(),
  );

  Future<void> montar(WidgetTester tester, {double alto = 800}) async {
    tester.view.physicalSize = Size(360, alto);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app());
    // Los repositorios en memoria tardan ~300 ms y no piden cuadros.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  Future<void> abrir(WidgetTester tester, String ruta) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pushNamed(ruta);
    await tester.pumpAndSettle();
  }

  Future<void> reservaDeOtro(WidgetTester tester, Reservacion r) async {
    final guardada = repositorio.guardar(r);
    await tester.pump(const Duration(milliseconds: 400));
    await guardada;
  }
}

Widget appDePrueba({Widget? hijo}) => EntornoDePrueba().app(hijo: hijo);
