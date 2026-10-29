import '../models/reservacion.dart';

const int porcentajeAnticipo = 30;

class Costos {
  const Costos({
    required this.tarifaTrajinera,
    required this.precioPorPersona,
    required this.pasajeros,
    required this.servicios,
  });

  factory Costos.calcular({
    required int tarifaTrajinera,
    required int precioPorPersona,
    required int pasajeros,
    Iterable<int> servicios = const [],
  }) => Costos(
    tarifaTrajinera: tarifaTrajinera,
    precioPorPersona: precioPorPersona,
    pasajeros: pasajeros,
    servicios: servicios.fold(0, (suma, p) => suma + p),
  );

  factory Costos.deReservacion(Reservacion r) => Costos.calcular(
    tarifaTrajinera: r.tarifaTrajinera,
    precioPorPersona: r.precioPorPersona,
    pasajeros: r.pasajeros,
    servicios: r.preciosServicios.values,
  );

  final int tarifaTrajinera;
  final int precioPorPersona;
  final int pasajeros;

  final int servicios;

  int get pasajes => precioPorPersona * pasajeros;

  int get subtotal => tarifaTrajinera + pasajes + servicios;

  int get total => subtotal;

  int get anticipo => anticipoDe(subtotal);

  int get resta => subtotal - anticipo;
}

/// `round(subtotal × 0.30)`: lo que se paga al confirmar. Con enteros, para
/// que los medios (p. ej. $5 → $1.50) siempre suban, sin errores de `double`.
int anticipoDe(int subtotal) => (subtotal * porcentajeAnticipo + 50) ~/ 100;
