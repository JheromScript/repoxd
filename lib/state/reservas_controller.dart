import 'package:flutter/foundation.dart';

import '../core/reloj.dart';
import '../data/catalogo_repository.dart';
import '../data/reserva_repository.dart';
import '../models/reservacion.dart';
import '../models/ruta.dart';
import '../models/trajinera.dart';
import '../services/disponibilidad.dart';
import '../services/folio.dart';
import '../services/politica_cancelacion.dart';
import 'flujo_reserva_controller.dart';
import 'preferencias_controller.dart';

enum MotivoRechazo {
  fechaInvalida,

  sinServicio,

  capacidad,

  ocupado,

  noEncontrada,

  noPermitido,
}

class ReservaException implements Exception {
  const ReservaException(this.motivo);

  final MotivoRechazo motivo;

  @override
  String toString() => 'ReservaException(${motivo.name})';
}

class ReservasController extends ChangeNotifier {
  ReservasController({
    required this.reloj,
    required this.reservas,
    required this.catalogo,
    this.usuarioId = 'u1',
    GeneradorFolio? folios,
    this.preferencias,
  }) : folios = folios ?? GeneradorFolio();

  final Reloj reloj;
  final ReservaRepository reservas;
  final CatalogoRepository catalogo;
  final String usuarioId;
  final GeneradorFolio folios;

  final PreferenciasController? preferencias;

  List<Reservacion> _mias = [];
  bool _cargando = false;
  bool _desechado = false;

  /// Cola: una operación a la vez, para que un doble toque en "Confirmar"
  /// vea la reservación que guardó el primero.
  Future<void> _cola = Future.value();

  bool get cargando => _cargando;

  List<Reservacion> get todas => List.unmodifiable(_mias);

  List<Reservacion> get proximas {
    final ahora = reloj.ahora();
    return _ordenar(
      _mias.where((r) => esActiva(r) && r.inicio.isAfter(ahora)),
      recientesPrimero: false,
    );
  }

  List<Reservacion> get pasadas {
    final ahora = reloj.ahora();
    return _ordenar(
      _mias.where((r) => esActiva(r) && !r.inicio.isAfter(ahora)),
      recientesPrimero: true,
    );
  }

  List<Reservacion> get canceladas =>
      _ordenar(_mias.where((r) => !esActiva(r)), recientesPrimero: true);

  Reservacion? get proxima {
    final p = proximas;
    return p.isEmpty ? null : p.first;
  }

  Future<void> cargar() => _enCola(() async {
    _cargando = true;
    _notificar();
    try {
      _mias = await reservas.listarPorUsuario(usuarioId);
      _avisarRecordatorios();
    } finally {
      _cargando = false;
      _notificar();
    }
  });

  Future<Disponibilidad> disponibilidad() async {
    final temporada = await catalogo.obtenerTemporada();
    final rutas = await catalogo.listarRutas();
    final ocupacion = await reservas.listarEntre(
      temporada.inicio,
      temporada.fin,
    );
    return Disponibilidad(
      temporada: temporada,
      rutas: rutas,
      reservas: ocupacion,
      ahora: reloj.ahora(),
    );
  }

  Future<Reservacion> confirmar(SolicitudReserva s) => _enCola(() async {
    final disp = await disponibilidad();
    _validarSalida(
      disp,
      ruta: s.ruta,
      trajinera: s.trajinera,
      fecha: s.fecha,
      horario: s.horario,
      pasajeros: s.pasajeros,
    );

    final folio = await folios.generar(
      anio: disp.temporada.inicio.year,
      existe: (f) async => await reservas.buscar(f) != null,
    );
    final costos = s.costos;
    final nueva = Reservacion(
      folio: folio,
      usuarioId: usuarioId,
      rutaId: s.ruta.id,
      trajineraId: s.trajinera.id,
      fecha: fechaIso(s.fecha),
      horario: s.horario,
      pasajeros: s.pasajeros,
      contacto: s.contacto,
      serviciosIds: [for (final x in s.servicios) x.id],
      tarifaTrajinera: costos.tarifaTrajinera,
      precioPorPersona: costos.precioPorPersona,
      preciosServicios: {for (final x in s.servicios) x.id: x.precio},
      subtotal: costos.subtotal,
      anticipo: costos.anticipo,
      estado: EstadoReservacion.pendiente,
      creadaEn: reloj.ahora(),
      metodoPago: s.metodoPago,
    );
    await reservas.guardar(nueva);
    _mias = [..._mias, nueva];
    preferencias?.avisar(TipoAviso.reservaCreada, folio);
    _notificar();
    return nueva;
  });

