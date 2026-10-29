import '../models/reservacion.dart';
import '../models/ruta.dart';
import '../models/temporada.dart';
import '../models/trajinera.dart';

const Duration anticipacionMinima = Duration(hours: 1);

const int porcentajePocosLugares = 70;

const int maxAlternativas = 3;

DateTime soloDia(DateTime f) => DateTime(f.year, f.month, f.day);

String fechaIso(DateTime f) =>
    '${f.year.toString().padLeft(4, '0')}-'
    '${f.month.toString().padLeft(2, '0')}-'
    '${f.day.toString().padLeft(2, '0')}';

DateTime momento(DateTime fecha, String horario) {
  final partes = horario.split(':');
  return DateTime(
    fecha.year,
    fecha.month,
    fecha.day,
    int.parse(partes[0]),
    int.parse(partes[1]),
  );
}

int _minutos(String horario) {
  final partes = horario.split(':');
  return int.parse(partes[0]) * 60 + int.parse(partes[1]);
}

bool _mismoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Dos intervalos `[inicio, fin)` chocan si se traslapan. Que uno
/// termine justo cuando empieza el otro no es choque.
bool seTraslapan(
  DateTime inicioA,
  DateTime finA,
  DateTime inicioB,
  DateTime finB,
) => inicioA.isBefore(finB) && inicioB.isBefore(finA);

bool esActiva(Reservacion r) => r.estado != EstadoReservacion.cancelada;

bool cabenPasajeros(Trajinera trajinera, int pasajeros) =>
    pasajeros >= 1 && pasajeros <= trajinera.capacidad;

bool trajineraElegible(Trajinera trajinera, int pasajeros) =>
    trajinera.activa && cabenPasajeros(trajinera, pasajeros);

bool diaSinServicio(DateTime fecha, Temporada temporada) =>
    temporada.fechasSinServicio.any((f) => _mismoDia(f, fecha));

bool fechaValida(DateTime fecha, Temporada temporada, DateTime ahora) {
  final dia = soloDia(fecha);
  return !dia.isBefore(soloDia(temporada.inicio)) &&
      !dia.isAfter(soloDia(temporada.fin)) &&
      !dia.isBefore(soloDia(ahora)) &&
      !diaSinServicio(dia, temporada);
}

List<DateTime> fechasValidas(Temporada temporada, DateTime ahora) => [
  for (
    var d = soloDia(temporada.inicio);
    !d.isAfter(temporada.fin);
    d = DateTime(d.year, d.month, d.day + 1)
  )
    if (fechaValida(d, temporada, ahora)) d,
];

bool dentroDeOperacion(Ruta ruta, String horario, Temporada temporada) {
  final inicio = _minutos(horario);
  return inicio >= _minutos(temporada.horaApertura) &&
      inicio + ruta.duracionMin <= _minutos(temporada.horaCierre);
}

bool horarioValido(
  Ruta ruta,
  DateTime fecha,
  String horario,
  Temporada temporada,
  DateTime ahora,
) =>
    ruta.horarios.contains(horario) &&
    fechaValida(fecha, temporada, ahora) &&
    dentroDeOperacion(ruta, horario, temporada) &&
    !momento(fecha, horario).isBefore(ahora.add(anticipacionMinima));

List<String> horariosValidos(
  Ruta ruta,
  DateTime fecha,
  Temporada temporada,
  DateTime ahora,
) => [
  for (final h in ruta.horarios)
    if (horarioValido(ruta, fecha, h, temporada, ahora)) h,
];

enum EtiquetaTrajinera { disponible, pocosLugares, sinServicio }

enum TipoAlternativa { otraHora, otraTrajinera, otroDia }

class Alternativa {
  const Alternativa({
    required this.tipo,
    required this.trajinera,
    required this.fecha,
    required this.horario,
  });

  final TipoAlternativa tipo;
  final Trajinera trajinera;

  final DateTime fecha;
  final String horario;

  @override
  String toString() => '$horario · ${trajinera.nombre} · ${fechaIso(fecha)}';
}

