import 'package:flutter/foundation.dart';

import '../core/reloj.dart';
import '../data/catalogo_repository.dart';
import '../models/reservacion.dart';
import '../models/ruta.dart';
import '../models/servicio_adicional.dart';
import '../models/temporada.dart';
import '../models/trajinera.dart';
import '../services/calculo_costos.dart';
import '../services/disponibilidad.dart';
import '../services/validadores.dart';

class SolicitudReserva {
  const SolicitudReserva({
    required this.ruta,
    required this.trajinera,
    required this.fecha,
    required this.horario,
    required this.pasajeros,
    required this.contacto,
    required this.servicios,
    required this.metodoPago,
  });

  final Ruta ruta;
  final Trajinera trajinera;
  final DateTime fecha;
  final String horario;
  final int pasajeros;
  final Contacto contacto;
  final List<ServicioAdicional> servicios;
  final MetodoPago metodoPago;

  Costos get costos => Costos.calcular(
    tarifaTrajinera: trajinera.tarifa,
    precioPorPersona: ruta.precioPorPersona,
    pasajeros: pasajeros,
    servicios: servicios.map((s) => s.precio),
  );
}

class FlujoReservaController extends ChangeNotifier {
  FlujoReservaController({required this.reloj, required this.catalogo});

  final Reloj reloj;
  final CatalogoRepository catalogo;

  Temporada? _temporada;
  Ruta? _ruta;
  int _pasajeros = 1;
  Trajinera? _trajinera;
  DateTime? _fecha;
  String? _horario;
  Contacto? _contacto;
  final Map<String, ServicioAdicional> _servicios = {};
  MetodoPago _metodoPago = MetodoPago.tarjeta;
  bool _avisoAceptado = false;
  bool _desechado = false;

  Reservacion? _reservaCambio;

  Reservacion? get reservaCambio => _reservaCambio;

  String? get folioCambio => _reservaCambio?.folio;

  bool get hayCambio {
    final r = _reservaCambio;
    if (r == null || _fecha == null || _horario == null) return false;
    return fechaIso(_fecha!) != r.fecha || _horario != r.horario;
  }

  Ruta? get ruta => _ruta;
  int get pasajeros => _pasajeros;
  Trajinera? get trajinera => _trajinera;
  DateTime? get fecha => _fecha;
  String? get horario => _horario;
  Contacto? get contacto => _contacto;
  List<ServicioAdicional> get servicios => List.unmodifiable(_servicios.values);
  MetodoPago get metodoPago => _metodoPago;
  bool get avisoAceptado => _avisoAceptado;

  Future<void> cargar() async {
    _temporada = await catalogo.obtenerTemporada();
    _notificar();
  }

  void iniciar(Ruta ruta, {Contacto? contacto}) {
    _limpiar();
    _ruta = ruta;
    _contacto = contacto;
    _notificar();
  }

  void iniciarCambio(
    Reservacion r, {
    required Ruta ruta,
    required Trajinera trajinera,
  }) {
    _limpiar();
    _reservaCambio = r;
    _ruta = ruta;
    _trajinera = trajinera;
    _pasajeros = r.pasajeros;
    _fecha = soloDia(DateTime.parse(r.fecha));
    _horario = r.horario;
    _contacto = r.contacto;
    _notificar();
  }

  void reiniciar() {
    _limpiar();
    _notificar();
  }

  /// Entre 1 y [maxPasajeros]. Si la trajinera elegida deja de
  /// alcanzar, se deselecciona (y con ella su horario y sus servicios).
  void cambiarPasajeros(int n) {
    _pasajeros = n.clamp(1, maxPasajeros);
    final t = _trajinera;
    if (t != null && !cabenPasajeros(t, _pasajeros)) _soltarTrajinera();
    _notificar();
  }

  /// Si la trajinera cambia, se borra el horario (puede estar ocupado en la
  /// nueva) y los servicios que la nueva no ofrece; la fecha se conserva.
  void elegirTrajinera(Trajinera t) {
    if (!t.activa) {
      throw ArgumentError.value(t.id, 'trajinera', 'Sin servicio');
    }
    if (!cabenPasajeros(t, _pasajeros)) {
      throw ArgumentError.value(t.id, 'trajinera', 'Capacidad insuficiente');
    }
    if (_trajinera?.id != t.id) {
      _horario = null;
      _servicios.removeWhere((id, _) => !t.serviciosIds.contains(id));
    }
    _trajinera = t;
    _notificar();
  }

