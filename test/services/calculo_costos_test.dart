import 'package:test/test.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/services/calculo_costos.dart';

import '../apoyo.dart';

void main() {
  test(r'ejemplo del diseño: $5,000 / $1,500 / $3,500', () {
    final c = Costos.calcular(
      tarifaTrajinera: 1200,
      precioPorPersona: 250,
      pasajeros: 12,
      servicios: [800],
    );
    expect(c.pasajes, 3000);
    expect(c.servicios, 800);
    expect(c.subtotal, 5000);
    expect(c.total, 5000);
    expect(c.anticipo, 1500);
    expect(c.resta, 3500);
  });

  test('sin servicios adicionales', () {
    final c = Costos.calcular(
      tarifaTrajinera: 950,
      precioPorPersona: 200,
      pasajeros: 6,
    );
    expect(c.subtotal, 2150);
    expect(c.anticipo, 645);
    expect(c.resta, 1505);
  });

  test('anticipo redondeado: los medios suben', () {
    expect(anticipoDe(0), 0);
    expect(anticipoDe(4), 1);
    expect(anticipoDe(5), 2);
    expect(anticipoDe(6), 2);
    expect(anticipoDe(1750), 525);
    expect(anticipoDe(2155), 647);
  });

  group('las 3 semillas del plan cuadran con la fórmula', () {
    final semilla = DatosMock.reservasSemilla(temporada2026);
    for (final (folio, subtotal, anticipo) in [
      ('DM-26-K7Q2', 5000, 1500),
      ('DM-26-A3F9', 2150, 645),
      ('DM-26-Z81M', 1750, 525),
    ]) {
      test(folio, () {
        final r = semilla.firstWhere((x) => x.folio == folio);
        final c = Costos.calcular(
          tarifaTrajinera: r.tarifaTrajinera,
          precioPorPersona: r.precioPorPersona,
          pasajeros: r.pasajeros,
          servicios: r.preciosServicios.values,
        );
        expect(c.subtotal, subtotal);
        expect(c.anticipo, anticipo);
        expect(r.subtotal, c.subtotal);
        expect(r.anticipo, c.anticipo);
        expect(r.resta, c.resta);
      });
    }

    test('y el resto de la semilla también', () {
      for (final r in semilla) {
        final c = Costos.calcular(
          tarifaTrajinera: r.tarifaTrajinera,
          precioPorPersona: r.precioPorPersona,
          pasajeros: r.pasajeros,
          servicios: r.preciosServicios.values,
        );
        expect((r.subtotal, r.anticipo), (c.subtotal, c.anticipo));
      }
    });

    test('deReservacion usa los precios aplicados al reservar', () {
      for (final r in semilla) {
        final c = Costos.deReservacion(r);
        expect(
          (c.tarifaTrajinera, c.precioPorPersona, c.pasajeros),
          (r.tarifaTrajinera, r.precioPorPersona, r.pasajeros),
        );
        expect((c.subtotal, c.anticipo), (r.subtotal, r.anticipo));
      }
    });
  });
}