/// Ocupación de la temporada en un momento dado. Se arma con las
/// reservaciones de toda la temporada (de todos los usuarios) y se descarta
/// en cuanto cambian: no se actualiza sola.
class Disponibilidad {
  Disponibilidad({
    required this.temporada,
    required List<Ruta> rutas,
    required Iterable<Reservacion> reservas,
    required this.ahora,
  }) : _duraciones = {for (final r in rutas) r.id: r.duracionMin},
       _activas = [
         for (final r in reservas)
           if (esActiva(r)) r,
       ];

  final Temporada temporada;
  final DateTime ahora;
  final Map<String, int> _duraciones;
  final List<Reservacion> _activas;

  DateTime finDe(Reservacion r) {
    final duracion = _duraciones[r.rutaId];
    if (duracion == null) {
      throw ArgumentError.value(r.rutaId, 'rutaId', 'Ruta desconocida');
    }
    return r.inicio.add(Duration(minutes: duracion));
  }

  bool fechaValida(DateTime fecha) => _fechaValida(fecha, temporada, ahora);

  bool diaSinServicio(DateTime fecha) => _diaSinServicio(fecha, temporada);

  List<DateTime> fechasValidas() => _fechasValidas(temporada, ahora);

  bool horarioValido(Ruta ruta, DateTime fecha, String horario) =>
      _horarioValido(ruta, fecha, horario, temporada, ahora);

  List<String> horariosValidos(Ruta ruta, DateTime fecha) =>
      _horariosValidos(ruta, fecha, temporada, ahora);

  List<Reservacion> choques({
    required Ruta ruta,
    required String trajineraId,
    required DateTime fecha,
    required String horario,
    String? excluirFolio,
  }) {
    final inicio = momento(fecha, horario);
    final fin = inicio.add(Duration(minutes: ruta.duracionMin));
    return [
      for (final r in _activas)
        if (r.trajineraId == trajineraId &&
            r.folio != excluirFolio &&
            seTraslapan(inicio, fin, r.inicio, finDe(r)))
          r,
    ];
  }

  bool hayChoque({
    required Ruta ruta,
    required String trajineraId,
    required DateTime fecha,
    required String horario,
    String? excluirFolio,
  }) => choques(
    ruta: ruta,
    trajineraId: trajineraId,
    fecha: fecha,
    horario: horario,
    excluirFolio: excluirFolio,
  ).isNotEmpty;

  bool horarioLibre(
    Ruta ruta,
    Trajinera trajinera,
    DateTime fecha,
    String horario, {
    String? excluirFolio,
  }) =>
      trajinera.activa &&
      horarioValido(ruta, fecha, horario) &&
      !hayChoque(
        ruta: ruta,
        trajineraId: trajinera.id,
        fecha: fecha,
        horario: horario,
        excluirFolio: excluirFolio,
      );

  List<String> horariosLibres(
    Ruta ruta,
    Trajinera trajinera,
    DateTime fecha, {
    String? excluirFolio,
  }) => [
    for (final h in ruta.horarios)
      if (horarioLibre(ruta, trajinera, fecha, h, excluirFolio: excluirFolio))
        h,
  ];

  /// La proporción se mide sobre todas las salidas de [ruta] en la
  /// temporada (días con servicio × horarios dentro de operación), pasadas
  /// incluidas, para que la etiqueta no cambie según el día en que se mire.
  EtiquetaTrajinera etiqueta(Trajinera trajinera, Ruta ruta) {
    if (!trajinera.activa) return EtiquetaTrajinera.sinServicio;
    var salidas = 0;
    var ocupadas = 0;
    for (
      var d = soloDia(temporada.inicio);
      !d.isAfter(temporada.fin);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      if (diaSinServicio(d)) continue;
      for (final h in ruta.horarios) {
        if (!dentroDeOperacion(ruta, h, temporada)) continue;
        salidas++;
        if (hayChoque(
          ruta: ruta,
          trajineraId: trajinera.id,
          fecha: d,
          horario: h,
        )) {
          ocupadas++;
        }
      }
    }
    if (salidas > 0 && ocupadas * 100 >= salidas * porcentajePocosLugares) {
      return EtiquetaTrajinera.pocosLugares;
    }
    return EtiquetaTrajinera.disponible;
  }

