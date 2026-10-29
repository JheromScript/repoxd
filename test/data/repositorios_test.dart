import 'package:test/test.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/data/catalogo_repository_mock.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/data/reserva_repository_memoria.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/models/temporada.dart';

void main() {
  final temporada = Temporada.vigente(DateTime(2026, 10, 27));
  final semilla = DatosMock.reservasSemilla(temporada);

  test('la semilla cumple los montos del diseño', () {
    Reservacion por(String folio) =>
        semilla.firstWhere((r) => r.folio == folio);
    expect(por('DM-26-K7Q2').subtotal, 5000);
    expect(por('DM-26-K7Q2').anticipo, 1500);
    expect(por('DM-26-A3F9').subtotal, 2150);
    expect(por('DM-26-A3F9').anticipo, 645);
    expect(por('DM-26-A3F9').estado, EstadoReservacion.pendiente);
    expect(por('DM-26-Z81M').subtotal, 1750);
    expect(por('DM-26-Z81M').anticipo, 525);
    expect(por('DM-26-Z81M').montoReembolsado, 525);
    expect(semilla.map((r) => r.folio).toSet(), hasLength(semilla.length));
  });

  test('Flor de Cempasúchil tiene ~75 % de ocupación en la Ruta 2', () {
    final flor = semilla.where(
      (r) =>
          r.trajineraId == 'traj_flor' &&
          r.estado != EstadoReservacion.cancelada,
    );
    expect(flor.length / 36, closeTo(0.75, 0.05));
  });

  test('hay una sola reservación de la temporada anterior', () {
    final pasadas = semilla.where((r) => r.inicio.isBefore(temporada.inicio));
    expect(pasadas, hasLength(1));
  });

  test(
    'ReservaRepositoryMemoria: guardar, buscar, actualizar y listar',
    () async {
      final repo = ReservaRepositoryMemoria(
        iniciales: semilla,
        retardo: Duration.zero,
      );
      final mias = await repo.listarPorUsuario(DatosMock.usuarioDemoId);
      expect(
        mias.map((r) => r.folio),
        containsAll(['DM-26-K7Q2', 'DM-26-A3F9']),
      );
      expect(mias.every((r) => r.usuarioId == 'u1'), isTrue);

      final dia = await repo.listarEntre(
        DateTime(2026, 11, 1),
        DateTime(2026, 11, 1),
      );
      expect(dia.every((r) => r.fecha == '2026-11-01'), isTrue);
      expect(dia.any((r) => r.folio == 'DM-26-R4NB'), isTrue);

      final nueva = semilla.first.copyWith(folio: 'DM-26-NEW2');
      await repo.guardar(nueva);
      expect((await repo.buscar('DM-26-NEW2'))?.folio, 'DM-26-NEW2');
      expect(() => repo.guardar(nueva), throwsStateError);

      await repo.actualizar(
        nueva.copyWith(estado: EstadoReservacion.cancelada),
      );
      expect(
        (await repo.buscar('DM-26-NEW2'))!.estado,
        EstadoReservacion.cancelada,
      );
      expect(
        () => repo.actualizar(nueva.copyWith(folio: 'DM-26-NOPE')),
        throwsStateError,
      );
      expect(await repo.buscar('DM-26-NOPE'), isNull);
    },
  );

  test(
    'CatalogoRepositoryMock devuelve el catálogo y la temporada del reloj',
    () async {
      final catalogo = CatalogoRepositoryMock(
        reloj: RelojFijo(DateTime(2026, 11, 4)),
        retardo: Duration.zero,
      );
      expect(await catalogo.listarRutas(), hasLength(2));
      expect(await catalogo.listarTrajineras(), hasLength(5));
      expect(await catalogo.listarServicios(), hasLength(3));
      expect(await catalogo.listarEmbarcaderos(), hasLength(2));
      expect((await catalogo.obtenerContenido()).leyendas, hasLength(3));
      expect((await catalogo.obtenerTemporada()).inicio.year, 2027);
    },
  );
}
