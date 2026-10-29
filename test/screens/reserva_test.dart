import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/state/flujo_reserva_controller.dart';
import 'package:trajineras/state/reservas_controller.dart';

import '../apoyo.dart';
import '../apoyo_app.dart';

void main() {
  FlujoReservaController flujoDe(WidgetTester tester) =>
      tester.element(find.byType(Scaffold).last).read<FlujoReservaController>();

  ReservasController reservasDe(WidgetTester tester) =>
      tester.element(find.byType(Scaffold).last).read<ReservasController>();

  Finder scrollable() => find.byType(Scrollable).first;

  Future<void> tocar(WidgetTester tester, Finder f) async {
    if (f.evaluate().isEmpty) {
      await tester.scrollUntilVisible(f, 200, scrollable: scrollable());
    }
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Future<EntornoDePrueba> abrirPaso1(WidgetTester tester) async {
    final e = EntornoDePrueba();
    await e.montar(tester);
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reservar ahora'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué ruta?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Sendero de las Ánimas'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Elige tu trajinera'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    return e;
  }

  Future<void> pasajeros(WidgetTester tester, int n) async {
    final actual = flujoDe(tester).pasajeros;
    final boton = n > actual ? 'Agregar un pasajero' : 'Quitar un pasajero';
    // El stepper está arriba de la lista y puede haberse descartado.
    await tester.scrollUntilVisible(
      find.byTooltip(boton),
      -300,
      scrollable: scrollable(),
    );
    await tester.ensureVisible(find.byTooltip(boton));
    await tester.pumpAndSettle();
    for (var i = 0; i < (n - actual).abs(); i++) {
      await tester.tap(find.byTooltip(boton));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> irAlDiaUnoNov(WidgetTester tester) async {
    await pasajeros(tester, 12);
    await tocar(tester, find.text('La Catrina'));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Octubre 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Mes siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Noviembre 2026'), findsOneWidget);
    await tester.tap(find.text('1').first); // el otro "1" es el 1 dic
    await tester.pumpAndSettle();
  }

  testWidgets('paso 1: stepper, motivos de deshabilitación y filtros', (
    tester,
  ) async {
    await abrirPaso1(tester);
    expect(find.text('Deshabilitamos las de menor capacidad'), findsOneWidget);
    expect(find.text('Pasajeros'), findsWidgets);
    expect(find.text('1 pasajero'), findsOneWidget);

    await pasajeros(tester, 12);
    expect(find.text('12'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lucero'),
      300,
      scrollable: scrollable(),
    );
    expect(
      find.text('Capacidad insuficiente para 12 pasajeros'),
      findsNWidgets(2),
    );

    await pasajeros(tester, 8);
    expect(find.text('Capacidad insuficiente para 8 pasajeros'), findsNothing);

    await tocar(tester, find.text('Lucero'));
    expect(find.text('Lucero · 8 pasajeros'), findsOneWidget);
    await pasajeros(tester, 9);
    expect(flujoDe(tester).trajinera, isNull);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continuar'))
          .onPressed,
      isNull,
    );

    await pasajeros(tester, 12);
    await tester.tap(find.widgetWithText(FilterChip, 'Accesibles'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Ninguna trajinera de "Accesibles"'),
      findsOneWidget,
    );
    expect(find.text('La Catrina'), findsNothing);
  });

  testWidgets('paso 2: ocupados, alternativas y cambio de trajinera', (
    tester,
  ) async {
    await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);

    expect(find.text('Horarios disponibles · Dom 1 nov'), findsOneWidget);
    expect(find.text('19:30 · Ocupado'), findsOneWidget);
    expect(find.text('21:00 · Ocupado'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, '18:00'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('18:00 · La Catrina'),
      200,
      scrollable: scrollable(),
    );
    expect(find.text('19:30 ya está reservado en La Catrina'), findsOneWidget);
    expect(find.text('18:00 · La Catrina'), findsOneWidget);

    await tocar(tester, find.text('21:00 · Ocupado'));
    expect(flujoDe(tester).horario, isNull);
    expect(find.text('21:00 ya está reservado en La Catrina'), findsOneWidget);

    final otra = find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data != null &&
            !w.data!.contains('La Catrina') &&
            w.data!.startsWith('21:00'),
      ),
    );
    expect(otra, findsOneWidget);
    final texto = tester.widget<Text>(otra).data!;
    await tocar(tester, otra);
    final flujo = flujoDe(tester);
    expect(flujo.trajinera?.nombre, isNot('La Catrina'));
    expect(texto, contains(flujo.trajinera!.nombre));
    expect(flujo.horario, '21:00');
    expect(flujo.fecha, DateTime(2026, 11, 1));
    expect(find.textContaining('Cambiamos tu trajinera'), findsOneWidget);
    expect(find.text('Dom 1 nov · 21:00'), findsOneWidget);
  });

  testWidgets('recorrido completo: datos, resumen, confirmación y atrás', (
    tester,
  ) async {
    await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await tocar(tester, find.widgetWithText(FilterChip, '18:00'));
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Tus datos'), findsOneWidget);
    expect(find.text('Lucía Hernández'), findsOneWidget);
    expect(find.text('55 1234 5678'), findsOneWidget);
    expect(find.text('Máximo 20 personas en La Catrina'), findsOneWidget);
    FilledButton continuar() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continuar al resumen'),
    );
    expect(continuar().onPressed, isNull);
    expect(
      find.text('Acepta el aviso de privacidad para continuar.'),
      findsOneWidget,
    );

    await tocar(tester, find.byType(Checkbox));
    expect(continuar().onPressed, isNotNull);

    final telefono = find.widgetWithText(TextFormField, 'Teléfono');
    await tester.enterText(telefono, '55123');
    await tester.pumpAndSettle();
    expect(find.text('55 123'), findsOneWidget);
    expect(find.text('El teléfono debe tener 10 dígitos'), findsOneWidget);
    expect(
      find.text('Corrige los campos marcados para continuar.'),
      findsOneWidget,
    );
    expect(continuar().onPressed, isNull);
    await tester.enterText(telefono, '5598765432');
    await tester.pumpAndSettle();
    expect(continuar().onPressed, isNotNull);
    await tocar(tester, find.text('Continuar al resumen'));

    expect(find.text('Resumen y pago'), findsWidgets);
    expect(find.text('Dom 1 nov 2026'), findsOneWidget);
    expect(find.text('18:00 · 2 h'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(r'$4,200 MXN'),
      200,
      scrollable: scrollable(),
    );
    await tocar(tester, find.text('Fotógrafo'));
    expect(find.text(r'$5,000 MXN'), findsOneWidget);
    expect(find.text(r'$1,500 MXN'), findsOneWidget);
    expect(find.text(r'Restan $3,500 en el embarcadero'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Editar'),
      -300,
      scrollable: scrollable(),
    );
    await tocar(tester, find.text('Editar'));
    expect(find.text('Elige tu trajinera'), findsOneWidget);
    expect(find.text('La Catrina · 12 pasajeros'), findsOneWidget);
    await tocar(tester, find.text('Continuar'));
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);
    await tocar(tester, find.text('Continuar'));
    await tocar(tester, find.text('Continuar al resumen'));
    expect(find.text(r'$1,500 MXN'), findsOneWidget);

    final antes = reservasDe(tester).todas.length;
    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton).last, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(reservasDe(tester).todas.length, antes + 1);

    expect(find.text('¡Reservación confirmada!'), findsOneWidget);
    final folio = reservasDe(tester).todas.last.folio;
    expect(folio, matches(RegExp(r'^DM-26-[A-HJ-NP-Z2-9]{4}$')));
    expect(find.text(folio), findsOneWidget);
    expect(find.text('Pendiente de verificación'), findsOneWidget);
    expect(find.text('Embarcadero Nuevo Nativitas · muelle 3'), findsOneWidget);
    expect(find.text('Preséntate a las 17:30 (30 min antes)'), findsOneWidget);
    expect(flujoDe(tester).ruta, isNull);

    await tocar(tester, find.text('Simular pago del anticipo'));
    expect(find.text('Anticipo pagado'), findsOneWidget);
    expect(find.text('Pagada'), findsOneWidget);
    expect(find.text('Simular pago del anticipo'), findsNothing);

    await tocar(tester, find.text('Comprobante'));
    expect(find.text('Detalle de reservación'), findsOneWidget);
    expect(find.text(folio), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Anticipo pagado (30 %)'),
      200,
      scrollable: scrollable(),
    );
    expect(find.text('Tarjeta (simulado)'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Confirmación'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
    expect(find.text('Resumen y pago'), findsNothing);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator).first).canPop(),
      isFalse,
    );
  });

  testWidgets('"Ir a mis reservaciones" abre esa pestaña', (tester) async {
    await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await tocar(tester, find.widgetWithText(FilterChip, '18:00'));
    await tocar(tester, find.text('Continuar'));
    expect(find.text('Tus datos'), findsOneWidget);
    await tocar(tester, find.byType(Checkbox));
    await tocar(tester, find.text('Continuar al resumen'));
    await tocar(tester, find.widgetWithText(FilledButton, 'Confirmar'));

    await tocar(tester, find.text('Ir a mis reservaciones'));
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
  });

  const yaNoEnCurso = 'Esta reservación ya no está en curso.';

  Future<void> hastaResumen(
    WidgetTester tester, {
    String horario = '18:00',
  }) async {
    await tocar(tester, find.widgetWithText(FilterChip, horario));
    await tocar(tester, find.text('Continuar'));
    expect(find.text('Tus datos'), findsOneWidget);
    if (!flujoDe(tester).avisoAceptado) {
      await tocar(tester, find.byType(Checkbox));
    }
    await tocar(tester, find.text('Continuar al resumen'));
    expect(find.text('Resumen y pago'), findsWidgets);
  }

  Future<void> atras(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  testWidgets('flujo completo sin errores el 27 oct 2026', (tester) async {
    final e = await abrirPaso1(tester);
    expect(e.reloj.ahora(), DateTime(2026, 10, 27, 10));
    final antes = e.reservas.todas.length;

    await irAlDiaUnoNov(tester);
    expect(tester.takeException(), isNull);
    await hastaResumen(tester);
    expect(tester.takeException(), isNull);
    await tocar(tester, find.text('Fotógrafo'));
    expect(find.text(r'$1,500 MXN'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar'));
    for (
      var i = 0;
      i < 100 && find.text('¡Reservación confirmada!').evaluate().isEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text(yaNoEnCurso), findsNothing);
    }
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.text(yaNoEnCurso), findsNothing);
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('¡Reservación confirmada!'), findsOneWidget);

    expect(e.reservas.todas, hasLength(antes + 1));
    final r = e.reservas.todas.last;
    expect(
      (r.rutaId, r.trajineraId, r.fecha, r.horario, r.pasajeros),
      (animas.id, catrina.id, '2026-11-01', '18:00', 12),
    );
    expect(r.serviciosIds, ['srv_fotografo']);
    expect(
      (r.subtotal, r.anticipo, r.estado),
      (5000, 1500, EstadoReservacion.pendiente),
    );
    expect(r.contacto.telefono, '5512345678');

    await atras(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(e.flujo.ruta, isNull);
    await tocar(tester, find.text('Reservar ahora'));
    expect(find.text('¿Qué ruta?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('alternativa con otra trajinera: el resumen la muestra con sus '
      'servicios', (tester) async {
    final e = await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await tocar(tester, find.text('19:30 · Flor de Cempasúchil'));
    expect(find.text('Dom 1 nov · 19:30'), findsOneWidget);

    await tocar(tester, find.text('Continuar'));
    expect(
      find.text('Máximo 14 personas en Flor de Cempasúchil'),
      findsOneWidget,
    );
    await tocar(tester, find.byType(Checkbox));
    await tocar(tester, find.text('Continuar al resumen'));

    expect(find.text('Flor de Cempasúchil'), findsOneWidget);
    expect(find.text('19:30 · 2 h'), findsOneWidget);
    expect(find.text(r'$1,185 MXN'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Tarifa trajinera Flor de Cempasúchil'),
      200,
      scrollable: scrollable(),
    );
    expect(find.text('Cena tradicional'), findsOneWidget);
    expect(find.text('Fotógrafo'), findsOneWidget);
    expect(find.text('Mariachi exclusivo'), findsNothing);
    expect(find.text(r'$3,950 MXN'), findsOneWidget);

    await tocar(tester, find.widgetWithText(FilledButton, 'Confirmar'));
    expect(find.text('¡Reservación confirmada!'), findsOneWidget);
    final r = e.reservas.todas.last;
    expect((r.trajineraId, r.horario, r.subtotal), (flor.id, '19:30', 3950));
  });

  testWidgets('Tus datos rechaza más pasajeros que la capacidad; "Editar" y '
      'otra trajinera', (tester) async {
    final e = await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await tocar(tester, find.widgetWithText(FilterChip, '18:00'));
    await tocar(tester, find.text('Continuar'));

    final campo = find.widgetWithText(TextFormField, 'Número de pasajeros');
    FilledButton continuar() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continuar al resumen'),
    );
    await tocar(tester, find.byType(Checkbox));
    await tester.enterText(campo, '25');
    await tester.pumpAndSettle();
    expect(find.text('Máximo 20 personas en La Catrina'), findsOneWidget);
    expect(continuar().onPressed, isNull);
    expect(e.flujo.pasajeros, 12);
    expect(e.flujo.trajinera, catrina);

    await tester.enterText(campo, '14');
    await tester.pumpAndSettle();
    await tocar(tester, find.text('Continuar al resumen'));
    expect(find.text('14 personas'), findsOneWidget);
    await tocar(tester, find.text('Mariachi exclusivo'));
    await tocar(tester, find.text('Fotógrafo'));
    expect(find.text(r'$2,100 MXN'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Editar'),
      -300,
      scrollable: scrollable(),
    );
    await tocar(tester, find.text('Editar'));
    expect(find.text('La Catrina · 14 pasajeros'), findsOneWidget);
    await tocar(tester, find.text('Flor de Cempasúchil'));
    expect(find.text('Flor de Cempasúchil · 14 pasajeros'), findsOneWidget);

    await tocar(tester, find.text('Continuar'));
    expect(find.text('Dom 1 nov'), findsOneWidget);
    expect(e.flujo.horario, isNull);
    await hastaResumen(tester);

    expect(find.text('Flor de Cempasúchil'), findsOneWidget);
    expect(find.text('14 personas'), findsOneWidget);
    expect([for (final s in e.flujo.servicios) s.id], ['srv_fotografo']);
    expect(find.text(r'$1,575 MXN'), findsOneWidget);

    await tocar(tester, find.widgetWithText(FilledButton, 'Confirmar'));
    final r = e.reservas.todas.last;
    expect((r.trajineraId, r.pasajeros, r.subtotal), (flor.id, 14, 5250));
    expect(r.serviciosIds, ['srv_fotografo']);
  });

  testWidgets('el horario se ocupa mientras se llena el formulario', (
    tester,
  ) async {
    final e = await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await hastaResumen(tester);
    final antes = e.reservas.todas.length;

    await e.reservaDeOtro(
      tester,
      reservaDePrueba(
        folio: 'DM-26-GANO',
        ruta: animas,
        trajinera: catrina,
        fecha: DateTime(2026, 11, 1),
        horario: '18:00',
        usuarioId: 'u2',
      ),
    );
    await tocar(tester, find.widgetWithText(FilledButton, 'Confirmar'));

    expect(
      find.text(
        'Alguien acaba de reservar las 18:00 del Dom 1 nov en La Catrina. '
        'Elige otro horario.',
      ),
      findsOneWidget,
    );
    expect(find.text('Dom 1 nov'), findsOneWidget);
    expect(e.flujo.horario, isNull);
    expect(e.reservas.todas, hasLength(antes));

    // Al recargar, las 18:00 salen "Ocupado" y la tarjeta las explica. Se
    // espera a que el aviso se cierre: tapa el final de la lista.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.textContaining('Alguien acaba de reservar'), findsNothing);
    expect(find.text('18:00 · Ocupado'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, '18:00'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('18:00 · Flor de Cempasúchil'),
      200,
      scrollable: scrollable(),
    );
    expect(find.text('18:00 ya está reservado en La Catrina'), findsOneWidget);
    await tocar(tester, find.text('18:00 · Flor de Cempasúchil'));
    expect(find.text('18:00 ya está reservado en La Catrina'), findsNothing);
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);

    await tocar(tester, find.text('Continuar'));
    await tocar(tester, find.text('Continuar al resumen'));
    await tocar(tester, find.widgetWithText(FilledButton, 'Confirmar'));
    expect(find.text('¡Reservación confirmada!'), findsOneWidget);
    expect(e.reservas.todas.last.trajineraId, flor.id);
  });

  testWidgets('doble toque en "Confirmar" antes de redibujar guarda una', (
    tester,
  ) async {
    final e = await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await hastaResumen(tester);
    final antes = e.reservas.todas.length;

    final confirmar = find.widgetWithText(FilledButton, 'Confirmar');
    await tester.tap(confirmar);
    await tester.tap(confirmar); // sin cuadro de por medio
    await tester.pumpAndSettle();

    expect(e.reservas.todas, hasLength(antes + 1));
    expect(find.text('¡Reservación confirmada!'), findsOneWidget);
    expect(find.textContaining('Alguien acaba de reservar'), findsNothing);
  });

  testWidgets('atrás de Android en cada paso', (tester) async {
    final e = await abrirPaso1(tester);
    await irAlDiaUnoNov(tester);
    await hastaResumen(tester);

    await atras(tester);
    expect(find.text('Tus datos'), findsOneWidget);
    await atras(tester);
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);
    await atras(tester);
    expect(find.text('La Catrina · 12 pasajeros'), findsOneWidget);
    await atras(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(e.flujo.horario, '18:00');

    await tocar(tester, find.text('Reservar ahora'));
    expect(find.text('La Catrina · 12 pasajeros'), findsOneWidget);
    await tocar(tester, find.text('Continuar'));
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);
    await tocar(tester, find.text('Continuar'));
    await tocar(tester, find.text('Continuar al resumen'));

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar'));
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Resumen y pago'), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.text('¡Reservación confirmada!'), findsOneWidget);

    await atras(tester);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
    expect(
      tester.state<NavigatorState>(find.byType(Navigator).first).canPop(),
      isFalse,
    );

    await tocar(tester, find.text('Reservar ahora'));
    expect(find.text('¿Qué ruta?'), findsOneWidget);
    await atras(tester);
    expect(find.text('¿Qué ruta?'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
