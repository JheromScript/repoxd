import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trajineras/state/flujo_reserva_controller.dart';

import '../apoyo_app.dart';

void main() {
  Future<void> abrirRutas(WidgetTester tester, double ancho) async {
    tester.view.physicalSize = Size(ancho, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(appDePrueba());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Rutas'),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Rutas a 360 dp: dos tarjetas lado a lado y la tabla', (
    tester,
  ) async {
    await abrirRutas(tester, 360);

    expect(find.text('Rutas disponibles'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    final botones = find.widgetWithText(FilledButton, 'Elegir');
    expect(botones, findsNWidgets(2));
    expect(
      tester.getTopLeft(botones.at(0)).dy,
      tester.getTopLeft(botones.at(1)).dy,
    );
    expect(
      tester.getTopLeft(botones.at(1)).dx,
      greaterThan(tester.getTopLeft(botones.at(0)).dx),
    );

    expect(find.text('Comparación'), findsOneWidget);
    expect(find.text('Embarcadero Nuevo Nativitas'), findsOneWidget);
    expect(find.text('18:00 · 19:30 · 21:00'), findsOneWidget);
    expect(find.text('Incluye'), findsOneWidget);
  });

  testWidgets('Rutas a 320 dp: una columna', (tester) async {
    await abrirRutas(tester, 320);

    final botones = find.widgetWithText(FilledButton, 'Elegir');
    expect(botones, findsNWidgets(2));
    expect(
      tester.getTopLeft(botones.at(1)).dy,
      greaterThan(tester.getTopLeft(botones.at(0)).dy),
    );
  });

  testWidgets('"Elegir" inicia el flujo con la ruta y abre el paso 1', (
    tester,
  ) async {
    await abrirRutas(tester, 360);

    await tester.tap(find.widgetWithText(FilledButton, 'Elegir').last);
    await tester.pumpAndSettle();

    final flujo = tester
        .element(find.byType(Scaffold).last)
        .read<FlujoReservaController>();
    expect(flujo.ruta?.id, 'ruta_cempasuchil');
    expect(flujo.contacto?.nombre, 'Lucía Hernández');
    expect(find.text('Elige tu trajinera'), findsOneWidget);
  });

  testWidgets('Detalle de la Ruta 1: datos, itinerario y seguridad', (
    tester,
  ) async {
    await abrirRutas(tester, 360);

    await tester.tap(find.text('Sendero de las Ánimas').first);
    await tester.pumpAndSettle();

    expect(find.text('RUTA 1 · TRADICIONES Y LEYENDAS'), findsOneWidget);
    expect(find.text('Sendero de las Ánimas'), findsOneWidget);
    expect(find.text('2 h'), findsOneWidget);
    expect(find.text(r'$250 / persona'), findsOneWidget);
    expect(find.text('Hasta 20'), findsOneWidget);
    expect(find.text('Nuevo Nativitas'), findsOneWidget);
    expect(find.text('Ofrenda flotante'), findsOneWidget);
    expect(find.text('20 min'), findsOneWidget);
    expect(find.text('Desde'), findsOneWidget);
    expect(find.text(r'$250 MXN'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Recomendaciones de seguridad'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lleva abrigo: de noche baja a 10 °C.'), findsOneWidget);
    expect(find.text('Servicios adicionales'), findsNothing);

    await tester.tap(find.text('Elegir esta ruta'));
    await tester.pumpAndSettle();
    expect(find.text('Elige tu trajinera'), findsOneWidget);
  });

  testWidgets('Detalle de la Ruta 2 cierra con servicios y precios', (
    tester,
  ) async {
    await abrirRutas(tester, 360);

    await tester.tap(find.text('Fiesta de Cempasúchil').first);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Servicios adicionales'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Mariachi exclusivo'), findsOneWidget);
    expect(find.text(r'$1,500'), findsOneWidget);
    expect(find.text('Recomendaciones de seguridad'), findsNothing);
    expect(find.text(r'$200 MXN'), findsOneWidget);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Rutas disponibles'), findsOneWidget);
  });
}
