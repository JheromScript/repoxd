import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/models/reservacion.dart';

import '../apoyo_app.dart';

void main() {
  Finder tarjeta(String folio) => find.byKey(ValueKey('reserva-$folio'));

  Finder enTarjeta(String folio, String texto) =>
      find.descendant(of: tarjeta(folio), matching: find.text(texto));

  Finder enDialogo(Finder f) =>
      find.descendant(of: find.byType(AlertDialog), matching: f);

  Reservacion reservaDe(EntornoDePrueba e, String folio) =>
      e.reservas.todas.firstWhere((r) => r.folio == folio);

  Future<EntornoDePrueba> abrirMisReservas(
    WidgetTester tester, {
    DateTime? ahora,
  }) async {
    final e = EntornoDePrueba(ahora: ahora);
    await e.montar(tester, alto: 1400);
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mis reservas'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsNothing);
    expect(find.text('Mis reservaciones'), findsWidgets);
    return e;
  }

  Future<void> tocarCancelar(WidgetTester tester, String folio) async {
    await tester.ensureVisible(enTarjeta(folio, 'Cancelar'));
    await tester.tap(enTarjeta(folio, 'Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Cancelar reservación?'), findsOneWidget);
  }

  Future<void> confirmarCancelacion(WidgetTester tester) async {
    await tester.tap(enDialogo(find.text('Sí, cancelar')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  group('filtros', () {
    testWidgets('cada filtro muestra solo lo suyo', (tester) async {
      await abrirMisReservas(tester);

      expect(tarjeta('DM-26-K7Q2'), findsOneWidget);
      expect(tarjeta('DM-26-A3F9'), findsOneWidget);
      expect(tarjeta('DM-26-Z81M'), findsNothing);
      expect(tarjeta('DM-25-P5T8'), findsNothing);
      expect(find.textContaining('hasta 24 h antes'), findsOneWidget);
      expect(enTarjeta('DM-26-K7Q2', 'Pagar'), findsNothing);
      expect(enTarjeta('DM-26-K7Q2', 'Cambiar'), findsOneWidget);
      expect(enTarjeta('DM-26-A3F9', 'Pagar'), findsOneWidget);

      await tester.tap(find.text('Pasadas'));
      await tester.pumpAndSettle();
      expect(tarjeta('DM-25-P5T8'), findsOneWidget);
      expect(tarjeta('DM-26-K7Q2'), findsNothing);
      expect(enTarjeta('DM-25-P5T8', 'Cancelar'), findsNothing);
      expect(enTarjeta('DM-25-P5T8', 'Cambiar'), findsNothing);

      await tester.tap(find.text('Canceladas'));
      await tester.pumpAndSettle();
      expect(tarjeta('DM-26-Z81M'), findsOneWidget);
      expect(
        enTarjeta('DM-26-Z81M', 'Anticipo reembolsado (\$525)'),
        findsOneWidget,
      );
      expect(enTarjeta('DM-26-Z81M', 'Detalle'), findsOneWidget);
      expect(enTarjeta('DM-26-Z81M', 'Cancelar'), findsNothing);
    });

    testWidgets('sin reservaciones: estado vacío con "Ver rutas"', (
      tester,
    ) async {
      final e = await abrirMisReservas(tester);
      await tocarCancelar(tester, 'DM-26-K7Q2');
      await confirmarCancelacion(tester);
      await tocarCancelar(tester, 'DM-26-A3F9');
      await confirmarCancelacion(tester);
      expect(e.reservas.proximas, isEmpty);

      expect(find.text('No tienes reservaciones próximas'), findsOneWidget);
      await tester.tap(find.text('Ver rutas'));
      await tester.pumpAndSettle();
      expect(find.text('Rutas disponibles'), findsOneWidget);
    });
  });

  group('cancelar (regla 9)', () {
    testWidgets('pendiente: sin cargo', (tester) async {
      final e = await abrirMisReservas(tester);
      await tocarCancelar(tester, 'DM-26-A3F9');
      expect(
        enDialogo(
          find.text(
            'Tu recorrido del Dom 1 nov (folio DM-26-A3F9) aún no tiene pago '
            'del anticipo, así que se cancelará sin cargo.',
          ),
        ),
        findsOneWidget,
      );

      await tester.tap(enDialogo(find.text('Volver')));
      await tester.pumpAndSettle();
      expect(reservaDe(e, 'DM-26-A3F9').estado, EstadoReservacion.pendiente);

      await tocarCancelar(tester, 'DM-26-A3F9');
      await confirmarCancelacion(tester);
      final r = reservaDe(e, 'DM-26-A3F9');
      expect(r.estado, EstadoReservacion.cancelada);
      expect(r.montoReembolsado, 0);
      expect(tarjeta('DM-26-A3F9'), findsNothing);

      await tester.tap(find.text('Canceladas'));
      await tester.pumpAndSettle();
      expect(enTarjeta('DM-26-A3F9', 'Cancelada sin cargo'), findsOneWidget);
    });

    testWidgets('pagada con más de 24 h: reembolso del anticipo', (
      tester,
    ) async {
      final e = await abrirMisReservas(tester);
      await tocarCancelar(tester, 'DM-26-K7Q2');
      expect(
        enDialogo(
          find.text(
            'Tu recorrido del Sáb 31 oct (folio DM-26-K7Q2) es en más de '
            '24 h, así que se reembolsará tu anticipo de \$1,500 MXN en 3 a '
            '5 días hábiles.',
          ),
        ),
        findsOneWidget,
      );
      await confirmarCancelacion(tester);

      final r = reservaDe(e, 'DM-26-K7Q2');
      expect(r.estado, EstadoReservacion.cancelada);
      expect(r.montoReembolsado, 1500);
      expect(find.textContaining('Reembolsaremos \$1,500'), findsOneWidget);
    });

    testWidgets('pagada con 24 h o menos: sin reembolso', (tester) async {
      final e = await abrirMisReservas(
        tester,
        ahora: DateTime(2026, 10, 31, 9),
      );
      expect(enTarjeta('DM-26-K7Q2', 'Cambiar'), findsNothing);

      await tocarCancelar(tester, 'DM-26-K7Q2');
      expect(
        enDialogo(
          find.text(
            'Tu recorrido del Sáb 31 oct (folio DM-26-K7Q2) es en 24 h o '
            'menos, así que no se reembolsará tu anticipo de \$1,500 MXN.',
          ),
        ),
        findsOneWidget,
      );
      await confirmarCancelacion(tester);

      final r = reservaDe(e, 'DM-26-K7Q2');
      expect(r.estado, EstadoReservacion.cancelada);
      expect(r.montoReembolsado, 0);
    });
  });

  testWidgets('Pagar: "Procesando…" y luego "Anticipo pagado"', (tester) async {
    final e = await abrirMisReservas(tester);
    await tester.tap(enTarjeta('DM-26-A3F9', 'Pagar'));
    await tester.pump();
    expect(find.text('Procesando pago…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Anticipo pagado'), findsOneWidget);
    expect(reservaDe(e, 'DM-26-A3F9').estado, EstadoReservacion.pagada);
    expect(enTarjeta('DM-26-A3F9', 'Pagar'), findsNothing);
    expect(enTarjeta('DM-26-A3F9', 'Pagada'), findsOneWidget);
  });

  testWidgets('Detalle abre el Detalle de reservación', (tester) async {
    await abrirMisReservas(tester);
    await tester.tap(enTarjeta('DM-26-K7Q2', 'Detalle'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle de reservación'), findsOneWidget);
    expect(find.text('DM-26-K7Q2'), findsWidgets);
  });

  group('cambiar (regla 9)', () {
    testWidgets('misma trajinera y pasajeros, sin chocar consigo misma y '
        'con el mismo folio', (tester) async {
      final e = await abrirMisReservas(tester);
      final original = reservaDe(e, 'DM-26-K7Q2');

      await tester.tap(enTarjeta('DM-26-K7Q2', 'Cambiar'));
      await tester.pumpAndSettle();
      expect(find.text('Cambiar reservación'), findsOneWidget);
      expect(find.textContaining('La Catrina, 12 pasajeros'), findsOneWidget);

      expect(find.textContaining('Ocupado'), findsNothing);
      final guardar = find.widgetWithText(FilledButton, 'Guardar');
      expect(tester.widget<FilledButton>(guardar).onPressed, isNull);

      await tester.tap(find.widgetWithText(FilterChip, '19:30'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(guardar).onPressed, isNotNull);
      await tester.tap(guardar);
      // `cambiar` lee y revalida en varios pasos de ~300 ms cada uno.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(
        find.text('Cambiamos tu reservación al Sáb 31 oct · 19:30'),
        findsOneWidget,
      );
      final cambiada = reservaDe(e, 'DM-26-K7Q2');
      expect(cambiada.folio, original.folio);
      expect(cambiada.horario, '19:30');
      expect(cambiada.fecha, original.fecha);
      expect(cambiada.trajineraId, original.trajineraId);
      expect(cambiada.pasajeros, original.pasajeros);
      expect(cambiada.estado, EstadoReservacion.pagada);
      expect(
        e.reservas.todas.where((r) => r.folio == original.folio),
        hasLength(1),
      );
      expect(e.flujo.ruta, isNull);
    });

    testWidgets('el 1 nov se ven los horarios ocupados por otros', (
      tester,
    ) async {
      await abrirMisReservas(tester);
      await tester.tap(enTarjeta('DM-26-K7Q2', 'Cambiar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mes siguiente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1').first);
      await tester.pumpAndSettle();

      expect(find.text('19:30 · Ocupado'), findsOneWidget);
      expect(find.text('21:00 · Ocupado'), findsOneWidget);
      expect(find.textContaining('Flor de Cempasúchil'), findsNothing);
    });
  });
}
