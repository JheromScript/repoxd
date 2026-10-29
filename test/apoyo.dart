import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/models/ruta.dart';
import 'package:trajineras/models/temporada.dart';
import 'package:trajineras/models/trajinera.dart';
import 'package:trajineras/services/calculo_costos.dart';
import 'package:trajineras/services/disponibilidad.dart';

final Temporada temporada2026 = Temporada.vigente(DateTime(2026, 10, 27));

final Ruta animas = DatosMock.rutas[0];
final Ruta cempasuchil = DatosMock.rutas[1];

final Trajinera catrina = DatosMock.trajineras[0];
final Trajinera flor = DatosMock.trajineras[1];
final Trajinera xochitl = DatosMock.trajineras[2];
final Trajinera lucero = DatosMock.trajineras[3];
final Trajinera chinampa = DatosMock.trajineras[4];

const Contacto contactoLucia = Contacto(
  nombre: 'Lucía Hernández',
  telefono: '5512345678',
  correo: 'lucia.hdz@correo.com',
);

Reservacion reservaDePrueba({
  required String folio,
  required Ruta ruta,
  required Trajinera trajinera,
  required DateTime fecha,
  required String horario,
  int pasajeros = 4,
  EstadoReservacion estado = EstadoReservacion.pagada,
  String usuarioId = 'u1',
}) {
  final costos = Costos.calcular(
    tarifaTrajinera: trajinera.tarifa,
    precioPorPersona: ruta.precioPorPersona,
    pasajeros: pasajeros,
  );
  return Reservacion(
    folio: folio,
    usuarioId: usuarioId,
    rutaId: ruta.id,
    trajineraId: trajinera.id,
    fecha: fechaIso(fecha),
    horario: horario,
    pasajeros: pasajeros,
    contacto: contactoLucia,
    serviciosIds: const [],
    tarifaTrajinera: costos.tarifaTrajinera,
    precioPorPersona: costos.precioPorPersona,
    preciosServicios: const {},
    subtotal: costos.subtotal,
    anticipo: costos.anticipo,
    estado: estado,
    creadaEn: DateTime(2026, 10, 20),
  );
}

Disponibilidad disponibilidadCon(
  Iterable<Reservacion> reservas, {
  DateTime? ahora,
}) => Disponibilidad(
  temporada: temporada2026,
  rutas: DatosMock.rutas,
  reservas: reservas,
  ahora: ahora ?? DateTime(2026, 10, 27, 10),
);
