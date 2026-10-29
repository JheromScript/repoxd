import '../models/reservacion.dart';

const Duration limiteCambios = Duration(hours: 24);

enum VarianteCancelacion { sinCargo, conReembolso, sinReembolso }

/// Faltan estrictamente más de [limiteCambios] para la salida. Con 24 h
/// exactas ya no.
bool faltanMasDe24h(Reservacion r, DateTime ahora) =>
    r.inicio.difference(ahora) > limiteCambios;

bool yaEmpezo(Reservacion r, DateTime ahora) => !r.inicio.isAfter(ahora);

VarianteCancelacion? varianteCancelacion(Reservacion r, DateTime ahora) {
  if (yaEmpezo(r, ahora)) return null;
  return switch (r.estado) {
    EstadoReservacion.cancelada => null,
    EstadoReservacion.pendiente => VarianteCancelacion.sinCargo,
    EstadoReservacion.pagada =>
      faltanMasDe24h(r, ahora)
          ? VarianteCancelacion.conReembolso
          : VarianteCancelacion.sinReembolso,
  };
}

bool puedeCancelar(Reservacion r, DateTime ahora) =>
    varianteCancelacion(r, ahora) != null;

int montoReembolso(Reservacion r, VarianteCancelacion variante) =>
    variante == VarianteCancelacion.conReembolso ? r.anticipo : 0;

bool puedeCambiar(Reservacion r, DateTime ahora) =>
    r.estado != EstadoReservacion.cancelada && faltanMasDe24h(r, ahora);

bool puedePagar(Reservacion r, DateTime ahora) =>
    r.estado == EstadoReservacion.pendiente && !yaEmpezo(r, ahora);
