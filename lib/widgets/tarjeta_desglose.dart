import 'package:flutter/material.dart';

import '../core/formato.dart';
import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import '../services/calculo_costos.dart';

class TarjetaDesglose extends StatelessWidget {
  const TarjetaDesglose({
    super.key,
    required this.trajinera,
    required this.costos,
    this.tituloAnticipo,
  });

  final String trajinera;

  final Costos costos;

  final String? tituloAnticipo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final l = context.l10n;
    final pasajeros = costos.pasajeros;

    Widget fila(String concepto, int monto) => Row(
      children: [
        Expanded(
          child: Text(
            concepto,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: Espacios.e12),
        Text(Formato.pesos(monto), style: tema.textTheme.bodyMedium),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: Radios.brMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fila(l.tarifaTrajineraNombre(trajinera), costos.tarifaTrajinera),
          const SizedBox(height: 10),
          fila(
            l.rutaPrecioPorPersonas(
              Formato.pesos(costos.precioPorPersona),
              pasajeros,
            ),
            costos.pasajes,
          ),
          const SizedBox(height: 10),
          fila(l.serviciosAdicionales, costos.servicios),
          const SizedBox(height: 10),
          Divider(height: 1, color: cs.outlineVariant),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text(l.total, style: tema.textTheme.titleMedium)),
              Text(
                l.montoMxn(Formato.pesos(costos.total)),
                style: tema.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(Espacios.e12),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: Radios.brSmall,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tituloAnticipo ?? l.anticipoHoy,
                        style: tema.textTheme.titleSmall?.copyWith(
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        l.restanEnEmbarcadero(Formato.pesos(costos.resta)),
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Espacios.e12),
                Text(
                  Formato.pesos(costos.anticipo),
                  style: tema.textTheme.titleLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
