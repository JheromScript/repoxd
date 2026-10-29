import '../models/contenido.dart';
import '../models/embarcadero.dart';
import '../models/ruta.dart';
import '../models/servicio_adicional.dart';
import '../models/temporada.dart';
import '../models/trajinera.dart';

abstract class CatalogoRepository {
  Future<List<Ruta>> listarRutas();
  Future<List<Trajinera>> listarTrajineras();
  Future<List<ServicioAdicional>> listarServicios();
  Future<List<Embarcadero>> listarEmbarcaderos();
  Future<Temporada> obtenerTemporada();
  Future<Contenido> obtenerContenido();
}
