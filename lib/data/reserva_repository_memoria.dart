import '../models/reservacion.dart';
import 'reserva_repository.dart';

class ReservaRepositoryMemoria implements ReservaRepository {
  ReservaRepositoryMemoria({
    Iterable<Reservacion> iniciales = const [],
    this.retardo = const Duration(milliseconds: 300),
  }) {
    for (final r in iniciales) {
      _porFolio[r.folio] = r;
    }
  }

  final Duration retardo;
  final Map<String, Reservacion> _porFolio = {};

  Future<T> _tras<T>(T Function() calcular) =>
      Future.delayed(retardo, calcular);

  @override
  Future<List<Reservacion>> listarPorUsuario(String usuarioId) => _tras(
    () => [
      for (final r in _porFolio.values)
        if (r.usuarioId == usuarioId) r,
    ],
  );

  @override
  Future<List<Reservacion>> listarEntre(DateTime desde, DateTime hasta) {
    final d = DateTime(desde.year, desde.month, desde.day);
    final h = DateTime(hasta.year, hasta.month, hasta.day);
    return _tras(
      () => [
        for (final r in _porFolio.values)
          if (!DateTime.parse(r.fecha).isBefore(d) &&
              !DateTime.parse(r.fecha).isAfter(h))
            r,
      ],
    );
  }

  @override
  Future<Reservacion?> buscar(String folio) => _tras(() => _porFolio[folio]);

  @override
  Future<void> guardar(Reservacion reservacion) => _tras(() {
    if (_porFolio.containsKey(reservacion.folio)) {
      throw StateError('Ya existe el folio ${reservacion.folio}');
    }
    _porFolio[reservacion.folio] = reservacion;
  });

  @override
  Future<void> actualizar(Reservacion reservacion) => _tras(() {
    if (!_porFolio.containsKey(reservacion.folio)) {
      throw StateError('No existe el folio ${reservacion.folio}');
    }
    _porFolio[reservacion.folio] = reservacion;
  });
}