  /// Si la fecha cambia, se borra el horario.
  void elegirFecha(DateTime f) {
    final temporada = _temporada;
    if (temporada == null) {
      throw StateError('Falta cargar() la temporada');
    }
    final dia = soloDia(f);
    if (!fechaValida(dia, temporada, reloj.ahora())) {
      throw ArgumentError.value(f, 'fecha', 'Fecha sin servicio');
    }
    if (_fecha != dia) _horario = null;
    _fecha = dia;
    _notificar();
  }

  void elegirHorario(String h) {
    final ruta = _ruta;
    if (ruta == null || !ruta.horarios.contains(h)) {
      throw ArgumentError.value(h, 'horario', 'No es horario de la ruta');
    }
    _horario = h;
    _notificar();
  }

  void elegirAlternativa(Alternativa a) {
    elegirTrajinera(a.trajinera);
    elegirFecha(a.fecha);
    elegirHorario(a.horario);
  }

  void quitarHorario() {
    if (_horario == null) return;
    _horario = null;
    _notificar();
  }

  /// Suelta la fecha o el horario que [disp] ya no permite: otra persona
  /// reservó ese horario mientras tanto o ya pasó la hora. Devuelve el
  /// horario que soltó, si soltó uno.
  String? revisar(Disponibilidad disp) {
    final ruta = _ruta;
    final t = _trajinera;
    final f = _fecha;
    final h = _horario;
    if (f != null && !disp.fechaValida(f)) {
      _fecha = null;
      _horario = null;
    } else if (ruta != null &&
        t != null &&
        f != null &&
        h != null &&
        !disp.horarioLibre(ruta, t, f, h, excluirFolio: folioCambio)) {
      _horario = null;
    } else {
      return null;
    }
    _notificar();
    return h;
  }

  void actualizarContacto(Contacto c) {
    _contacto = c;
    _notificar();
  }

  void marcarServicio(ServicioAdicional s, bool marcado) {
    if (marcado) {
      if (_trajinera?.serviciosIds.contains(s.id) != true) {
        throw ArgumentError.value(s.id, 'servicio', 'No lo ofrece');
      }
      _servicios[s.id] = s;
    } else {
      _servicios.remove(s.id);
    }
    _notificar();
  }

  void elegirMetodoPago(MetodoPago m) {
    _metodoPago = m;
    _notificar();
  }

  void aceptarAviso(bool aceptado) {
    _avisoAceptado = aceptado;
    _notificar();
  }

  Costos? get costos {
    final ruta = _ruta;
    final t = _trajinera;
    if (ruta == null || t == null) return null;
    return Costos.calcular(
      tarifaTrajinera: t.tarifa,
      precioPorPersona: ruta.precioPorPersona,
      pasajeros: _pasajeros,
      servicios: _servicios.values.map((s) => s.precio),
    );
  }

  bool get datosValidos {
    final c = _contacto;
    final t = _trajinera;
    return c != null &&
        t != null &&
        Validadores.nombre(c.nombre) == null &&
        Validadores.telefono(c.telefono) == null &&
        Validadores.correo(c.correo) == null &&
        Validadores.pasajeros('$_pasajeros', capacidad: t.capacidad) == null &&
        Validadores.avisoPrivacidad(_avisoAceptado) == null;
  }

  SolicitudReserva? get solicitud {
    final ruta = _ruta;
    final t = _trajinera;
    final f = _fecha;
    final h = _horario;
    final c = _contacto;
    if (ruta == null || t == null || f == null || h == null || c == null) {
      return null;
    }
    if (!datosValidos) return null;
    return SolicitudReserva(
      ruta: ruta,
      trajinera: t,
      fecha: f,
      horario: h,
      pasajeros: _pasajeros,
      contacto: Contacto(
        nombre: c.nombre.trim(),
        telefono: c.telefono.trim(),
        correo: c.correo.trim(),
      ),
      servicios: servicios,
      metodoPago: _metodoPago,
    );
  }

  void _soltarTrajinera() {
    _trajinera = null;
    _horario = null;
    _servicios.clear();
  }

  void _limpiar() {
    _reservaCambio = null;
    _ruta = null;
    _pasajeros = 1;
    _soltarTrajinera();
    _fecha = null;
    _contacto = null;
    _metodoPago = MetodoPago.tarjeta;
    _avisoAceptado = false;
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
