import 'mapas.dart';

enum EstadoReservacion { pendiente, pagada, cancelada }

enum MetodoPago { tarjeta, spei }

class Contacto {
  const Contacto({
    required this.nombre,
    required this.telefono,
    required this.correo,
  });

  final String nombre;
  final String telefono;
  final String correo;

  Mapa toMap() => {'nombre': nombre, 'telefono': telefono, 'correo': correo};

  factory Contacto.fromMap(Mapa m) => Contacto(
    nombre: m['nombre']! as String,
    telefono: m['telefono']! as String,
    correo: m['correo']! as String,
  );

  Contacto copyWith({String? nombre, String? telefono, String? correo}) =>
      Contacto(
        nombre: nombre ?? this.nombre,
        telefono: telefono ?? this.telefono,
        correo: correo ?? this.correo,
      );
}

class Reservacion {
  const Reservacion({
    required this.folio,
    required this.usuarioId,
    required this.rutaId,
    required this.trajineraId,
    required this.fecha,
    required this.horario,
    required this.pasajeros,
    required this.contacto,
    required this.serviciosIds,
    required this.tarifaTrajinera,
    required this.precioPorPersona,
    required this.preciosServicios,
    required this.subtotal,
    required this.anticipo,
    required this.estado,
    required this.creadaEn,
    this.metodoPago,
    this.pagadaEn,
    this.canceladaEn,
    this.montoReembolsado = 0,
  });

  /// Llave: `DM-AA-XXXX`.
  final String folio;
  final String usuarioId;
  final String rutaId;
  final String trajineraId;

  /// `'yyyy-MM-dd'`.
  final String fecha;

  /// `'HH:mm'`.
  final String horario;
  final int pasajeros;
  final Contacto contacto;
  final List<String> serviciosIds;

  // Precios aplicados al reservar: el total no cambia si cambia el catálogo.
  final int tarifaTrajinera;
  final int precioPorPersona;

  final Map<String, int> preciosServicios;
  final int subtotal;
  final int anticipo;
  final EstadoReservacion estado;
  final DateTime creadaEn;
  final MetodoPago? metodoPago;
  final DateTime? pagadaEn;
  final DateTime? canceladaEn;
  final int montoReembolsado;

  int get resta => subtotal - anticipo;

  /// Momento de salida. "Pasada" se deriva de esto, no se guarda.
  DateTime get inicio {
    final d = DateTime.parse(fecha);
    final h = horario.split(':');
    return DateTime(d.year, d.month, d.day, int.parse(h[0]), int.parse(h[1]));
  }

  Mapa toMap() => {
    'folio': folio,
    'usuarioId': usuarioId,
    'rutaId': rutaId,
    'trajineraId': trajineraId,
    'fecha': fecha,
    'horario': horario,
    'pasajeros': pasajeros,
    'contacto': contacto.toMap(),
    'serviciosIds': serviciosIds,
    'metodoPago': metodoPago?.name,
    'tarifaTrajinera': tarifaTrajinera,
    'precioPorPersona': precioPorPersona,
    'preciosServicios': preciosServicios,
    'subtotal': subtotal,
    'anticipo': anticipo,
    'estado': estado.name,
    'creadaEn': creadaEn.toIso8601String(),
    'pagadaEn': pagadaEn?.toIso8601String(),
    'canceladaEn': canceladaEn?.toIso8601String(),
    'montoReembolsado': montoReembolsado,
  };

  factory Reservacion.fromMap(Mapa m) => Reservacion(
    folio: m['folio']! as String,
    usuarioId: m['usuarioId']! as String,
    rutaId: m['rutaId']! as String,
    trajineraId: m['trajineraId']! as String,
    fecha: m['fecha']! as String,
    horario: m['horario']! as String,
    pasajeros: m['pasajeros']! as int,
    contacto: Contacto.fromMap(comoMapa(m['contacto'])),
    serviciosIds: listaDeTextos(m['serviciosIds']),
    metodoPago: m['metodoPago'] == null
        ? null
        : MetodoPago.values.byName(m['metodoPago']! as String),
    tarifaTrajinera: m['tarifaTrajinera']! as int,
    precioPorPersona: m['precioPorPersona']! as int,
    preciosServicios: Map<String, int>.from(m['preciosServicios']! as Map),
    subtotal: m['subtotal']! as int,
    anticipo: m['anticipo']! as int,
    estado: EstadoReservacion.values.byName(m['estado']! as String),
    creadaEn: DateTime.parse(m['creadaEn']! as String),
    pagadaEn: fechaOpcional(m['pagadaEn']),
    canceladaEn: fechaOpcional(m['canceladaEn']),
    montoReembolsado: m['montoReembolsado']! as int,
  );

  Reservacion copyWith({
    String? folio,
    String? usuarioId,
    String? rutaId,
    String? trajineraId,
    String? fecha,
    String? horario,
    int? pasajeros,
    Contacto? contacto,
    List<String>? serviciosIds,
    int? tarifaTrajinera,
    int? precioPorPersona,
    Map<String, int>? preciosServicios,
    int? subtotal,
    int? anticipo,
    EstadoReservacion? estado,
    DateTime? creadaEn,
    MetodoPago? metodoPago,
    DateTime? pagadaEn,
    DateTime? canceladaEn,
    int? montoReembolsado,
  }) => Reservacion(
    folio: folio ?? this.folio,
    usuarioId: usuarioId ?? this.usuarioId,
    rutaId: rutaId ?? this.rutaId,
    trajineraId: trajineraId ?? this.trajineraId,
    fecha: fecha ?? this.fecha,
    horario: horario ?? this.horario,
    pasajeros: pasajeros ?? this.pasajeros,
    contacto: contacto ?? this.contacto,
    serviciosIds: serviciosIds ?? this.serviciosIds,
    tarifaTrajinera: tarifaTrajinera ?? this.tarifaTrajinera,
    precioPorPersona: precioPorPersona ?? this.precioPorPersona,
    preciosServicios: preciosServicios ?? this.preciosServicios,
    subtotal: subtotal ?? this.subtotal,
    anticipo: anticipo ?? this.anticipo,
    estado: estado ?? this.estado,
    creadaEn: creadaEn ?? this.creadaEn,
    metodoPago: metodoPago ?? this.metodoPago,
    pagadaEn: pagadaEn ?? this.pagadaEn,
    canceladaEn: canceladaEn ?? this.canceladaEn,
    montoReembolsado: montoReembolsado ?? this.montoReembolsado,
  );
}
