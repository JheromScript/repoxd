import 'package:test/test.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/services/disponibilidad.dart';

import '../apoyo.dart';

void main() {
  final semilla = DatosMock.reservasSemilla(temporada2026);
  final oct27 = DateTime(2026, 10, 27, 10);

  group('regla 1: choque por traslape', () {
    test('seTraslapan: tocar el borde no es choque', () {
      DateTime h(int hora, [int min = 0]) => DateTime(2026, 10, 31, hora, min);
      expect(seTraslapan(h(18), h(20), h(19, 30), h(21, 30)), isTrue);
      expect(seTraslapan(h(19, 30), h(21, 30), h(18), h(20)), isTrue);
      expect(seTraslapan(h(18), h(20), h(20), h(22)), isFalse);
      expect(seTraslapan(h(18), h(19, 30), h(19, 30), h(21, 30)), isFalse);
      expect(seTraslapan(h(18), h(22), h(19), h(20)), isTrue);
    });

    final r1830 = reservaDePrueba(
      folio: 'DM-26-AAAA',
      ruta: animas,
      trajinera: catrina,
      fecha: DateTime(2026, 10, 31),
      horario: '18:00',
    );
    final d = disponibilidadCon([r1830]);
    final oct31 = DateTime(2026, 10, 31);

    test('Ruta 1: 18:00 choca con 19:30 en la misma trajinera', () {
      expect(
        d.hayChoque(
          ruta: animas,
          trajineraId: catrina.id,
          fecha: oct31,
          horario: '19:30',
        ),
        isTrue,
      );
      expect(
        d.hayChoque(
          ruta: animas,
          trajineraId: catrina.id,
          fecha: oct31,
          horario: '18:00',
        ),
        isTrue,
      );
    });

    test('Ruta 1: 21:00 ya no choca (la de 18:00 termina a las 20:00)', () {
      expect(
        d.hayChoque(
          ruta: animas,
          trajineraId: catrina.id,
          fecha: oct31,
          horario: '21:00',
        ),
        isFalse,
      );
    });

    test('Ruta 1: 19:30 no choca con otra trajinera', () {
      expect(
        d.hayChoque(
          ruta: animas,
          trajineraId: flor.id,
          fecha: oct31,
          horario: '19:30',
        ),
        isFalse,
      );
    });

    test('ni con la misma trajinera otro día', () {
      expect(
        d.hayChoque(
          ruta: animas,
          trajineraId: catrina.id,
          fecha: DateTime(2026, 11, 1),
          horario: '19:30',
        ),
        isFalse,
      );
    });

    test('choque entre rutas distintas', () {
      final ruta2 = reservaDePrueba(
        folio: 'DM-26-BBBB',
        ruta: cempasuchil,
        trajinera: xochitl,
        fecha: DateTime(2026, 10, 30),
        horario: '18:00',
      );
      final d2 = disponibilidadCon([ruta2]);
      final oct30 = DateTime(2026, 10, 30);
      expect(
        d2.hayChoque(
          ruta: animas,
          trajineraId: xochitl.id,
          fecha: oct30,
          horario: '18:00',
        ),
        isTrue,
      );
      expect(
        d2.hayChoque(
          ruta: animas,
          trajineraId: xochitl.id,
          fecha: oct30,
          horario: '19:30',
        ),
        isFalse,
      );
      final d3 = disponibilidadCon([
        reservaDePrueba(
          folio: 'DM-26-CCCC',
          ruta: animas,
          trajinera: xochitl,
          fecha: oct30,
          horario: '18:00',
        ),
      ]);
      expect(
        d3
            .choques(
              ruta: cempasuchil,
              trajineraId: xochitl.id,
              fecha: oct30,
              horario: '18:00',
            )
            .single
            .folio,
        'DM-26-CCCC',
      );
      expect(
        d3.hayChoque(
          ruta: cempasuchil,
          trajineraId: xochitl.id,
          fecha: oct30,
          horario: '16:00',
        ),
        isFalse,
      );
    });

    test('las canceladas no ocupan lugar', () {
      final cancelada = reservaDePrueba(
        folio: 'DM-26-DDDD',
        ruta: animas,
        trajinera: catrina,
        fecha: oct31,
        horario: '18:00',
        estado: EstadoReservacion.cancelada,
      );
      expect(
        disponibilidadCon([cancelada]).hayChoque(
          ruta: animas,
          trajineraId: catrina.id,
          fecha: oct31,
          horario: '19:30',
        ),
        isFalse,
      );
    });

    test('modo cambio: la reservación no choca consigo misma', () {
      final d = disponibilidadCon(semilla);
      bool choca({String? excluir}) => d.hayChoque(
        ruta: animas,
        trajineraId: catrina.id,
        fecha: oct31,
        horario: '19:30',
        excluirFolio: excluir,
      );
      expect(choca(), isTrue);
      expect(choca(excluir: 'DM-26-K7Q2'), isFalse);
      expect(choca(excluir: 'DM-26-A3F9'), isTrue);
    });

    test('semilla: La Catrina el 1 nov solo deja libre las 18:00', () {
      final d = disponibilidadCon(semilla);
      expect(d.horariosLibres(animas, catrina, DateTime(2026, 11, 1)), [
        '18:00',
      ]);
    });
  });

  group('regla 2: capacidad', () {
    test('entre 1 y la capacidad de la trajinera', () {
      expect(cabenPasajeros(lucero, 8), isTrue);
      expect(cabenPasajeros(lucero, 9), isFalse);
      expect(cabenPasajeros(lucero, 0), isFalse);
      expect(cabenPasajeros(catrina, 20), isTrue);
    });

    test('paso 1: con 12 se deshabilitan Xóchitl, Lucero y la inactiva', () {
      final elegibles = [
        for (final t in DatosMock.trajineras)
          if (trajineraElegible(t, 12)) t.nombre,
      ];
      expect(elegibles, ['La Catrina', 'Flor de Cempasúchil']);
      expect(trajineraElegible(xochitl, 8), isTrue);
      expect(trajineraElegible(lucero, 8), isTrue);
      expect(trajineraElegible(chinampa, 1), isFalse);
    });
  });

  group('regla 3: fechas válidas', () {
    final d = disponibilidadCon([], ahora: oct27);

    test('29 oct (mantenimiento) bloqueado', () {
      expect(d.fechaValida(DateTime(2026, 10, 29)), isFalse);
      expect(d.diaSinServicio(DateTime(2026, 10, 29)), isTrue);
      expect(d.diaSinServicio(DateTime(2026, 10, 26)), isFalse);
    });

    test('lunes 2 nov habilitado', () {
      final lunes = DateTime(2026, 11, 2);
      expect(lunes.weekday, DateTime.monday);
      expect(d.fechaValida(lunes), isTrue);
    });

    test('fuera de temporada o pasadas, bloqueadas; hoy sí', () {
      expect(d.fechaValida(DateTime(2026, 10, 24)), isFalse);
      expect(d.fechaValida(DateTime(2026, 11, 4)), isFalse);
      expect(d.fechaValida(DateTime(2026, 10, 25)), isFalse);
      expect(d.fechaValida(DateTime(2026, 10, 26)), isFalse);
      expect(d.fechaValida(DateTime(2026, 10, 27)), isTrue);
      expect(d.fechaValida(DateTime(2026, 11, 3)), isTrue);
      expect(d.fechaValida(DateTime(2026, 11, 3, 23, 59)), isTrue);
    });

    test('fechasValidas: 27 oct – 3 nov sin el 29', () {
      expect(d.fechasValidas().map(fechaIso), [
        '2026-10-27',
        '2026-10-28',
        '2026-10-30',
        '2026-10-31',
        '2026-11-01',
        '2026-11-02',
        '2026-11-03',
      ]);
    });
  });

  group('regla 4: horarios válidos', () {
    final hoy = DateTime(2026, 10, 30);

    test('mismo día: solo con 1 h o más de anticipación', () {
      final a1700 = disponibilidadCon([], ahora: DateTime(2026, 10, 30, 17));
      expect(a1700.horariosValidos(animas, hoy), ['18:00', '19:30', '21:00']);
      final a1701 = disponibilidadCon([], ahora: DateTime(2026, 10, 30, 17, 1));
      expect(a1701.horariosValidos(animas, hoy), ['19:30', '21:00']);
      expect(a1701.horariosValidos(cempasuchil, hoy), isEmpty);
      expect(
        a1701.horariosValidos(animas, DateTime(2026, 10, 31)),
        animas.horarios,
      );
    });

    test('el recorrido termina antes del cierre (23:00)', () {
      final d = disponibilidadCon([]);
      expect(d.horarioValido(animas, hoy, '21:00'), isTrue);
      final larga = animas.copyWith(duracionMin: 150);
      expect(d.horarioValido(larga, hoy, '21:00'), isFalse);
      expect(d.horarioValido(larga, hoy, '19:30'), isTrue);
    });

    test('solo los horarios de la ruta y en fechas válidas', () {
      final d = disponibilidadCon([]);
      expect(d.horarioValido(animas, hoy, '12:00'), isFalse);
      expect(d.horarioValido(animas, DateTime(2026, 10, 29), '18:00'), isFalse);
    });
  });

  group('regla 5: etiqueta de la trajinera', () {
    final d = disponibilidadCon(semilla);

    test('semilla: Flor de Cempasúchil en la Ruta 2 → Pocos lugares', () {
      expect(d.etiqueta(flor, cempasuchil), EtiquetaTrajinera.pocosLugares);
    });

    test('La Catrina → Disponible; Chinampa Real → Sin servicio', () {
      expect(d.etiqueta(catrina, animas), EtiquetaTrajinera.disponible);
      expect(d.etiqueta(chinampa, animas), EtiquetaTrajinera.sinServicio);
    });

    test('el umbral es 70 %', () {
      final salidas = [
        for (final dia in [25, 26, 27, 28, 30, 31])
          for (final h in animas.horarios) (DateTime(2026, 10, dia), h),
        for (final dia in [1, 2, 3])
          for (final h in animas.horarios) (DateTime(2026, 11, dia), h),
      ];
      expect(salidas, hasLength(27));
      List<Reservacion> primeras(int n) => [
        for (var i = 0; i < n; i++)
          reservaDePrueba(
            folio: 'DM-26-L${i.toString().padLeft(3, '0')}',
            ruta: animas,
            trajinera: lucero,
            fecha: salidas[i].$1,
            horario: salidas[i].$2,
          ),
      ];
      int ocupadas(List<Reservacion> rs) {
        final dd = disponibilidadCon(rs);
        return salidas
            .where(
              (s) => dd.hayChoque(
                ruta: animas,
                trajineraId: lucero.id,
                fecha: s.$1,
                horario: s.$2,
              ),
            )
            .length;
      }

      final seisDias = primeras(18);
      expect(ocupadas(seisDias), 18);
      expect(
        disponibilidadCon(seisDias).etiqueta(lucero, animas),
        EtiquetaTrajinera.disponible,
      );
      final masUna = primeras(19);
      expect(ocupadas(masUna), 20);
      expect(
        disponibilidadCon(masUna).etiqueta(lucero, animas),
        EtiquetaTrajinera.pocosLugares,
      );
    });
  });

  group('regla 6: alternativas', () {
    final d = disponibilidadCon(semilla);
    final nov1 = DateTime(2026, 11, 1);

    test('La Catrina 1 nov 19:30 ocupado → hasta 3, una de cada tipo', () {
      final alt = d.alternativas(
        ruta: animas,
        trajinera: catrina,
        fecha: nov1,
        horario: '19:30',
        pasajeros: 12,
        trajineras: DatosMock.trajineras,
      );
      expect(alt.map((a) => a.tipo), TipoAlternativa.values);
      expect(alt[0].horario, '18:00');
      expect(alt[0].trajinera.id, catrina.id);
      expect(alt[1].horario, '19:30');
      expect(alt[1].trajinera.id, flor.id);
      expect(alt[2].trajinera.id, catrina.id);
      expect(alt[2].fecha, DateTime(2026, 11, 2));
      expect(alt[2].horario, '19:30');
      expect(alt.length, lessThanOrEqualTo(maxAlternativas));
    });

    test('sin otra trajinera con capacidad suficiente', () {
      final alt = d.alternativas(
        ruta: animas,
        trajinera: catrina,
        fecha: nov1,
        horario: '21:00',
        pasajeros: 15,
        trajineras: DatosMock.trajineras,
      );
      expect(alt.map((a) => a.tipo), [
        TipoAlternativa.otraHora,
        TipoAlternativa.otroDia,
      ]);
      expect(alt[0].horario, '18:00');
    });

    test('si el horario está libre no hay alternativas', () {
      expect(
        d.alternativas(
          ruta: animas,
          trajinera: catrina,
          fecha: nov1,
          horario: '18:00',
          pasajeros: 12,
          trajineras: DatosMock.trajineras,
        ),
        isEmpty,
      );
    });

    test('día sin ningún horario libre', () {
      final oct30 = DateTime(2026, 10, 30);
      final lleno = disponibilidadCon([
        ...semilla,
        for (final (f, h) in [('DM-26-EEEE', '18:00'), ('DM-26-FFFF', '21:00')])
          reservaDePrueba(
            folio: f,
            ruta: animas,
            trajinera: catrina,
            fecha: oct30,
            horario: h,
          ),
      ]);
      expect(lleno.horariosLibres(animas, catrina, oct30), isEmpty);
      final alt = lleno.alternativas(
        ruta: animas,
        trajinera: catrina,
        fecha: oct30,
        pasajeros: 12,
        trajineras: DatosMock.trajineras,
      );
      expect(alt.map((a) => a.tipo), [
        TipoAlternativa.otraTrajinera,
        TipoAlternativa.otroDia,
      ]);
      expect(alt[0].trajinera.id, flor.id);
      expect(alt[1].fecha, DateTime(2026, 10, 31));
      expect(alt[1].horario, '21:00');
    });

    test('modo cambio: misma trajinera y sin contarse a sí misma', () {
      final oct31 = DateTime(2026, 10, 31);
      expect(
        d.alternativas(
          ruta: animas,
          trajinera: catrina,
          fecha: oct31,
          horario: '19:30',
          pasajeros: 12,
          trajineras: const [],
          excluirFolio: 'DM-26-K7Q2',
        ),
        isEmpty,
      );
      final alt = d.alternativas(
        ruta: animas,
        trajinera: catrina,
        fecha: nov1,
        horario: '21:00',
        pasajeros: 12,
        trajineras: const [],
        excluirFolio: 'DM-26-K7Q2',
      );
      expect(alt.every((a) => a.trajinera.id == catrina.id), isTrue);
      expect(alt.map((a) => a.tipo), [
        TipoAlternativa.otraHora,
        TipoAlternativa.otroDia,
      ]);
    });
  });
}
