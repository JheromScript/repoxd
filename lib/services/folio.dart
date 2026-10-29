import 'dart:math';

/// A–Z y 2–9 sin `0`, `O`, `1` ni `I`, para que no se confundan al dictarlo.
const String alfabetoFolio = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

final RegExp formatoFolio = RegExp(r'^DM-\d{2}-[A-HJ-NP-Z2-9]{4}$');

const int maxIntentosFolio = 50;

class GeneradorFolio {
  GeneradorFolio({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String aleatorio(int anio) {
    final aa = (anio % 100).toString().padLeft(2, '0');
    final clave = String.fromCharCodes([
      for (var i = 0; i < 4; i++)
        alfabetoFolio.codeUnitAt(_random.nextInt(alfabetoFolio.length)),
    ]);
    return 'DM-$aa-$clave';
  }

  Future<String> generar({
    required int anio,
    required Future<bool> Function(String folio) existe,
  }) async {
    for (var i = 0; i < maxIntentosFolio; i++) {
      final folio = aleatorio(anio);
      if (!await existe(folio)) return folio;
    }
    throw StateError('No se pudo generar un folio libre');
  }
}