  Future<Reservacion> pagar(String folio) => _enCola(() async {
    final r = await _buscarMia(folio);
    final ahora = reloj.ahora();
    if (!puedePagar(r, ahora)) {
      throw const ReservaException(MotivoRechazo.noPermitido);
    }
    final pagada = r.copyWith(
      estado: EstadoReservacion.pagada,
      pagadaEn: ahora,
    );
    await _guardarCambio(pagada);
    preferencias?.avisar(TipoAviso.pagoRecibido, folio);
    return pagada;
  });

  VarianteCancelacion? varianteDe(Reservacion r) =>
      varianteCancelacion(r, reloj.ahora());

  Future<Reservacion> cancelar(String folio) => _enCola(() async {
    final r = await _buscarMia(folio);
    final ahora = reloj.ahora();
    final variante = varianteCancelacion(r, ahora);
    if (variante == null) {
      throw const ReservaException(MotivoRechazo.noPermitido);
    }
    final cancelada = r.copyWith(
      estado: EstadoReservacion.cancelada,
      canceladaEn: ahora,
      montoReembolsado: montoReembolso(r, variante),
    );
    await _guardarCambio(cancelada);
    preferencias?.avisar(TipoAviso.cancelacion, folio);
    return cancelada;
  });

  bool sePuedeCambiar(Reservacion r) => puedeCambiar(r, reloj.ahora());

  Future<Reservacion> cambiar(
    String folio, {
    required DateTime fecha,
    required String horario,
  }) => _enCola(() async {
    final r = await _buscarMia(folio);
    if (!puedeCambiar(r, reloj.ahora())) {
      throw const ReservaException(MotivoRechazo.noPermitido);
    }
    final ruta = (await catalogo.listarRutas()).firstWhere(
      (x) => x.id == r.rutaId,
    );
    final trajinera = (await catalogo.listarTrajineras()).firstWhere(
      (x) => x.id == r.trajineraId,
    );
    _validarSalida(
      await disponibilidad(),
      ruta: ruta,
      trajinera: trajinera,
      fecha: fecha,
      horario: horario,
      pasajeros: r.pasajeros,
      excluirFolio: r.folio,
    );
    final cambiada = r.copyWith(fecha: fechaIso(fecha), horario: horario);
    await _guardarCambio(cambiada);
    preferencias?.avisar(TipoAviso.cambio, folio);
    return cambiada;
  });

  void _validarSalida(
    Disponibilidad disp, {
    required Ruta ruta,
    required Trajinera trajinera,
    required DateTime fecha,
    required String horario,
    required int pasajeros,
    String? excluirFolio,
  }) {
    if (!trajinera.activa) {
      throw const ReservaException(MotivoRechazo.sinServicio);
    }
    if (!cabenPasajeros(trajinera, pasajeros)) {
      throw const ReservaException(MotivoRechazo.capacidad);
    }
    if (!disp.horarioValido(ruta, fecha, horario)) {
      throw const ReservaException(MotivoRechazo.fechaInvalida);
    }
    if (disp.hayChoque(
      ruta: ruta,
      trajineraId: trajinera.id,
      fecha: fecha,
      horario: horario,
      excluirFolio: excluirFolio,
    )) {
      throw const ReservaException(MotivoRechazo.ocupado);
    }
  }

  /// Lee del repositorio (no de la lista local) para operar sobre lo último.
  Future<Reservacion> _buscarMia(String folio) async {
    final r = await reservas.buscar(folio);
    if (r == null || r.usuarioId != usuarioId) {
      throw const ReservaException(MotivoRechazo.noEncontrada);
    }
    return r;
  }

  Future<void> _guardarCambio(Reservacion r) async {
    await reservas.actualizar(r);
    _mias = [
      for (final x in _mias) x.folio == r.folio ? r : x,
      if (!_mias.any((x) => x.folio == r.folio)) r,
    ];
    _notificar();
  }

  void _avisarRecordatorios() {
    final ahora = reloj.ahora();
    for (final r in proximas) {
      if (!faltanMasDe24h(r, ahora)) {
        preferencias?.avisar(TipoAviso.recordatorio, r.folio);
      }
    }
  }

  Future<T> _enCola<T>(Future<T> Function() accion) {
    final resultado = _cola.then((_) => accion());
    _cola = resultado.then<void>((_) {}, onError: (_) {});
    return resultado;
  }

  static List<Reservacion> _ordenar(
    Iterable<Reservacion> lista, {
    required bool recientesPrimero,
  }) {
    final ordenada = lista.toList()
      ..sort((a, b) => a.inicio.compareTo(b.inicio));
    return recientesPrimero ? ordenada.reversed.toList() : ordenada;
  }

  void _notificar() {
    if (!_desechado) notifyListeners();
  }

  @override
  void dispose() {
    _desechado = true;
    super.dispose();
  }
}
