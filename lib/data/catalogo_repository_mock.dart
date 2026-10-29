import '../core/reloj.dart';
import '../models/contenido.dart';
import '../models/embarcadero.dart';
import '../models/ruta.dart';
import '../models/servicio_adicional.dart';
import '../models/temporada.dart';
import '../models/trajinera.dart';
import 'catalogo_repository.dart';
import 'datos_mock.dart';

class CatalogoRepositoryMock implements CatalogoRepository {
  const CatalogoRepositoryMock({
    required this.reloj,
    this.retardo = const Duration(milliseconds: 300),
  });

  final Reloj reloj;
  final Duration retardo;

  Future<T> _tras<T>(T valor) => Future.delayed(retardo, () => valor);

  @override
  Future<List<Ruta>> listarRutas() => _tras(DatosMock.rutas);

  @override
  Future<List<Trajinera>> listarTrajineras() => _tras(DatosMock.trajineras);

  @override
  Future<List<ServicioAdicional>> listarServicios() =>
      _tras(DatosMock.servicios);

  @override
  Future<List<Embarcadero>> listarEmbarcaderos() =>
      _tras(DatosMock.embarcaderos);

  @override
  Future<Temporada> obtenerTemporada() =>
      _tras(Temporada.vigente(reloj.ahora()));

  @override
  Future<Contenido> obtenerContenido() => _tras(DatosMock.contenido);
}
