import 'package:flutter/services.dart';

class FormateadorTelefono extends TextInputFormatter {
  static const int maxDigitos = 10;

  static String soloDigitos(String texto) =>
      texto.replaceAll(RegExp(r'[^0-9]'), '');

  static String formatear(String texto) {
    final d = soloDigitos(texto);
    final digitos = d.length > maxDigitos ? d.substring(0, maxDigitos) : d;
    final b = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i == 2 || i == 6) b.write(' ');
      b.write(digitos[i]);
    }
    return b.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    // Cuántos dígitos quedan antes del cursor, para devolverlo al mismo
    // lugar después de agregar o quitar espacios.
    final cursor = nuevo.selection.end.clamp(0, nuevo.text.length);
    final digitosAntes = soloDigitos(nuevo.text.substring(0, cursor)).length;

    final texto = formatear(nuevo.text);
    var posicion = 0;
    var vistos = 0;
    while (posicion < texto.length && vistos < digitosAntes) {
      if (texto[posicion] != ' ') vistos++;
      posicion++;
    }
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: posicion),
    );
  }
}