  /// Si [horario] está ocupado (o es `null` y el día no tiene
  /// ninguno libre), sugiere hasta [maxAlternativas], una de cada tipo y en
  /// este orden:
  ///
  /// 1. otra hora el mismo día con [trajinera], la más cercana a [horario];
  /// 2. la misma hora con otra de [trajineras] que tenga servicio y capacidad
  ///    para [pasajeros], en el orden del catálogo (sin [horario], su primer
  ///    horario libre);
  /// 3. el siguiente día válido en que [trajinera] tenga lugar, a la misma
  ///    hora si se puede o a la más cercana.
  ///
  /// En "modo cambio" se pasa [excluirFolio] y `trajineras: []`, porque la
  /// trajinera no cambia. Si el horario pedido está libre, devuelve `[]`.
  List<Alternativa> alternativas({
    required Ruta ruta,
    required Trajinera trajinera,
    required DateTime fecha,
    String? horario,
    required int pasajeros,
    required List<Trajinera> trajineras,
    String? excluirFolio,
  }) {
    final dia = soloDia(fecha);
    final libresHoy = horariosLibres(
      ruta,
      trajinera,
      dia,
      excluirFolio: excluirFolio,
    );
    if (horario == null ? libresHoy.isNotEmpty : libresHoy.contains(horario)) {
      return const [];
    }

    final sugeridas = <Alternativa>[];

    final otraHora = _masCercano(libresHoy, horario);
    if (horario != null && otraHora != null) {
      sugeridas.add(
        Alternativa(
          tipo: TipoAlternativa.otraHora,
          trajinera: trajinera,
          fecha: dia,
          horario: otraHora,
        ),
      );
    }

    for (final otra in trajineras) {
      if (otra.id == trajinera.id || !cabenPasajeros(otra, pasajeros)) continue;
      final libres = horariosLibres(ruta, otra, dia);
      final h = horario == null
          ? (libres.isEmpty ? null : libres.first)
          : (libres.contains(horario) ? horario : null);
      if (h != null) {
        sugeridas.add(
          Alternativa(
            tipo: TipoAlternativa.otraTrajinera,
            trajinera: otra,
            fecha: dia,
            horario: h,
          ),
        );
        break;
      }
    }

    for (
      var d = DateTime(dia.year, dia.month, dia.day + 1);
      !d.isAfter(temporada.fin);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      final h = _masCercano(
        horariosLibres(ruta, trajinera, d, excluirFolio: excluirFolio),
        horario,
      );
      if (h != null) {
        sugeridas.add(
          Alternativa(
            tipo: TipoAlternativa.otroDia,
            trajinera: trajinera,
            fecha: d,
            horario: h,
          ),
        );
        break;
      }
    }

    return sugeridas.take(maxAlternativas).toList();
  }

  /// El de [opciones] más cercano a [objetivo] (en empate, el más temprano);
  /// sin [objetivo], el primero.
  static String? _masCercano(List<String> opciones, String? objetivo) {
    if (opciones.isEmpty) return null;
    if (objetivo == null) return opciones.first;
    if (opciones.contains(objetivo)) return objetivo;
    final meta = _minutos(objetivo);
    String? mejor;
    var menor = 0;
    for (final h in opciones) {
      final distancia = (_minutos(h) - meta).abs();
      if (mejor == null ||
          distancia < menor ||
          (distancia == menor && _minutos(h) < _minutos(mejor))) {
        mejor = h;
        menor = distancia;
      }
    }
    return mejor;
  }
}

// Alias para llamar a las funciones de arriba desde métodos homónimos.
const _fechaValida = fechaValida;
const _diaSinServicio = diaSinServicio;
const _fechasValidas = fechasValidas;
const _horarioValido = horarioValido;
const _horariosValidos = horariosValidos;
