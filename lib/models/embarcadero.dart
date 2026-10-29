import 'mapas.dart';
import 'texto_local.dart';

enum TipoIndicacion { tren, auto, app }

class Indicacion {
  const Indicacion({
    required this.tipo,
    required this.titulo,
    required this.detalle,
  });

  final TipoIndicacion tipo;
  final TextoLocal titulo;
  final TextoLocal detalle;

  Mapa toMap() => {
    'tipo': tipo.name,
    'titulo': titulo.toMap(),
    'detalle': detalle.toMap(),
  };

  factory Indicacion.fromMap(Mapa m) => Indicacion(
    tipo: TipoIndicacion.values.byName(m['tipo']! as String),
    titulo: TextoLocal.fromMap(comoMapa(m['titulo'])),
    detalle: TextoLocal.fromMap(comoMapa(m['detalle'])),
  );

  Indicacion copyWith({
    TipoIndicacion? tipo,
    TextoLocal? titulo,
    TextoLocal? detalle,
  }) => Indicacion(
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    detalle: detalle ?? this.detalle,
  );
}

class Embarcadero {
  const Embarcadero({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.horario,
    required this.distancia,
    required this.muelle,
    required this.telefono,
    required this.consultaMaps,
    required this.indicaciones,
  });

  final String id;
  final String nombre;
  final String direccion;
  final TextoLocal horario;
  final TextoLocal distancia;
  final TextoLocal muelle;
  final String telefono;

  final String consultaMaps;
  final List<Indicacion> indicaciones;

  Mapa toMap() => {
    'id': id,
    'nombre': nombre,
    'direccion': direccion,
    'horario': horario.toMap(),
    'distancia': distancia.toMap(),
    'muelle': muelle.toMap(),
    'telefono': telefono,
    'consultaMaps': consultaMaps,
    'indicaciones': [for (final i in indicaciones) i.toMap()],
  };

  factory Embarcadero.fromMap(Mapa m) => Embarcadero(
    id: m['id']! as String,
    nombre: m['nombre']! as String,
    direccion: m['direccion']! as String,
    horario: TextoLocal.fromMap(comoMapa(m['horario'])),
    distancia: TextoLocal.fromMap(comoMapa(m['distancia'])),
    muelle: TextoLocal.fromMap(comoMapa(m['muelle'])),
    telefono: m['telefono']! as String,
    consultaMaps: m['consultaMaps']! as String,
    indicaciones: listaDeMapas(m['indicaciones'], Indicacion.fromMap),
  );

  Embarcadero copyWith({
    String? id,
    String? nombre,
    String? direccion,
    TextoLocal? horario,
    TextoLocal? distancia,
    TextoLocal? muelle,
    String? telefono,
    String? consultaMaps,
    List<Indicacion>? indicaciones,
  }) => Embarcadero(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    direccion: direccion ?? this.direccion,
    horario: horario ?? this.horario,
    distancia: distancia ?? this.distancia,
    muelle: muelle ?? this.muelle,
    telefono: telefono ?? this.telefono,
    consultaMaps: consultaMaps ?? this.consultaMaps,
    indicaciones: indicaciones ?? this.indicaciones,
  );
}
