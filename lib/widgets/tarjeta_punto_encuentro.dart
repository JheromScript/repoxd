import 'package:flutter/material.dart';

import '../core/formato.dart';
import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'icono_circular.dart';

const int minutosPresentacion = 30;

class TarjetaPuntoEncuentro extends StatelessWidget {
  const TarjetaPuntoEncuentro({
    super.key,
    required this.embarcadero,
    required this.muelle,
    required this.horario,
  });

  final String embarcadero;

  final String muelle;

  final String horario;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: Radios.brMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconoCircular(
            Icons.location_on,
            estilo: EstiloIconoCircular.secundario,
          ),
          const SizedBox(width: Espacios.e12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.puntoEncuentro,
                  style: tema.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.embarcaderoYMuelle(
                    embarcadero,
                    muelle.toLowerCase(),
                  ),
                  style: tema.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.presentateA(
                    Formato.horaAntes(horario, minutosPresentacion),
                    minutosPresentacion,
                  ),
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
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
