import 'mapas.dart';

class Perfil {
  const Perfil({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    this.idioma = 'es',
    this.notificaciones = true,
    this.recordatorios = true,
  });

  final String id;
  final String nombre;

  /// 10 dígitos, sin espacios.
  final String telefono;
  final String correo;

  final String idioma;
  final bool notificaciones;
  final bool recordatorios;

  Mapa toMap() => {
    'id': id,
    'nombre': nombre,
    'telefono': telefono,
    'correo': correo,
    'idioma': idioma,
    'notificaciones': notificaciones,
    'recordatorios': recordatorios,
  };

  factory Perfil.fromMap(Mapa m) => Perfil(
    id: m['id']! as String,
    nombre: m['nombre']! as String,
    telefono: m['telefono']! as String,
    correo: m['correo']! as String,
    idioma: m['idioma']! as String,
    notificaciones: m['notificaciones']! as bool,
    recordatorios: m['recordatorios']! as bool,
  );

  Perfil copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? correo,
    String? idioma,
    bool? notificaciones,
    bool? recordatorios,
  }) => Perfil(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    correo: correo ?? this.correo,
    idioma: idioma ?? this.idioma,
    notificaciones: notificaciones ?? this.notificaciones,
    recordatorios: recordatorios ?? this.recordatorios,
  );
}
