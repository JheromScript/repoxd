import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/app.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/models/trajinera.dart';

import '../apoyo.dart';
import '../apoyo_app.dart';

void main() {
  Future<EntornoDePrueba> abrirDatos(
    WidgetTester tester, {
    Contacto? contacto = contactoLucia,
    Trajinera? trajinera,
    int pasajeros = 12,
  }) async {
    final e = EntornoDePrueba();
    await e.montar(tester);
    e.flujo
      ..iniciar(animas, contacto: contacto)
      ..cambiarPasajeros(pasajeros)
      ..elegirTrajinera(trajinera ?? catrina)
      ..elegirFecha(DateTime(2026, 11, 1))
      ..elegirHorario('18:00');
    await e.abrir(tester, RutasApp.datos);
    expect(find.text('Tus datos'), findsOneWidget);
    return e;
  }

  Finder campo(String etiqueta) => find.widgetWithText(TextFormField, etiqueta);

  Future<void> escribir(
    WidgetTester tester,
    String etiqueta,
    String texto,
  ) async {
    await tester.enterText(campo(etiqueta), texto);
    await tester.pumpAndSettle();
  }

  String textoDe(WidgetTester tester, String etiqueta) => tester
      .widget<EditableText>(
        find.descendant(
          of: campo(etiqueta),
          matching: find.byType(EditableText),
        ),
      )
      .controller
      .text;

  bool puedeContinuar(WidgetTester tester) =>
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Continuar al resumen'),
          )
          .onPressed !=
      null;

  Future<void> aceptarAviso(WidgetTester tester) async {
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
  }

  testWidgets('se pre-llena con el perfil y sin el aviso no continúa', (
    tester,
  ) async {
    final e = await abrirDatos(tester);
    expect(textoDe(tester, 'Nombre del responsable'), 'Lucía Hernández');
    expect(textoDe(tester, 'Teléfono'), '55 1234 5678');
    expect(textoDe(tester, 'Correo electrónico'), 'lucia.hdz@correo.com');
    expect(textoDe(tester, 'Número de pasajeros'), '12');
    expect(find.text('Máximo 20 personas en La Catrina'), findsOneWidget);
    expect(find.byIcon(Icons.error), findsNothing);

    expect(puedeContinuar(tester), isFalse);
    expect(
      find.text('Acepta el aviso de privacidad para continuar.'),
      findsOneWidget,
    );

    await aceptarAviso(tester);
    expect(e.flujo.avisoAceptado, isTrue);
    expect(puedeContinuar(tester), isTrue);
    expect(find.textContaining('para continuar'), findsNothing);

    await aceptarAviso(tester);
    expect(puedeContinuar(tester), isFalse);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).isError, isTrue);
  });

  testWidgets('valida cada campo en vivo y solo marca los que se tocaron', (
    tester,
  ) async {
    final e = await abrirDatos(tester);
    await aceptarAviso(tester);

    final casos = {
      'Nombre del responsable': {
        '': 'Escribe tu nombre',
        'Lu': 'Escribe al menos 3 letras',
        'Lucía 2': 'Usa solo letras y espacios',
      },
      'Teléfono': {
        '': 'Escribe tu teléfono',
        '55123': 'El teléfono debe tener 10 dígitos',
      },
      'Correo electrónico': {
        '': 'Escribe tu correo',
        'lucia@': 'Escribe un correo válido',
      },
    };
    for (final MapEntry(key: etiqueta, value: errores) in casos.entries) {
      for (final MapEntry(key: texto, value: mensaje) in errores.entries) {
        await escribir(tester, etiqueta, texto);
        expect(
          find.text(mensaje),
          findsOneWidget,
          reason: '$etiqueta: "$texto"',
        );
        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(
          find.text('Corrige los campos marcados para continuar.'),
          findsOneWidget,
        );
        expect(puedeContinuar(tester), isFalse);
      }
      await escribir(tester, etiqueta, switch (etiqueta) {
        'Nombre del responsable' => 'José Ñúñez',
        'Teléfono' => '5598765432',
        _ => 'jose@correo.mx',
      });
      expect(find.byIcon(Icons.error), findsNothing);
      expect(puedeContinuar(tester), isTrue);
    }

    expect(textoDe(tester, 'Teléfono'), '55 9876 5432');
    await escribir(tester, 'Teléfono', '55-9876-5432 99');
    expect(textoDe(tester, 'Teléfono'), '55 9876 5432');
    final c = e.flujo.contacto!;
    expect(
      (c.nombre, c.telefono, c.correo),
      ('José Ñúñez', '5598765432', 'jose@correo.mx'),
    );
  });

  testWidgets('pasajeros arriba de la capacidad no llegan al borrador', (
    tester,
  ) async {
    final e = await abrirDatos(tester);
    await aceptarAviso(tester);

    await escribir(tester, 'Número de pasajeros', '25');
    expect(find.text('Máximo 20 personas en La Catrina'), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
    expect(e.flujo.pasajeros, 12);
    expect(e.flujo.trajinera, catrina);
    expect(e.flujo.horario, '18:00');
    expect(puedeContinuar(tester), isFalse);

    await escribir(tester, 'Número de pasajeros', '0');
    expect(find.text('Debe haber al menos 1 pasajero'), findsOneWidget);
    await escribir(tester, 'Número de pasajeros', '');
    expect(find.text('Escribe cuántos pasajeros son'), findsOneWidget);
    expect(e.flujo.pasajeros, 12);

    await escribir(tester, 'Número de pasajeros', '150');
    expect(textoDe(tester, 'Número de pasajeros'), '15');

    expect(e.flujo.pasajeros, 15);
    expect(e.flujo.costos!.subtotal, 1200 + 250 * 15);
    expect(find.byIcon(Icons.error), findsNothing);
    expect(puedeContinuar(tester), isTrue);
  });

  testWidgets('el límite es la capacidad de la trajinera elegida', (
    tester,
  ) async {
    await abrirDatos(tester, trajinera: flor);
    await aceptarAviso(tester);
    expect(
      find.text('Máximo 14 personas en Flor de Cempasúchil'),
      findsOneWidget,
    );
    await escribir(tester, 'Número de pasajeros', '15');
    expect(puedeContinuar(tester), isFalse);
    await escribir(tester, 'Número de pasajeros', '14');
    expect(puedeContinuar(tester), isTrue);
  });

  testWidgets('sin contacto empieza vacío y no marca errores sin tocar', (
    tester,
  ) async {
    await abrirDatos(tester, contacto: null);
    expect(textoDe(tester, 'Nombre del responsable'), isEmpty);
    expect(find.byIcon(Icons.error), findsNothing);
    expect(find.text('Completa tus datos para continuar.'), findsOneWidget);
    expect(puedeContinuar(tester), isFalse);

    await escribir(tester, 'Nombre del responsable', 'Ana López');
    expect(find.text('Completa tus datos para continuar.'), findsOneWidget);
    await escribir(tester, 'Teléfono', '55');
    expect(
      find.text('Corrige los campos marcados para continuar.'),
      findsOneWidget,
    );
    await escribir(tester, 'Teléfono', '5511223344');
    await escribir(tester, 'Correo electrónico', 'ana@correo.mx');
    await aceptarAviso(tester);
    expect(puedeContinuar(tester), isTrue);
  });

  testWidgets('"Leer aviso de privacidad" abre la hoja con el texto', (
    tester,
  ) async {
    await abrirDatos(tester);
    await tester.tap(find.text('Leer aviso de privacidad'));
    await tester.pumpAndSettle();
    expect(find.text('Aviso de privacidad'), findsOneWidget);
    expect(find.textContaining('No pedimos datos de tarjeta'), findsOneWidget);
  });

  testWidgets('"Continuar al resumen" lleva lo escrito, sin espacios de más', (
    tester,
  ) async {
    await abrirDatos(tester);
    await escribir(tester, 'Nombre del responsable', '  Ana López  ');
    await escribir(tester, 'Número de pasajeros', '10');
    await aceptarAviso(tester);
    await tester.tap(find.text('Continuar al resumen'));
    await tester.pumpAndSettle();

    expect(find.text('Resumen y pago'), findsWidgets);
    expect(find.text('Ana López'), findsOneWidget);
    expect(find.text('10 personas'), findsOneWidget);
    expect(find.text(r'$1,110 MXN'), findsOneWidget);
  });
}
