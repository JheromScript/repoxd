const int maxPasajeros = 20;

enum TipoErrorCampo {
  nombreVacio,
  nombreLetras,
  nombreCorto,
  telefonoVacio,
  telefonoLargo,
  correoVacio,
  correoInvalido,
  pasajerosVacio,
  pasajerosMinimo,
  pasajerosMaximo,
  avisoPrivacidad,
}

class ErrorCampo {
  const ErrorCampo(this.tipo, {this.capacidad, this.trajinera});

  final TipoErrorCampo tipo;
  final int? capacidad;
  final String? trajinera;

  @override
  bool operator ==(Object other) =>
      other is ErrorCampo &&
      other.tipo == tipo &&
      other.capacidad == capacidad &&
      other.trajinera == trajinera;

  @override
  int get hashCode => Object.hash(tipo, capacidad, trajinera);

  @override
  String toString() => 'ErrorCampo(${tipo.name})';
}

abstract final class Validadores {
  // Letras de cualquier idioma (con acentos, ñ, ü) y marcas combinadas, por
  // si el teclado escribe "é" como "e" + acento; además, espacios.
  static final RegExp _soloLetras = RegExp(r'^[\p{L}\p{M} ]+$', unicode: true);
  static final RegExp _letra = RegExp(r'\p{L}', unicode: true);
  static final RegExp _telefono = RegExp(r'^[0-9]{10}$');
  static final RegExp _correo = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );

  static ErrorCampo? nombre(String? valor) {
    final v = valor?.trim() ?? '';
    if (v.isEmpty) return const ErrorCampo(TipoErrorCampo.nombreVacio);
    if (!_soloLetras.hasMatch(v)) {
      return const ErrorCampo(TipoErrorCampo.nombreLetras);
    }
    if (_letra.allMatches(v).length < 3) {
      return const ErrorCampo(TipoErrorCampo.nombreCorto);
    }
    return null;
  }

  static ErrorCampo? telefono(String? valor) {
    final v = valor?.trim() ?? '';
    if (v.isEmpty) return const ErrorCampo(TipoErrorCampo.telefonoVacio);
    if (!_telefono.hasMatch(v)) {
      return const ErrorCampo(TipoErrorCampo.telefonoLargo);
    }
    return null;
  }

  static ErrorCampo? correo(String? valor) {
    final v = valor?.trim() ?? '';
    if (v.isEmpty) return const ErrorCampo(TipoErrorCampo.correoVacio);
    if (!_correo.hasMatch(v)) {
      return const ErrorCampo(TipoErrorCampo.correoInvalido);
    }
    return null;
  }

  static ErrorCampo? pasajeros(
    String? valor, {
    required int capacidad,
    String? trajinera,
  }) {
    final n = int.tryParse(valor?.trim() ?? '');
    if (n == null) return const ErrorCampo(TipoErrorCampo.pasajerosVacio);
    if (n < 1) return const ErrorCampo(TipoErrorCampo.pasajerosMinimo);
    if (n > capacidad) {
      return ErrorCampo(
        TipoErrorCampo.pasajerosMaximo,
        capacidad: capacidad,
        trajinera: trajinera,
      );
    }
    return null;
  }

  static ErrorCampo? avisoPrivacidad(bool? aceptado) => aceptado == true
      ? null
      : const ErrorCampo(TipoErrorCampo.avisoPrivacidad);
}
