import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/app.dart';
import 'package:trajineras/models/reservacion.dart';

import '../apoyo.dart';
import '../apoyo_app.dart';

void main() {
  final nov1 = DateTime(2026, 11, 1);

  Reservacion catrinaDeOtro(DateTime fecha, String horario) => reservaDePrueba(
    folio: 'DM-26-O${fecha.day}${horario.substring(0, 2)}',
    ruta: animas,
    trajinera: catrina,
    fecha: fecha,
    horario: horario,
    usuarioId: 'u2',
  );

  Future<EntornoDePrueba> abrirFecha(
    WidgetTester tester, {
    DateTime? ahora,
    int pasajeros = 12,
    DateTime? fecha,
    String? horario,
    List<Reservacion> otras = const [],
  }) async {
    final e = EntornoDePrueba(ahora: ahora);
    await e.montar(tester, alto: 1400);
    for (final r in otras) {
      await e.reservaDeOtro(tester, r);
    }
    e.flujo
      ..iniciar(animas, contacto: contactoLucia)
      ..cambiarPasajeros(pasajeros)
      ..elegirTrajinera(catrina);
    if (fecha != null) e.flujo.elegirFecha(fecha);
    if (horario != null) e.flujo.elegirHorario(horario);
    await e.abrir(tester, RutasApp.fechaHorario);
    return e;
  }

  List<String> chips(WidgetTester tester) => [
    for (final c in tester.widgetList<FilterChip>(find.byType(FilterChip)))
      (c.label as Text).data!,
  ];

  List<String> alternativas(WidgetTester tester) => [
    for (final t in tester.widgetList<Text>(
      find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.byType(Text),
      ),
    ))
      t.data!,
  ];

  bool puedeContinuar(WidgetTester tester) =>
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continuar'))
          .onPressed !=
      null;

  Future<void> tocar(WidgetTester tester, Finder f) async {
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  testWidgets('La Catrina el 1 nov: 19:30 y 21:00 ocupados, 18:00 libre', (
    tester,
  ) async {
    final e = await abrirFecha(tester, fecha: nov1);
    expect(find.text('Horarios disponibles · Dom 1 nov'), findsOneWidget);
    expect(chips(tester), ['18:00', '19:30 · Ocupado', '21:00 · Ocupado']);
    expect(puedeContinuar(tester), isFalse);

    expect(find.text('19:30 ya está reservado en La Catrina'), findsOneWidget);
    await tocar(tester, find.text('21:00 · Ocupado'));
    expect(e.flujo.horario, isNull);
    expect(find.text('21:00 ya está reservado en La Catrina'), findsOneWidget);

    await tocar(tester, find.widgetWithText(FilterChip, '18:00'));
    expect(e.flujo.horario, '18:00');
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, '18:00'))
          .selected,
      isTrue,
    );
    expect(find.text('Dom 1 nov · 18:00'), findsOneWidget);
    expect(puedeContinuar(tester), isTrue);
  });

  testWidgets('las alternativas respetan la capacidad', (tester) async {
    await abrirFecha(tester, fecha: nov1);
    expect(alternativas(tester), [
      '18:00 · La Catrina',
      '19:30 · Flor de Cempasúchil',
      'Lun 2 nov · 19:30 · La Catrina',
    ]);
  });

  testWidgets('con 15 pasajeros no se sugiere otra trajinera', (tester) async {
    await abrirFecha(tester, fecha: nov1, pasajeros: 15);
    expect(alternativas(tester), [
      '18:00 · La Catrina',
      'Lun 2 nov · 19:30 · La Catrina',
    ]);
  });

  testWidgets('un día sin horarios libres explica el día completo', (
    tester,
  ) async {
    final e = await abrirFecha(
      tester,
      fecha: nov1,
      otras: [catrinaDeOtro(nov1, '18:00')],
    );
    expect(chips(tester), [
      '18:00 · Ocupado',
      '19:30 · Ocupado',
      '21:00 · Ocupado',
    ]);
    expect(
      find.text('No quedan horarios este día en La Catrina'),
      findsOneWidget,
    );
    expect(alternativas(tester), [
      '18:00 · Flor de Cempasúchil',
      'Lun 2 nov · 18:00 · La Catrina',
    ]);
    expect(puedeContinuar(tester), isFalse);

    await tocar(tester, find.text('21:00 · Ocupado'));
    expect(find.text('21:00 ya está reservado en La Catrina'), findsOneWidget);
    expect(alternativas(tester), [
      '21:00 · Flor de Cempasúchil',
      'Lun 2 nov · 21:00 · La Catrina',
    ]);

    await tocar(tester, find.text('21:00 · Flor de Cempasúchil'));
    expect((e.flujo.trajinera, e.flujo.horario), (flor, '21:00'));
    expect(
      find.text('Cambiamos tu trajinera a Flor de Cempasúchil'),
      findsOneWidget,
    );
    expect(chips(tester), ['18:00', '19:30', '21:00']);
    expect(puedeContinuar(tester), isTrue);
  });

  testWidgets('el último día de la temporada no sugiere días siguientes', (
    tester,
  ) async {
    final nov3 = DateTime(2026, 11, 3);
    await abrirFecha(
      tester,
      fecha: nov3,
      otras: [catrinaDeOtro(nov3, '18:00'), catrinaDeOtro(nov3, '21:00')],
    );
    expect(find.text('Horarios disponibles · Mar 3 nov'), findsOneWidget);
    expect(chips(tester).every((c) => c.endsWith('Ocupado')), isTrue);
    expect(alternativas(tester), ['18:00 · Flor de Cempasúchil']);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_right),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('el último día libre muestra sus horarios sin alternativas', (
    tester,
  ) async {
    await abrirFecha(tester, fecha: DateTime(2026, 11, 3));
    expect(chips(tester), ['18:00', '19:30', '21:00']);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  group('hoy (27 oct): solo con 1 h de anticipación', () {
    final casos = {
      DateTime(2026, 10, 27, 17): ['18:00', '19:30', '21:00'],
      DateTime(2026, 10, 27, 17, 1): ['19:30', '21:00'],
      DateTime(2026, 10, 27, 19): ['21:00'],
      DateTime(2026, 10, 27, 20, 1): <String>[],
    };
    for (final MapEntry(key: ahora, value: esperados) in casos.entries) {
      testWidgets(
        'a las ${ahora.hour}:${ahora.minute.toString().padLeft(2, '0')}',
        (tester) async {
          await abrirFecha(tester, ahora: ahora, fecha: DateTime(2026, 10, 27));
          expect(chips(tester), esperados);
          if (esperados.isEmpty) {
            expect(
              find.text(
                'Ya no quedan salidas este día: se reserva con al menos 1 h de '
                'anticipación.',
              ),
              findsOneWidget,
            );
            expect(alternativas(tester), ['Mié 28 oct · 18:00 · La Catrina']);
          } else {
            expect(find.byType(OutlinedButton), findsNothing);
          }
        },
      );
    }
  });

  testWidgets('el horario que otra persona ganó se suelta al abrir', (
    tester,
  ) async {
    final e = await abrirFecha(
      tester,
      fecha: nov1,
      horario: '18:00',
      otras: [catrinaDeOtro(nov1, '18:00')],
    );
    expect(e.flujo.horario, isNull);
    expect(e.flujo.fecha, nov1);
    expect(find.text('Dom 1 nov'), findsOneWidget);
    expect(find.text('18:00 ya está reservado en La Catrina'), findsOneWidget);
    expect(puedeContinuar(tester), isFalse);
  });

  testWidgets('calendario: 29 oct tachado y bloqueado; lunes 2 nov sí', (
    tester,
  ) async {
    final e = await abrirFecha(tester);
    expect(find.text('Octubre 2026'), findsOneWidget);
    expect(find.text('Elige una fecha para ver los horarios.'), findsOneWidget);

    final dia29 = tester.widget<Text>(find.text('29'));
    expect(dia29.style?.decoration, TextDecoration.lineThrough);
    await tocar(tester, find.text('29'));
    await tocar(tester, find.text('26'));
    expect(e.flujo.fecha, isNull);

    await tocar(tester, find.byTooltip('Mes siguiente'));
    expect(find.text('Noviembre 2026'), findsOneWidget);
    await tocar(tester, find.text('2').first); // el otro "2" es el 2 dic
    expect(e.flujo.fecha, DateTime(2026, 11, 2));
    expect(find.text('Horarios disponibles · Lun 2 nov'), findsOneWidget);
    expect(chips(tester), ['18:00', '19:30', '21:00']);

    await tocar(tester, find.widgetWithText(FilterChip, '21:00'));
    await tocar(tester, find.text('3').first);
    expect((e.flujo.fecha, e.flujo.horario), (DateTime(2026, 11, 3), null));
  });
}
