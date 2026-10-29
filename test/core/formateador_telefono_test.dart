import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/formateador_telefono.dart';

void main() {
  TextEditingValue escribir(String texto, {int? cursor}) =>
      FormateadorTelefono().formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(
          text: texto,
          selection: TextSelection.collapsed(offset: cursor ?? texto.length),
        ),
      );

  test('agrupa en 2, 4 y 4 dígitos', () {
    expect(FormateadorTelefono.formatear('5512345678'), '55 1234 5678');
    expect(FormateadorTelefono.formatear('55123456'), '55 1234 56');
    expect(FormateadorTelefono.formatear('55'), '55');
    expect(FormateadorTelefono.formatear(''), '');
  });

  test('quita lo que no es dígito y corta en 10', () {
    expect(escribir('55-12a34 5678 99').text, '55 1234 5678');
    expect(FormateadorTelefono.soloDigitos('55 1234 5678'), '5512345678');
  });

  test('el cursor queda después del mismo dígito', () {
    expect(escribir('551').selection.baseOffset, 4);
    expect(escribir('5512345678', cursor: 4).selection.baseOffset, 5);
  });
}
