import 'mapas.dart';

class Temporada {
  const Temporada({
    required this.inicio,
    required this.fin,
    required this.horaApertura,
    required this.horaCierre,
    required this.fechasSinServicio,
  });

  final DateTime inicio;

  /// Último día, incluido (fecha sin hora).
  final DateTime fin;

  /// `'HH:mm'`.
  final String horaApertura;
  final String horaCierre;

  final List<DateTime> fechasSinServicio;

  /// La temporada del 25 oct al 3 nov del año de [ahora], o la del año
  /// siguiente si ya terminó.
  factory Temporada.vigente(DateTime ahora) {
    final terminada = !ahora.isBefore(DateTime(ahora.year, 11, 4));
    final anio = terminada ? ahora.year + 1 : ahora.year;
    return Temporada(
      inicio: DateTime(anio, 10, 25),
      fin: DateTime(anio, 11, 3),
      horaApertura: '12:00',
      horaCierre: '23:00',
      fechasSinServicio: [DateTime(anio, 10, 29)],
    );
  }

  Mapa toMap() => {
    'inicio': inicio.toIso8601String(),
    'fin': fin.toIso8601String(),
    'horaApertura': horaApertura,
    'horaCierre': horaCierre,
    'fechasSinServicio': [
      for (final f in fechasSinServicio) f.toIso8601String(),
    ],
  };

  factory Temporada.fromMap(Mapa m) => Temporada(
    inicio: DateTime.parse(m['inicio']! as String),
    fin: DateTime.parse(m['fin']! as String),
    horaApertura: m['horaApertura']! as String,
    horaCierre: m['horaCierre']! as String,
    fechasSinServicio: [
      for (final f in m['fechasSinServicio']! as List)
        DateTime.parse(f as String),
    ],
  );

  Temporada copyWith({
    DateTime? inicio,
    DateTime? fin,
    String? horaApertura,
    String? horaCierre,
    List<DateTime>? fechasSinServicio,
  }) => Temporada(
    inicio: inicio ?? this.inicio,
    fin: fin ?? this.fin,
    horaApertura: horaApertura ?? this.horaApertura,
    horaCierre: horaCierre ?? this.horaCierre,
    fechasSinServicio: fechasSinServicio ?? this.fechasSinServicio,
  );
}
