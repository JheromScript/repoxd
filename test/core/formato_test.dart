import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/formato.dart';

void main() {
  test('pesos separa los miles', () {
    expect(Formato.pesos(0), r'$0');
    expect(Formato.pesos(250), r'$250');
    expect(Formato.pesos(1500), r'$1,500');
    expect(Formato.pesos(5000), r'$5,000');
    expect(Formato.pesos(1234567), r'$1,234,567');
  });

  test('duracion en horas con medias horas', () {
    expect(Formato.duracion(120), '2 h');
    expect(Formato.duracion(90), '1.5 h');
    expect(Formato.duracion(45), '45 min');
    expect(Formato.duracion(20), '20 min');
  });
}
