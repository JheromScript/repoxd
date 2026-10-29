import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';

class IndicadorPasos extends StatelessWidget {
  const IndicadorPasos({super.key, required this.paso})
    : assert(paso >= 1 && paso <= totalPasos);

  final int paso;

  /// Igual a `nombres.length`; constante para poder usar `const IndicadorPasos`.
  static const int totalPasos = 5;

  static List<String> nombres(AppLocalizations l) => [
    l.pasoTrajinera,
    l.pasoFecha,
    l.pasoDatos,
    l.pasoResumen,
    l.pasoConfirmacion,
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final l = context.l10n;
    final nombres = IndicadorPasos.nombres(l);
    final total = nombres.length;

    return Semantics(
      label: l.pasoSemantica(paso, total, nombres[paso - 1]),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (var i = 1; i <= total; i++) ...[
                if (i > 1) const SizedBox(width: Espacios.e4),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= paso
                          ? cs.primary
                          : cs.surfaceContainerHighest,
                      borderRadius: Radios.brFull,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Espacios.e8),
          Row(
            children: [
              Text(
                l.pasoNDeTotal(paso, total),
                style: tema.textTheme.labelMedium?.copyWith(color: cs.primary),
              ),
              const SizedBox(width: Espacios.e8),
              Expanded(
                child: Text(
                  nombres[paso - 1],
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
