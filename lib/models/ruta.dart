import 'mapas.dart';
import 'texto_local.dart';

class Parada {
  const Parada({
    required this.nombre,
    required this.minutos,
    required this.descripcion,
  });

  final TextoLocal nombre;
  final int minutos;
  final TextoLocal descripcion;

  Mapa toMap() => {
    'nombre': nombre.toMap(),
    'minutos': minutos,
    'descripcion': descripcion.toMap(),
  };

  factory Parada.fromMap(Mapa m) => Parada(
    nombre: TextoLocal.fromMap(comoMapa(m['nombre'])),
    minutos: m['minutos']! as int,
    descripcion: TextoLocal.fromMap(comoMapa(m['descripcion'])),
  );

  Parada copyWith({
    TextoLocal? nombre,
    int? minutos,
    TextoLocal? descripcion,
  }) => Parada(
    nombre: nombre ?? this.nombre,
    minutos: minutos ?? this.minutos,
    descripcion: descripcion ?? this.descripcion,
  );
}

class Ruta {
  const Ruta({
    required this.id,
    required this.nombre,
    required this.etiqueta,
    required this.ambiente,
    required this.descripcion,
    required this.duracionMin,
    required this.precioPorPersona,
    required this.embarcaderoId,
    required this.horarios,
    required this.paradas,
    required this.recomendaciones,
    required this.tema,
    this.imagen,
  });

  final String id;
  final TextoLocal nombre;
  final TextoLocal etiqueta;
  final TextoLocal ambiente;
  final TextoLocal descripcion;
  final int duracionMin;

  final int precioPorPersona;
  final String embarcaderoId;

  /// Horas de salida, `'HH:mm'`.
  final List<String> horarios;
  final List<Parada> paradas;
  final List<TextoLocal> recomendaciones;

  final String? imagen;

  final String tema;

  Mapa toMap() => {
    'id': id,
    'nombre': nombre.toMap(),
    'etiqueta': etiqueta.toMap(),
    'ambiente': ambiente.toMap(),
    'descripcion': descripcion.toMap(),
    'duracionMin': duracionMin,
    'precioPorPersona': precioPorPersona,
    'embarcaderoId': embarcaderoId,
    'horarios': horarios,
    'paradas': [for (final p in paradas) p.toMap()],
    'recomendaciones': TextoLocal.listaAMapas(recomendaciones),
    'imagen': imagen,
    'tema': tema,
  };

  factory Ruta.fromMap(Mapa m) => Ruta(
    id: m['id']! as String,
    nombre: TextoLocal.fromMap(comoMapa(m['nombre'])),
    etiqueta: TextoLocal.fromMap(comoMapa(m['etiqueta'])),
    ambiente: TextoLocal.fromMap(comoMapa(m['ambiente'])),
    descripcion: TextoLocal.fromMap(comoMapa(m['descripcion'])),
    duracionMin: m['duracionMin']! as int,
    precioPorPersona: m['precioPorPersona']! as int,
    embarcaderoId: m['embarcaderoId']! as String,
    horarios: listaDeTextos(m['horarios']),
    paradas: listaDeMapas(m['paradas'], Parada.fromMap),
    recomendaciones: TextoLocal.listaDesde(m['recomendaciones']),
    imagen: m['imagen'] as String?,
    tema: m['tema']! as String,
  );

  Ruta copyWith({
    String? id,
    TextoLocal? nombre,
    TextoLocal? etiqueta,
    TextoLocal? ambiente,
    TextoLocal? descripcion,
    int? duracionMin,
    int? precioPorPersona,
    String? embarcaderoId,
    List<String>? horarios,
    List<Parada>? paradas,
    List<TextoLocal>? recomendaciones,
    String? imagen,
    String? tema,
  }) => Ruta(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    etiqueta: etiqueta ?? this.etiqueta,
    ambiente: ambiente ?? this.ambiente,
    descripcion: descripcion ?? this.descripcion,
    duracionMin: duracionMin ?? this.duracionMin,
    precioPorPersona: precioPorPersona ?? this.precioPorPersona,
    embarcaderoId: embarcaderoId ?? this.embarcaderoId,
    horarios: horarios ?? this.horarios,
    paradas: paradas ?? this.paradas,
    recomendaciones: recomendaciones ?? this.recomendaciones,
    imagen: imagen ?? this.imagen,
    tema: tema ?? this.tema,
  );
}
