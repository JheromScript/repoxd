import 'package:test/test.dart';
import 'package:trajineras/services/validadores.dart';

void main() {
  void validos(Object? Function(String?) v, List<String> casos) {
    for (final c in casos) {
      expect(v(c), isNull, reason: '"$c" debería ser válido');
    }
  }

  void invalidos(Object? Function(String?) v, List<String?> casos) {
    for (final c in casos) {
      expect(v(c), isNotNull, reason: '"$c" debería ser inválido');
    }
  }

  test('nombre', () {
    validos(Validadores.nombre, [
      'Lucía Hernández',
      'Ana',
      'José Ñúñez',
      'Müller',
      '  Eva  ',
      'José',
    ]);
    invalidos(Validadores.nombre, [
      null,
      '',
      '   ',
      'Al',
      'A B',
      'Lucía2',
      'Ana-María',
      'ana@correo',
      "O'Neil",
    ]);
  });

  test('teléfono: exactamente 10 dígitos', () {
    validos(Validadores.telefono, ['5512345678', '0000000000', ' 5512345678 ']);
    invalidos(Validadores.telefono, [
      null,
      '',
      '551234567',
      '55123456789',
      '55 1234 5678',
      '55-1234-5678',
      '+525512345678',
      'abcdefghij',
    ]);
  });

  test('correo', () {
    validos(Validadores.correo, [
      'lucia.hdz@correo.com',
      'a@b.mx',
      'nombre+viaje@sub.dominio.com.mx',
      'MAYUS@CORREO.COM',
    ]);
    invalidos(Validadores.correo, [
      null,
      '',
      'lucia',
      'lucia@',
      '@correo.com',
      'lucia@correo',
      'lucia@correo.c',
      'lucia@@correo.com',
      'lucia @correo.com',
      'lucia@correo..com',
    ]);
  });

  test('pasajeros: entre 1 y la capacidad', () {
    ErrorCampo? catrina(String? v) =>
        Validadores.pasajeros(v, capacidad: 20, trajinera: 'La Catrina');
    validos(catrina, ['1', '12', '20', ' 8 ']);
    invalidos(catrina, [null, '', '0', '-1', '21', 'doce', '1.5']);
    expect(
      catrina('21'),
      const ErrorCampo(
        TipoErrorCampo.pasajerosMaximo,
        capacidad: 20,
        trajinera: 'La Catrina',
      ),
    );
    expect(
      Validadores.pasajeros('9', capacidad: 8),
      const ErrorCampo(TipoErrorCampo.pasajerosMaximo, capacidad: 8),
    );
  });

  test('aviso de privacidad', () {
    expect(Validadores.avisoPrivacidad(true), isNull);
    expect(Validadores.avisoPrivacidad(false), isNotNull);
    expect(Validadores.avisoPrivacidad(null), isNotNull);
  });
}
