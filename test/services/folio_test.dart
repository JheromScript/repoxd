import 'dart:math';

import 'package:test/test.dart';
import 'package:trajineras/services/folio.dart';

class _RandomFijo implements Random {
  _RandomFijo(this.valores);

  final List<int> valores;
  var _i = 0;

  @override
  int nextInt(int max) => valores[_i++ % valores.length] % max;

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  double nextDouble() => throw UnimplementedError();
}

void main() {
  test('alfabeto: A–Z y 2–9 sin 0, O, 1 ni I', () {
    expect(alfabetoFolio.length, 32);
    expect(alfabetoFolio.split('').toSet(), hasLength(32));
    for (final c in ['0', 'O', '1', 'I']) {
      expect(alfabetoFolio.contains(c), isFalse, reason: c);
    }
  });

  test('formato DM-{AA}-XXXX con Random.secure', () {
    final generador = GeneradorFolio();
    for (var i = 0; i < 2000; i++) {
      final folio = generador.aleatorio(2026);
      expect(folio, matches(formatoFolio));
      expect(folio.startsWith('DM-26-'), isTrue);
      expect(folio.substring(6), isNot(matches(RegExp('[01OI]'))));
    }
    expect(generador.aleatorio(2027), startsWith('DM-27-'));
    expect(generador.aleatorio(2105), startsWith('DM-05-'));
  });

  test('formatoFolio rechaza los caracteres confusos', () {
    expect('DM-26-K7Q2', matches(formatoFolio));
    for (final malo in [
      'DM-26-K7Q0',
      'DM-26-K7QO',
      'DM-26-K7Q1',
      'DM-26-K7QI',
      'DM-26-k7q2',
      'DM-2026-K7Q2',
      'DM-26-K7Q',
      'XX-26-K7Q2',
    ]) {
      expect(malo, isNot(matches(formatoFolio)), reason: malo);
    }
  });

  test('si el folio ya existe, genera otro', () async {
    final generador = GeneradorFolio(
      random: _RandomFijo([0, 0, 0, 0, 1, 1, 1, 1]),
    );
    final consultados = <String>[];
    final folio = await generador.generar(
      anio: 2026,
      existe: (f) async {
        consultados.add(f);
        return f == 'DM-26-AAAA';
      },
    );
    expect(consultados, ['DM-26-AAAA', 'DM-26-BBBB']);
    expect(folio, 'DM-26-BBBB');
  });

  test('si nunca hay uno libre, se rinde', () async {
    final generador = GeneradorFolio(random: _RandomFijo([0]));
    var intentos = 0;
    await expectLater(
      generador.generar(
        anio: 2026,
        existe: (_) async {
          intentos++;
          return true;
        },
      ),
      throwsStateError,
    );
    expect(intentos, maxIntentosFolio);
  });

  test(
    '1,000 folios seguidos no se repiten si se revisa la existencia',
    () async {
      final generador = GeneradorFolio();
      final usados = <String>{};
      for (var i = 0; i < 1000; i++) {
        usados.add(
          await generador.generar(
            anio: 2026,
            existe: (f) async => usados.contains(f),
          ),
        );
      }
      expect(usados, hasLength(1000));
    },
  );
}
