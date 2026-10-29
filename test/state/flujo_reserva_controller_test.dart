import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/data/catalogo_repository_mock.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/services/disponibilidad.dart';
import 'package:trajineras/services/validadores.dart';
import 'package:trajineras/state/flujo_reserva_controller.dart';

import '../apoyo.dart';

void main() {
  late FlujoReservaController flujo;
  late int avisos;
  final fotografo = DatosMock.servicios[2];
  final mariachi = DatosMock.servicios[0];

  setUp(() async {
    final reloj = RelojFijo(DateTime(2026, 10, 27, 10));
    flujo = FlujoReservaController(
      reloj: reloj,
      catalogo: CatalogoRepositoryMock(reloj: reloj, retardo: Duration.zero),
    );
    await flujo.cargar();
    avisos = 0;
    flujo.addListener(() => avisos++);
  });

  test('iniciar(ruta) arranca un borrador limpio', () {
    flujo.iniciar(animas, contacto: contactoLucia);
    expect(flujo.ruta, animas);
    expect(flujo.pasajeros, 1);
    expect(flujo.trajinera, isNull);
    expect(flujo.contacto, contactoLucia);
    expect(flujo.costos, isNull);
    expect(avisos, 1);
  });

  test(r'totales: La Catrina, 12 pasajeros y fotógrafo = $5,000', () {
    flujo
      ..iniciar(animas)
      ..cambiarPasajeros(12)
      ..elegirTrajinera(catrina)
      ..marcarServicio(fotografo, true);
    final c = flujo.costos!;
    expect((c.subtotal, c.anticipo, c.resta), (5000, 1500, 3500));

    flujo.marcarServicio(mariachi, true);
    expect(flujo.costos!.subtotal, 6500);
    flujo.marcarServicio(fotografo, false);
    flujo.cambiarPasajeros(10);
    expect(flujo.costos!.subtotal, 1200 + 2500 + 1500);
  });

  test('pasajeros entre 1 y 20; si la trajinera no alcanza, se suelta', () {
    flujo
      ..iniciar(animas)
      ..cambiarPasajeros(0);
    expect(flujo.pasajeros, 1);
    flujo.cambiarPasajeros(99);
    expect(flujo.pasajeros, maxPasajeros);

    flujo
      ..cambiarPasajeros(8)
      ..elegirTrajinera(flor)
      ..marcarServicio(fotografo, true)
      ..elegirFecha(DateTime(2026, 10, 31))
      ..elegirHorario('19:30');
    flujo.cambiarPasajeros(14);
    expect(flujo.trajinera, flor);
    flujo.cambiarPasajeros(15);
    expect(flujo.trajinera, isNull);
    expect(flujo.horario, isNull);
    expect(flujo.servicios, isEmpty);
    expect(flujo.fecha, DateTime(2026, 10, 31));
  });

  test('no se elige una trajinera sin servicio o sin capacidad', () {
    flujo
      ..iniciar(animas)
      ..cambiarPasajeros(12);
    expect(() => flujo.elegirTrajinera(xochitl), throwsArgumentError);
    expect(() => flujo.elegirTrajinera(chinampa), throwsArgumentError);
    expect(flujo.trajinera, isNull);
  });

  test('servicios: solo los que ofrece la trajinera', () {
    flujo
      ..iniciar(animas)
      ..elegirTrajinera(flor);
    expect(() => flujo.marcarServicio(mariachi, true), throwsArgumentError);
    flujo
      ..elegirTrajinera(catrina)
      ..marcarServicio(mariachi, true)
      ..marcarServicio(fotografo, true)
      ..elegirTrajinera(flor);
    expect(flujo.servicios.map((s) => s.id), [fotografo.id]);
  });

  test(
    'fechas: 29 oct bloqueado, lunes 2 nov sí; cambiar fecha borra hora',
    () {
      flujo.iniciar(animas);
      expect(
        () => flujo.elegirFecha(DateTime(2026, 10, 29)),
        throwsArgumentError,
      );
      expect(
        () => flujo.elegirFecha(DateTime(2026, 10, 26)),
        throwsArgumentError,
      );
      flujo
        ..elegirFecha(DateTime(2026, 11, 2, 15))
        ..elegirHorario('21:00');
      expect(flujo.fecha, DateTime(2026, 11, 2));
      flujo.elegirFecha(DateTime(2026, 11, 2));
      expect(flujo.horario, '21:00');
      flujo.elegirFecha(DateTime(2026, 11, 3));
      expect(flujo.horario, isNull);
      expect(() => flujo.elegirHorario('12:00'), throwsArgumentError);
    },
  );

  test('elegirAlternativa cambia trajinera, fecha y hora juntas', () {
    flujo
      ..iniciar(animas)
      ..cambiarPasajeros(12)
      ..elegirTrajinera(catrina)
      ..elegirFecha(DateTime(2026, 11, 1));
    flujo.elegirAlternativa(
      Alternativa(
        tipo: TipoAlternativa.otraTrajinera,
        trajinera: flor,
        fecha: DateTime(2026, 11, 1),
        horario: '19:30',
      ),
    );
    expect(
      (flujo.trajinera, flujo.fecha, flujo.horario),
      (flor, DateTime(2026, 11, 1), '19:30'),
    );
  });

  test('solicitud: null hasta que todo es válido; reiniciar limpia', () {
    flujo
      ..iniciar(animas)
      ..cambiarPasajeros(12)
      ..elegirTrajinera(catrina)
      ..elegirFecha(DateTime(2026, 10, 31))
      ..elegirHorario('21:00')
      ..actualizarContacto(contactoLucia.copyWith(telefono: '55 1234'));
    expect(flujo.solicitud, isNull);
    flujo.actualizarContacto(contactoLucia);
    expect(flujo.datosValidos, isFalse);
    expect(flujo.solicitud, isNull);
    flujo
      ..aceptarAviso(true)
      ..elegirMetodoPago(MetodoPago.spei);
    final s = flujo.solicitud!;
    expect(s.trajinera, catrina);
    expect(s.horario, '21:00');
    expect(s.metodoPago, MetodoPago.spei);
    expect(s.costos.subtotal, 4200);

    flujo.reiniciar();
    expect(flujo.ruta, isNull);
    expect(flujo.solicitud, isNull);
    expect(flujo.avisoAceptado, isFalse);
    expect(flujo.metodoPago, MetodoPago.tarjeta);
  });

  group('revisar: suelta lo que la ocupación ya no permite', () {
    void elegirCatrina(DateTime fecha, String horario) => flujo
      ..iniciar(animas)
      ..cambiarPasajeros(12)
      ..elegirTrajinera(catrina)
      ..elegirFecha(fecha)
      ..elegirHorario(horario);

    test('otra persona ganó el horario: se suelta solo la hora', () {
      elegirCatrina(DateTime(2026, 11, 1), '18:00');
      final antes = avisos;
      final otra = reservaDePrueba(
        folio: 'DM-26-OTRA',
        ruta: animas,
        trajinera: catrina,
        fecha: DateTime(2026, 11, 1),
        horario: '18:00',
        usuarioId: 'u2',
      );
      expect(flujo.revisar(disponibilidadCon([otra])), '18:00');
      expect(flujo.horario, isNull);
      expect(flujo.fecha, DateTime(2026, 11, 1));
      expect(flujo.trajinera, catrina);
      expect(avisos, antes + 1);
    });

    test('si sigue libre no cambia nada ni avisa', () {
      elegirCatrina(DateTime(2026, 11, 1), '18:00');
      final antes = avisos;
      expect(flujo.revisar(disponibilidadCon([])), isNull);
      expect(flujo.horario, '18:00');
      expect(avisos, antes);
    });

    test('ya falta menos de 1 h: se suelta la hora', () {
      elegirCatrina(DateTime(2026, 10, 27), '18:00');
      final tarde = disponibilidadCon([], ahora: DateTime(2026, 10, 27, 17, 1));
      expect(flujo.revisar(tarde), '18:00');
      expect(flujo.fecha, DateTime(2026, 10, 27));
    });

    test('la fecha ya pasó: se sueltan fecha y hora', () {
      elegirCatrina(DateTime(2026, 10, 27), '21:00');
      final manana = disponibilidadCon([], ahora: DateTime(2026, 10, 28, 9));
      expect(flujo.revisar(manana), '21:00');
      expect((flujo.fecha, flujo.horario), (null, null));
    });

    test('quitarHorario deja la fecha', () {
      elegirCatrina(DateTime(2026, 11, 1), '18:00');
      flujo.quitarHorario();
      expect((flujo.fecha, flujo.horario), (DateTime(2026, 11, 1), null));
    });
  });

  test('elegirFecha antes de cargar() es un error de uso', () {
    final reloj = RelojFijo(DateTime(2026, 10, 27));
    final sinCargar = FlujoReservaController(
      reloj: reloj,
      catalogo: CatalogoRepositoryMock(reloj: reloj),
    )..iniciar(animas);
    expect(
      () => sinCargar.elegirFecha(DateTime(2026, 10, 30)),
      throwsStateError,
    );
  });
}
