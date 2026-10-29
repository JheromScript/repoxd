import 'package:flutter/foundation.dart';

import '../core/reloj.dart';
import '../models/perfil.dart';
import '../services/validadores.dart';

enum TipoAviso {
  reservaCreada,
  pagoRecibido,
  cancelacion,
  cambio,
  recordatorio,
}

class Aviso {
  const Aviso({
    required this.tipo,
    required this.folio,
    required this.creadoEn,
    this.leido = false,
  });

  final TipoAviso tipo;
  final String folio;
  final DateTime creadoEn;
  final bool leido;
}

/// Idioma, notificaciones, recordatorios, perfil y avisos. Todo en memoria
/// en este parcial (después, `shared_preferences` o la base de datos).
class PreferenciasController extends ChangeNotifier {
  PreferenciasController({required this.reloj, required this._perfil});

  static const List<String> idiomas = ['es', 'en'];

  final Reloj reloj;
  Perfil _perfil;
  final List<Aviso> _avisos = [];

  Perfil get perfil => _perfil;
  String get idioma => _perfil.idioma;
  bool get notificaciones => _perfil.notificaciones;
  bool get recordatorios => _perfil.recordatorios;

  List<Aviso> get avisos => List.unmodifiable(_avisos.reversed);
  int get noLeidos => _avisos.where((a) => !a.leido).length;

  void cambiarIdioma(String codigo) {
    if (!idiomas.contains(codigo)) {
      throw ArgumentError.value(codigo, 'idioma', 'Usa es o en');
    }
    _perfil = _perfil.copyWith(idioma: codigo);
    notifyListeners();
  }

  void cambiarNotificaciones(bool activas) {
    _perfil = _perfil.copyWith(notificaciones: activas);
    notifyListeners();
  }

  void cambiarRecordatorios(bool activos) {
    _perfil = _perfil.copyWith(recordatorios: activos);
    notifyListeners();
  }

  Map<String, ErrorCampo> actualizarPerfil({
    required String nombre,
    required String telefono,
    required String correo,
  }) {
    final errores = <String, ErrorCampo>{
      'nombre': ?Validadores.nombre(nombre),
      'telefono': ?Validadores.telefono(telefono),
      'correo': ?Validadores.correo(correo),
    };
    if (errores.isNotEmpty) return errores;
    _perfil = _perfil.copyWith(
      nombre: nombre.trim(),
      telefono: telefono.trim(),
      correo: correo.trim(),
    );
    notifyListeners();
    return const {};
  }

  void avisar(TipoAviso tipo, String folio) {
    final permitido = tipo == TipoAviso.recordatorio
        ? recordatorios
        : notificaciones;
    if (!permitido) return;
    if (tipo == TipoAviso.recordatorio &&
        _avisos.any((a) => a.tipo == tipo && a.folio == folio)) {
      return;
    }
    _avisos.add(Aviso(tipo: tipo, folio: folio, creadoEn: reloj.ahora()));
    notifyListeners();
  }

  void marcarLeidos() {
    if (noLeidos == 0) return;
    for (var i = 0; i < _avisos.length; i++) {
      final a = _avisos[i];
      _avisos[i] = Aviso(
        tipo: a.tipo,
        folio: a.folio,
        creadoEn: a.creadoEn,
        leido: true,
      );
    }
    notifyListeners();
  }
}
