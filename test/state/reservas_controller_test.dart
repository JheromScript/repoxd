import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/data/catalogo_repository_mock.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/data/reserva_repository_memoria.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/services/folio.dart';
import 'package:trajineras/services/politica_cancelacion.dart';
import 'package:trajineras/state/flujo_reserva_controller.dart';
import 'package:trajineras/state/preferencias_controller.dart';
import 'package:trajineras/state/reservas_controller.dart';

import '../apoyo.dart';

void main() {
  late ReservaRepositoryMemoria repo;

  void repoNuevo() {
    repo = ReservaRepositoryMemoria(
      iniciales: DatosMock.reservasSemilla(temporada2026),
      retardo: Duration.zero,
    );
  }

  setUp(repoNuevo);

  ReservasController controlador(
    DateTime ahora, {
    PreferenciasController? preferencias,
  }) {
    final reloj = RelojFijo(ahora);
    return ReservasController(
      reloj: reloj,
      reservas: repo,
      catalogo: CatalogoRepositoryMock(reloj: reloj, retardo: Duration.zero),
      preferencias: preferencias,
    );
  }

  SolicitudReserva solicitud({
    String horario = '21:00',
    DateTime? fecha,
    int pasajeros = 12,
  }) => SolicitudReserva(
    ruta: animas,
    trajinera: catrina,
    fecha: fecha ?? DateTime(2026, 10, 31),
    horario: horario,
    pasajeros: pasajeros,
    contacto: contactoLucia,
    servicios: [DatosMock.servicios[2]],
    metodoPago: MetodoPago.tarjeta,
  );

  Matcher rechazo(MotivoRechazo motivo) => throwsA(
    isA<ReservaException>().having((e) => e.motivo, 'motivo', motivo),
  );

  final oct27 = DateTime(2026, 10, 27, 10);

  group('listas del usuario u1', () {
    test('Próximas, Pasadas y Canceladas, sin reservas de otros', () async {
      final c = controlador(oct27);
      await c.cargar();
      expect(c.proximas.map((r) => r.folio), ['DM-26-K7Q2', 'DM-26-A3F9']);
      expect(c.pasadas.map((r) => r.folio), ['DM-25-P5T8']);
      expect(c.canceladas.map((r) => r.folio), ['DM-26-Z81M']);
      expect(c.proxima?.folio, 'DM-26-K7Q2');
      expect(c.todas.every((r) => r.usuarioId == 'u1'), isTrue);
    });

    test('una reservación que ya salió pasa a Pasadas', () async {
      final c = controlador(DateTime(2026, 10, 31, 18));
      await c.cargar();
      expect(c.proximas.map((r) => r.folio), ['DM-26-A3F9']);
      expect(c.pasadas.map((r) => r.folio), ['DM-26-K7Q2', 'DM-25-P5T8']);
    });
  });

  group('confirmar', () {
    test('guarda como pendiente, con folio y montos', () async {
      final prefs = PreferenciasController(
        reloj: RelojFijo(oct27),
        perfil: DatosMock.perfilDemo,
      );
      final c = controlador(oct27, preferencias: prefs);
      await c.cargar();
      final r = await c.confirmar(solicitud());
      expect(r.folio, matches(formatoFolio));
      expect(r.folio, startsWith('DM-26-'));
      expect(r.estado, EstadoReservacion.pendiente);
      expect(r.usuarioId, 'u1');
      expect((r.subtotal, r.anticipo, r.resta), (5000, 1500, 3500));
      expect(r.fecha, '2026-10-31');
      expect(r.creadaEn, oct27);
      expect(await repo.buscar(r.folio), isNotNull);
      expect(c.proximas.map((x) => x.folio), contains(r.folio));
      expect(prefs.avisos.single.tipo, TipoAviso.reservaCreada);
    });

    test('confirmar dos veces el mismo horario falla', () async {
      final c = controlador(oct27);
      await c.confirmar(solicitud());
      await expectLater(
        c.confirmar(solicitud()),
        rechazo(MotivoRechazo.ocupado),
      );
      final otraFecha = DateTime(2026, 11, 2);
      await c.confirmar(solicitud(fecha: otraFecha, horario: '21:00'));
      await expectLater(
        c.confirmar(solicitud(fecha: otraFecha, horario: '19:30')),
        rechazo(MotivoRechazo.ocupado),
      );
    });

    test('doble toque simultáneo: solo una se guarda', () async {
      final c = controlador(oct27);
      final resultados = await Future.wait([
        c.confirmar(solicitud()).then<Object>((r) => r),
        c.confirmar(solicitud()).then<Object>((r) => r, onError: (e) => e),
      ]);
      expect(resultados[0], isA<Reservacion>());
      expect(resultados[1], isA<ReservaException>());
      final dia = await repo.listarEntre(
        DateTime(2026, 10, 31),
        DateTime(2026, 10, 31),
      );
      expect(
        dia.where((r) => r.trajineraId == catrina.id && r.horario == '21:00'),
        hasLength(1),
      );
    });

    test('revalida contra reservas de otros usuarios', () async {
      final c = controlador(oct27);
      await expectLater(
        c.confirmar(solicitud(fecha: DateTime(2026, 11, 1), horario: '19:30')),
        rechazo(MotivoRechazo.ocupado),
      );
    });

    test('rechaza fecha inválida, pasada o con menos de 1 h', () async {
      await expectLater(
        controlador(oct27).confirmar(solicitud(fecha: DateTime(2026, 10, 29))),
        rechazo(MotivoRechazo.fechaInvalida),
      );
      final c = controlador(DateTime(2026, 10, 31, 17, 30));
      await expectLater(
        c.confirmar(solicitud(horario: '18:00')),
        rechazo(MotivoRechazo.fechaInvalida),
      );
    });

    test('rechaza capacidad insuficiente', () async {
      await expectLater(
        controlador(oct27).confirmar(solicitud(pasajeros: 21)),
        rechazo(MotivoRechazo.capacidad),
      );
    });
  });

  test('pagar: pendiente → pagada; dos veces no', () async {
    final c = controlador(oct27);
    await c.cargar();
    final r = await c.pagar('DM-26-A3F9');
    expect(r.estado, EstadoReservacion.pagada);
    expect(r.pagadaEn, oct27);
    expect(
      c.proximas.firstWhere((x) => x.folio == 'DM-26-A3F9').estado,
      EstadoReservacion.pagada,
    );
    await expectLater(
      c.pagar('DM-26-A3F9'),
      rechazo(MotivoRechazo.noPermitido),
    );
    await expectLater(
      c.pagar('DM-26-R4NB'),
      rechazo(MotivoRechazo.noEncontrada),
    );
  });

  group('cancelar: las 3 variantes alrededor de las 24 h', () {
    final antesK7Q2 = DateTime(2026, 10, 30, 17, 59);
    final despuesK7Q2 = DateTime(2026, 10, 30, 18);

    test('pagada con más de 24 h → reembolso del anticipo', () async {
      final c = controlador(antesK7Q2);
      expect(
        c.varianteDe((await repo.buscar('DM-26-K7Q2'))!),
        VarianteCancelacion.conReembolso,
      );
      final r = await c.cancelar('DM-26-K7Q2');
      expect(r.estado, EstadoReservacion.cancelada);
      expect(r.montoReembolsado, 1500);
      expect(r.canceladaEn, antesK7Q2);
    });

    test('pagada con 24 h o menos → sin reembolso', () async {
      final c = controlador(despuesK7Q2);
      final r = await c.cancelar('DM-26-K7Q2');
      expect(r.estado, EstadoReservacion.cancelada);
      expect(r.montoReembolsado, 0);
    });

    test('pendiente → sin cargo, antes y después del límite', () async {
      for (final ahora in [
        DateTime(2026, 10, 31, 13, 59),
        DateTime(2026, 10, 31, 14, 1),
      ]) {
        repoNuevo();
        final c = controlador(ahora);
        final antes = (await repo.buscar('DM-26-A3F9'))!;
        expect(c.varianteDe(antes), VarianteCancelacion.sinCargo);
        final r = await c.cancelar('DM-26-A3F9');
        expect(r.montoReembolsado, 0);
        expect(r.estado, EstadoReservacion.cancelada);
      }
    });

    test('ya cancelada o ya salió: no se puede', () async {
      final c = controlador(oct27);
      await expectLater(
        c.cancelar('DM-26-Z81M'),
        rechazo(MotivoRechazo.noPermitido),
      );
      await expectLater(
        controlador(DateTime(2026, 10, 31, 18)).cancelar('DM-26-K7Q2'),
        rechazo(MotivoRechazo.noPermitido),
      );
    });

    test('la cancelada pasa a la lista Canceladas', () async {
      final c = controlador(antesK7Q2);
      await c.cargar();
      await c.cancelar('DM-26-K7Q2');
      expect(c.proximas.map((r) => r.folio), isNot(contains('DM-26-K7Q2')));
      expect(c.canceladas.map((r) => r.folio), contains('DM-26-K7Q2'));
    });
  });

  group('cambiar fecha y horario', () {
    test('mismo folio; se excluye a sí misma del choque', () async {
      final c = controlador(oct27);
      await c.cargar();
      final r = await c.cambiar(
        'DM-26-K7Q2',
        fecha: DateTime(2026, 10, 31),
        horario: '19:30',
      );
      expect(r.folio, 'DM-26-K7Q2');
      expect((r.fecha, r.horario), ('2026-10-31', '19:30'));
      expect((r.trajineraId, r.pasajeros, r.subtotal), (catrina.id, 12, 5000));
      expect(r.estado, EstadoReservacion.pagada);
      expect((await repo.buscar('DM-26-K7Q2'))!.horario, '19:30');
      expect(c.proxima!.horario, '19:30');
    });

    test('no a un horario ocupado por otra reservación', () async {
      await expectLater(
        controlador(
          oct27,
        ).cambiar('DM-26-K7Q2', fecha: DateTime(2026, 11, 1), horario: '19:30'),
        rechazo(MotivoRechazo.ocupado),
      );
    });

    test('no con 24 h o menos, ni cancelada, ni a fecha inválida', () async {
      await expectLater(
        controlador(
          DateTime(2026, 10, 30, 18),
        ).cambiar('DM-26-K7Q2', fecha: DateTime(2026, 11, 2), horario: '18:00'),
        rechazo(MotivoRechazo.noPermitido),
      );
      await expectLater(
        controlador(
          oct27,
        ).cambiar('DM-26-Z81M', fecha: DateTime(2026, 11, 2), horario: '18:00'),
        rechazo(MotivoRechazo.noPermitido),
      );
      await expectLater(
        controlador(oct27).cambiar(
          'DM-26-K7Q2',
          fecha: DateTime(2026, 10, 29),
          horario: '18:00',
        ),
        rechazo(MotivoRechazo.fechaInvalida),
      );
    });
  });

  test('disponibilidad() refleja lo recién confirmado', () async {
    final c = controlador(oct27);
    final antes = await c.disponibilidad();
    expect(antes.horariosLibres(animas, catrina, DateTime(2026, 11, 2)), [
      '18:00',
      '19:30',
      '21:00',
    ]);
    await c.confirmar(
      solicitud(fecha: DateTime(2026, 11, 2), horario: '18:00'),
    );
    final despues = await c.disponibilidad();
    expect(despues.horariosLibres(animas, catrina, DateTime(2026, 11, 2)), [
      '21:00',
    ]);
  });

  test('pasada la temporada, el folio lleva el año de la siguiente', () async {
    final c = controlador(DateTime(2026, 11, 5));
    final r = await c.confirmar(solicitud(fecha: DateTime(2027, 10, 30)));
    expect(r.folio, startsWith('DM-27-'));
    await expectLater(
      c.confirmar(solicitud(fecha: DateTime(2026, 11, 3))),
      rechazo(MotivoRechazo.fechaInvalida),
    );
  });
}
