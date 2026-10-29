import 'mapas.dart';
import 'texto_local.dart';

class Leyenda {
  const Leyenda({
    required this.id,
    required this.titulo,
    required this.texto,
    this.imagen,
  });

  final String id;
  final TextoLocal titulo;
  final TextoLocal texto;
  final String? imagen;

  Mapa toMap() => {
    'id': id,
    'titulo': titulo.toMap(),
    'texto': texto.toMap(),
    'imagen': imagen,
  };

  factory Leyenda.fromMap(Mapa m) => Leyenda(
    id: m['id']! as String,
    titulo: TextoLocal.fromMap(comoMapa(m['titulo'])),
    texto: TextoLocal.fromMap(comoMapa(m['texto'])),
    imagen: m['imagen'] as String?,
  );

  Leyenda copyWith({
    String? id,
    TextoLocal? titulo,
    TextoLocal? texto,
    String? imagen,
  }) => Leyenda(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    texto: texto ?? this.texto,
    imagen: imagen ?? this.imagen,
  );
}

class PreguntaFrecuente {
  const PreguntaFrecuente({
    required this.id,
    required this.pregunta,
    required this.respuesta,
  });

  final String id;
  final TextoLocal pregunta;
  final TextoLocal respuesta;

  Mapa toMap() => {
    'id': id,
    'pregunta': pregunta.toMap(),
    'respuesta': respuesta.toMap(),
  };

  factory PreguntaFrecuente.fromMap(Mapa m) => PreguntaFrecuente(
    id: m['id']! as String,
    pregunta: TextoLocal.fromMap(comoMapa(m['pregunta'])),
    respuesta: TextoLocal.fromMap(comoMapa(m['respuesta'])),
  );

  PreguntaFrecuente copyWith({
    String? id,
    TextoLocal? pregunta,
    TextoLocal? respuesta,
  }) => PreguntaFrecuente(
    id: id ?? this.id,
    pregunta: pregunta ?? this.pregunta,
    respuesta: respuesta ?? this.respuesta,
  );
}

class ReglaNavegacion {
  const ReglaNavegacion({
    required this.id,
    required this.titulo,
    required this.detalle,
  });

  final String id;
  final TextoLocal titulo;
  final TextoLocal detalle;

  Mapa toMap() => {
    'id': id,
    'titulo': titulo.toMap(),
    'detalle': detalle.toMap(),
  };

  factory ReglaNavegacion.fromMap(Mapa m) => ReglaNavegacion(
    id: m['id']! as String,
    titulo: TextoLocal.fromMap(comoMapa(m['titulo'])),
    detalle: TextoLocal.fromMap(comoMapa(m['detalle'])),
  );

  ReglaNavegacion copyWith({
    String? id,
    TextoLocal? titulo,
    TextoLocal? detalle,
  }) => ReglaNavegacion(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    detalle: detalle ?? this.detalle,
  );
}

class Contenido {
  const Contenido({
    required this.historia,
    required this.leyendas,
    required this.reglas,
    required this.preguntas,
    required this.avisoPrivacidad,
    required this.telefonoContacto,
    required this.correoContacto,
    required this.horarioAtencion,
  });

  final TextoLocal historia;
  final List<Leyenda> leyendas;
  final List<ReglaNavegacion> reglas;
  final List<PreguntaFrecuente> preguntas;
  final TextoLocal avisoPrivacidad;
  final String telefonoContacto;
  final String correoContacto;
  final TextoLocal horarioAtencion;

  Mapa toMap() => {
    'historia': historia.toMap(),
    'leyendas': [for (final l in leyendas) l.toMap()],
    'reglas': [for (final r in reglas) r.toMap()],
    'preguntas': [for (final p in preguntas) p.toMap()],
    'avisoPrivacidad': avisoPrivacidad.toMap(),
    'telefonoContacto': telefonoContacto,
    'correoContacto': correoContacto,
    'horarioAtencion': horarioAtencion.toMap(),
  };

  factory Contenido.fromMap(Mapa m) => Contenido(
    historia: TextoLocal.fromMap(comoMapa(m['historia'])),
    leyendas: listaDeMapas(m['leyendas'], Leyenda.fromMap),
    reglas: listaDeMapas(m['reglas'], ReglaNavegacion.fromMap),
    preguntas: listaDeMapas(m['preguntas'], PreguntaFrecuente.fromMap),
    avisoPrivacidad: TextoLocal.fromMap(comoMapa(m['avisoPrivacidad'])),
    telefonoContacto: m['telefonoContacto']! as String,
    correoContacto: m['correoContacto']! as String,
    horarioAtencion: TextoLocal.fromMap(comoMapa(m['horarioAtencion'])),
  );

  Contenido copyWith({
    TextoLocal? historia,
    List<Leyenda>? leyendas,
    List<ReglaNavegacion>? reglas,
    List<PreguntaFrecuente>? preguntas,
    TextoLocal? avisoPrivacidad,
    String? telefonoContacto,
    String? correoContacto,
    TextoLocal? horarioAtencion,
  }) => Contenido(
    historia: historia ?? this.historia,
    leyendas: leyendas ?? this.leyendas,
    reglas: reglas ?? this.reglas,
    preguntas: preguntas ?? this.preguntas,
    avisoPrivacidad: avisoPrivacidad ?? this.avisoPrivacidad,
    telefonoContacto: telefonoContacto ?? this.telefonoContacto,
    correoContacto: correoContacto ?? this.correoContacto,
    horarioAtencion: horarioAtencion ?? this.horarioAtencion,
  );
}
