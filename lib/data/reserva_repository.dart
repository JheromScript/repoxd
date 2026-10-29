import '../models/reservacion.dart';

abstract class ReservaRepository {
  Future<List<Reservacion>> listarPorUsuario(String usuarioId);
  Future<List<Reservacion>> listarEntre(DateTime desde, DateTime hasta);
  Future<Reservacion?> buscar(String folio);
  Future<void> guardar(Reservacion reservacion);
  Future<void> actualizar(Reservacion reservacion);
}
