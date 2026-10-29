import 'mapas.dart';
import 'texto_local.dart';

class Trajinera {
  const Trajinera({
    required this.id,
    required this.nombre,
    required this.capacidad,
    required this.tarifa,
    required this.incluye,
    required this.serviciosIds,
    this.accesible = false,
    this.notaAccesibilidad,
    this.activa = true,
    this.imagen,
  });

  final String id;
  final String nombre;
  final int capacidad;

  final int tarifa;
  final List<TextoLocal> incluye;

  final List<String> serviciosIds;
  final bool accesible;
  final TextoLocal? notaAccesibilidad;

  final bool activa;
  final String? imagen;

  Mapa toMap() => {
    'id': id,
    'nombre': nombre,
    'capacidad': capacidad,
    'tarifa': tarifa,
    'incluye': TextoLocal.listaAMapas(incluye),
    'serviciosIds': serviciosIds,
    'accesible': accesible,
    'notaAccesibilidad': notaAccesibilidad?.toMap(),
    'activa': activa,
    'imagen': imagen,
  };

  factory Trajinera.fromMap(Mapa m) => Trajinera(
    id: m['id']! as String,
    nombre: m['nombre']! as String,
    capacidad: m['capacidad']! as int,
    tarifa: m['tarifa']! as int,
    incluye: TextoLocal.listaDesde(m['incluye']),
    serviciosIds: listaDeTextos(m['serviciosIds']),
    accesible: m['accesible']! as bool,
    notaAccesibilidad: m['notaAccesibilidad'] == null
        ? null
        : TextoLocal.fromMap(comoMapa(m['notaAccesibilidad'])),
    activa: m['activa']! as bool,
    imagen: m['imagen'] as String?,
  );

  Trajinera copyWith({
    String? id,
    String? nombre,
    int? capacidad,
    int? tarifa,
    List<TextoLocal>? incluye,
    List<String>? serviciosIds,
    bool? accesible,
    TextoLocal? notaAccesibilidad,
    bool? activa,
    String? imagen,
  }) => Trajinera(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    capacidad: capacidad ?? this.capacidad,
    tarifa: tarifa ?? this.tarifa,
    incluye: incluye ?? this.incluye,
    serviciosIds: serviciosIds ?? this.serviciosIds,
    accesible: accesible ?? this.accesible,
    notaAccesibilidad: notaAccesibilidad ?? this.notaAccesibilidad,
    activa: activa ?? this.activa,
    imagen: imagen ?? this.imagen,
  );
}
