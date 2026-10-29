import 'mapas.dart';
import 'texto_local.dart';

class ServicioAdicional {
  const ServicioAdicional({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  final String id;
  final TextoLocal nombre;
  final TextoLocal descripcion;

  final int precio;

  Mapa toMap() => {
    'id': id,
    'nombre': nombre.toMap(),
    'descripcion': descripcion.toMap(),
    'precio': precio,
  };

  factory ServicioAdicional.fromMap(Mapa m) => ServicioAdicional(
    id: m['id']! as String,
    nombre: TextoLocal.fromMap(comoMapa(m['nombre'])),
    descripcion: TextoLocal.fromMap(comoMapa(m['descripcion'])),
    precio: m['precio']! as int,
  );

  ServicioAdicional copyWith({
    String? id,
    TextoLocal? nombre,
    TextoLocal? descripcion,
    int? precio,
  }) => ServicioAdicional(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    precio: precio ?? this.precio,
  );
}
