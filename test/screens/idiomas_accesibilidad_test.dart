import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/app.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/l10n/app_localizations_en.dart';
import 'package:trajineras/l10n/app_localizations_es.dart';
import 'package:trajineras/models/texto_local.dart';
import 'package:trajineras/widgets/imagen_tematica.dart';
import 'package:trajineras/widgets/visor_imagenes.dart';

import '../apoyo.dart';
import '../apoyo_app.dart';

void main() {
  test('los dos ARB tienen las mismas claves y ningún texto vacío', () {
    Map<String, dynamic> leer(String idioma) =>
        jsonDecode(File('lib/l10n/app_$idioma.arb').readAsStringSync())
            as Map<String, dynamic>;
    List<String> claves(Map<String, dynamic> m) =>
        m.keys.where((k) => !k.startsWith('@')).toList()..sort();

    final es = leer('es');
    final en = leer('en');
    expect(claves(en), claves(es));
    for (final k in claves(es)) {
      expect((es[k] as String).trim(), isNotEmpty, reason: 'es.$k');
      expect((en[k] as String).trim(), isNotEmpty, reason: 'en.$k');
    }
  });

  test('el contenido de datos_mock está traducido', () {
    final textos = <TextoLocal>[
      for (final s in DatosMock.servicios) ...[s.nombre, s.descripcion],
      for (final e in DatosMock.embarcaderos) ...[
        e.horario,
        e.distancia,
        e.muelle,
        for (final i in e.indicaciones) ...[i.titulo, i.detalle],
      ],
      for (final r in DatosMock.rutas) ...[
        r.nombre,
        r.etiqueta,
        r.ambiente,
        r.descripcion,
        ...r.recomendaciones,
        for (final p in r.paradas) ...[p.nombre, p.descripcion],
      ],
      for (final t in DatosMock.trajineras) ...t.incluye,
      DatosMock.contenido.historia,
      DatosMock.contenido.avisoPrivacidad,
      DatosMock.contenido.horarioAtencion,
      for (final l in DatosMock.contenido.leyendas) ...[l.titulo, l.texto],
      for (final r in DatosMock.contenido.reglas) ...[r.titulo, r.detalle],
      for (final p in DatosMock.contenido.preguntas) ...[
        p.pregunta,
        p.respuesta,
      ],
    ];
    const iguales = {'La Llorona'};
    for (final t in textos) {
      if (iguales.contains(t.es)) continue;
      expect(t.en, isNot(t.es), reason: 'Falta traducir "${t.es}"');
    }
  });

  testWidgets('Bienvenida: el idioma cambia al momento', (tester) async {
    final env = EntornoDePrueba();
    await env.montar(tester);
    expect(find.text('Comenzar'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Comenzar'), findsNothing);

    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();
    expect(find.text('Comenzar'), findsOneWidget);
  });

  testWidgets('fechas y textos de Mis reservaciones según el idioma', (
    tester,
  ) async {
    final env = EntornoDePrueba();
    await env.montar(tester);
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mis reservas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sáb 31 oct'), findsWidgets);
    expect(find.text('Próximas'), findsOneWidget);

    env.preferencias.cambiarIdioma('en');
    await tester.pumpAndSettle();
    expect(find.textContaining('Sat Oct 31'), findsWidgets);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Trail of the Souls'), findsWidgets);
    expect(find.text('My bookings'), findsWidgets);
  });

  testWidgets('Tradiciones: la galería abre el visor de imágenes', (
    tester,
  ) async {
    final env = EntornoDePrueba();
    await env.montar(tester, alto: 1600);
    await env.abrir(tester, RutasApp.tradiciones);
    final foto = find.byType(ImagenTematica).at(2);
    await tester.ensureVisible(foto);
    await tester.pumpAndSettle();
    await tester.tap(foto);
    await tester.pumpAndSettle();
    expect(find.byType(VisorImagenes), findsOneWidget);
    expect(find.text('Foto 2 de 4'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Foto 3 de 4'), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.byType(VisorImagenes), findsNothing);
  });

  for (final ancho in [360.0, 768.0]) {
    for (final idioma in ['es', 'en']) {
      testWidgets('sin desbordes al 130 % · $idioma · ${ancho.toInt()} dp', (
        tester,
      ) async {
        final env = EntornoDePrueba();
        env.preferencias.cambiarIdioma(idioma);
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        tester.view.physicalSize = Size(ancho, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(env.app());
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        Future<void> mira(String que) async {
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: que);
        }

        await mira('Bienvenida');
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
        await mira('Inicio');

        final l = idioma == 'es' ? AppLocalizationsEs() : AppLocalizationsEn();
        for (final pestana in [l.navRutas, l.navReservas, l.navPerfil]) {
          await tester.tap(find.text(pestana).last);
          await mira(pestana);
        }

        final ruta = DatosMock.rutas.first;
        env.flujo.iniciar(ruta, contacto: contactoLucia);
        for (final nombre in [
          RutasApp.tradiciones,
          RutasApp.comoLlegar,
          RutasApp.seguridad,
          RutasApp.reservar,
        ]) {
          await env.abrir(tester, nombre);
          await mira(nombre);
          tester.state<NavigatorState>(find.byType(Navigator).first).pop();
          await tester.pumpAndSettle();
        }
        tester
            .state<NavigatorState>(find.byType(Navigator).first)
            .pushNamed(RutasApp.detalleRuta, arguments: ruta);
        await mira('Detalle de ruta');
        tester.state<NavigatorState>(find.byType(Navigator).first).pop();

        env.flujo
          ..elegirTrajinera(catrina)
          ..elegirFecha(DateTime(2026, 11, 1))
          ..elegirHorario('18:00')
          ..aceptarAviso(true);
        for (final nombre in [
          RutasApp.fechaHorario,
          RutasApp.datos,
          RutasApp.resumen,
        ]) {
          await env.abrir(tester, nombre);
          await mira(nombre);
        }
      });
    }
  }
}
