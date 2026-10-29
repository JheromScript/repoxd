import 'dart:convert';

import 'package:test/test.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/models/contenido.dart';
import 'package:trajineras/models/embarcadero.dart';
import 'package:trajineras/models/mapas.dart';
import 'package:trajineras/models/perfil.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/models/ruta.dart';
import 'package:trajineras/models/servicio_adicional.dart';
import 'package:trajineras/models/temporada.dart';
import 'package:trajineras/models/texto_local.dart';
import 'package:trajineras/models/trajinera.dart';

void ida<T>(T original, Mapa Function(T) aMapa, T Function(Mapa) desdeMapa) {
  final json = jsonDecode(jsonEncode(aMapa(original))) as Map<String, dynamic>;
  final copia = desdeMapa(Mapa.from(json));
  expect(aMapa(copia), equals(aMapa(original)));
}

void main() {
  test('TextoLocal', () {
    const t = TextoLocal('hola', 'hello');
    ida<TextoLocal>(t, (x) => x.toMap(), TextoLocal.fromMap);
    expect(t.resolver('en'), 'hello');
    expect(t.resolver('es'), 'hola');
    expect(t.copyWith(en: 'hi').en, 'hi');
  });

  test('Ruta y Parada', () {
    for (final r in DatosMock.rutas) {
      ida<Ruta>(r, (x) => x.toMap(), Ruta.fromMap);
    }
    ida<Parada>(
      DatosMock.rutas[0].paradas[0],
      (x) => x.toMap(),
      Parada.fromMap,
    );
    final ruta = DatosMock.rutas[0];
    expect(ruta.copyWith(duracionMin: 60).duracionMin, 60);
    expect(ruta.copyWith(duracionMin: 60).id, ruta.id);
  });

  test('Trajinera', () {
    for (final t in DatosMock.trajineras) {
      ida<Trajinera>(t, (x) => x.toMap(), Trajinera.fromMap);
    }
    final lucero = DatosMock.trajineras[3];
    expect(lucero.accesible, isTrue);
    expect(lucero.copyWith(activa: false).activa, isFalse);
  });

  test('ServicioAdicional', () {
    for (final s in DatosMock.servicios) {
      ida<ServicioAdicional>(s, (x) => x.toMap(), ServicioAdicional.fromMap);
    }
    expect(DatosMock.servicios[0].copyWith(precio: 1).precio, 1);
  });

  test('Embarcadero e Indicacion', () {
    for (final e in DatosMock.embarcaderos) {
      ida<Embarcadero>(e, (x) => x.toMap(), Embarcadero.fromMap);
    }
    final emb = DatosMock.embarcaderos[0];
    ida<Indicacion>(emb.indicaciones[0], (x) => x.toMap(), Indicacion.fromMap);
    expect(emb.copyWith(telefono: '1').telefono, '1');
  });

  test('Temporada', () {
    final t = Temporada.vigente(DateTime(2026, 10, 27));
    ida<Temporada>(t, (x) => x.toMap(), Temporada.fromMap);
    final copia = Temporada.fromMap(t.toMap());
    expect(copia.inicio, t.inicio);
    expect(copia.fechasSinServicio, t.fechasSinServicio);
    expect(t.copyWith(horaCierre: '22:00').horaCierre, '22:00');
  });

  test('Reservacion, Contacto y estados', () {
    final reservas = DatosMock.reservasSemilla(
      Temporada.vigente(DateTime(2026, 10, 27)),
    );
    expect(reservas, isNotEmpty);
    for (final r in reservas) {
      ida<Reservacion>(r, (x) => x.toMap(), Reservacion.fromMap);
    }
    final k7q2 = reservas.firstWhere((r) => r.folio == 'DM-26-K7Q2');
    ida<Contacto>(k7q2.contacto, (x) => x.toMap(), Contacto.fromMap);
    expect(k7q2.toMap()['estado'], 'pagada');
    expect(k7q2.toMap()['metodoPago'], 'tarjeta');
    expect(k7q2.inicio, DateTime(2026, 10, 31, 18));
    expect(k7q2.resta, 3500);
    final cancelada = k7q2.copyWith(
      estado: EstadoReservacion.cancelada,
      canceladaEn: DateTime(2026, 10, 28),
      montoReembolsado: 1500,
    );
    expect(cancelada.estado, EstadoReservacion.cancelada);
    expect(cancelada.folio, k7q2.folio);
    ida<Reservacion>(cancelada, (x) => x.toMap(), Reservacion.fromMap);
  });

  test('Perfil', () {
    ida<Perfil>(DatosMock.perfilDemo, (x) => x.toMap(), Perfil.fromMap);
    expect(DatosMock.perfilDemo.copyWith(idioma: 'en').idioma, 'en');
  });

  test('Contenido, Leyenda, PreguntaFrecuente y ReglaNavegacion', () {
    final c = DatosMock.contenido;
    ida<Contenido>(c, (x) => x.toMap(), Contenido.fromMap);
    ida<Leyenda>(c.leyendas[0], (x) => x.toMap(), Leyenda.fromMap);
    ida<PreguntaFrecuente>(
      c.preguntas[0],
      (x) => x.toMap(),
      PreguntaFrecuente.fromMap,
    );
    ida<ReglaNavegacion>(
      c.reglas[0],
      (x) => x.toMap(),
      ReglaNavegacion.fromMap,
    );
    expect(c.leyendas, hasLength(3));
    expect(c.reglas, hasLength(4));
    expect(c.preguntas, hasLength(5));
  });
}
