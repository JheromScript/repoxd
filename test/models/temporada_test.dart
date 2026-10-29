import 'package:test/test.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/models/temporada.dart';

Temporada vigenteCon(Reloj reloj) => Temporada.vigente(reloj.ahora());

void main() {
  test('27 oct 2026: temporada 2026 (25 oct – 3 nov)', () {
    final t = vigenteCon(RelojFijo(DateTime(2026, 10, 27)));
    expect(t.inicio, DateTime(2026, 10, 25));
    expect(t.fin, DateTime(2026, 11, 3));
    expect(t.fechasSinServicio, [DateTime(2026, 10, 29)]);
    expect(t.horaApertura, '12:00');
    expect(t.horaCierre, '23:00');
  });

  test('3 nov 2026 tarde: sigue la temporada 2026', () {
    final t = vigenteCon(RelojFijo(DateTime(2026, 11, 3, 23, 30)));
    expect(t.inicio.year, 2026);
  });

  test('4 nov 2026: ya terminó, pasa a la temporada 2027', () {
    final t = vigenteCon(RelojFijo(DateTime(2026, 11, 4)));
    expect(t.inicio, DateTime(2027, 10, 25));
    expect(t.fin, DateTime(2027, 11, 3));
    expect(t.fechasSinServicio, [DateTime(2027, 10, 29)]);
  });

  test('15 mar 2027: todavía no empieza la de 2027', () {
    final t = vigenteCon(RelojFijo(DateTime(2027, 3, 15)));
    expect(t.inicio, DateTime(2027, 10, 25));
    expect(t.fin, DateTime(2027, 11, 3));
  });

  test('RelojSistema devuelve la hora actual', () {
    final antes = DateTime.now();
    final ahora = const RelojSistema().ahora();
    expect(ahora.isBefore(antes), isFalse);
  });
}
