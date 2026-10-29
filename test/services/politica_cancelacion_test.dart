import 'package:test/test.dart';
import 'package:trajineras/models/reservacion.dart';
import 'package:trajineras/services/politica_cancelacion.dart';

import '../apoyo.dart';

void main() {
  Reservacion conEstado(EstadoReservacion estado) => reservaDePrueba(
    folio: 'DM-26-K7Q2',
    ruta: animas,
    trajinera: catrina,
    fecha: DateTime(2026, 10, 31),
    horario: '18:00',
    pasajeros: 12,
    estado: estado,
  );
  final pagada = conEstado(EstadoReservacion.pagada);
  final pendiente = conEstado(EstadoReservacion.pendiente);
  final cancelada = conEstado(EstadoReservacion.cancelada);

  final justoAntes = DateTime(2026, 10, 30, 17, 59);
  final enElLimite = DateTime(2026, 10, 30, 18);
  final justoDespues = DateTime(2026, 10, 30, 18, 1);

  group('las 3 variantes alrededor del límite de 24 h', () {
    test('pendiente → sin cargo, antes y después', () {
      for (final ahora in [justoAntes, enElLimite, justoDespues]) {
        expect(
          varianteCancelacion(pendiente, ahora),
          VarianteCancelacion.sinCargo,
        );
        expect(montoReembolso(pendiente, VarianteCancelacion.sinCargo), 0);
      }
    });

    test('pagada y faltan más de 24 h → reembolso del anticipo', () {
      final v = varianteCancelacion(pagada, justoAntes);
      expect(v, VarianteCancelacion.conReembolso);
      expect(montoReembolso(pagada, v!), pagada.anticipo);
      expect(pagada.anticipo, greaterThan(0));
    });

    test('pagada y faltan 24 h o menos → sin reembolso', () {
      for (final ahora in [enElLimite, justoDespues]) {
        final v = varianteCancelacion(pagada, ahora);
        expect(v, VarianteCancelacion.sinReembolso);
        expect(montoReembolso(pagada, v!), 0);
      }
    });
  });

  test('no se cancela lo ya cancelado ni lo que ya salió', () {
    expect(varianteCancelacion(cancelada, justoAntes), isNull);
    expect(puedeCancelar(cancelada, justoAntes), isFalse);
    final salida = DateTime(2026, 10, 31, 18);
    expect(puedeCancelar(pendiente, salida), isFalse);
    expect(
      puedeCancelar(pagada, salida.add(const Duration(hours: 1))),
      isFalse,
    );
    expect(
      puedeCancelar(pagada, salida.subtract(const Duration(minutes: 1))),
      isTrue,
    );
  });

  test('cambiar: solo con más de 24 h y si no está cancelada', () {
    expect(puedeCambiar(pagada, justoAntes), isTrue);
    expect(puedeCambiar(pendiente, justoAntes), isTrue);
    expect(puedeCambiar(pagada, enElLimite), isFalse);
    expect(puedeCambiar(pendiente, justoDespues), isFalse);
    expect(puedeCambiar(cancelada, justoAntes), isFalse);
  });

  test('pagar: solo pendiente y antes de la salida', () {
    expect(puedePagar(pendiente, justoDespues), isTrue);
    expect(puedePagar(pagada, justoAntes), isFalse);
    expect(puedePagar(cancelada, justoAntes), isFalse);
    expect(puedePagar(pendiente, DateTime(2026, 10, 31, 18)), isFalse);
  });

  test('faltanMasDe24h es estricto', () {
    expect(faltanMasDe24h(pagada, justoAntes), isTrue);
    expect(faltanMasDe24h(pagada, enElLimite), isFalse);
  });
}
