import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'fila_dato.dart';

class TarjetaReservacion extends StatelessWidget {
  const TarjetaReservacion({
    super.key,
    required this.filas,
    this.titulo,
    this.accion,
  });

  final String? titulo;
  final List<FilaDato> filas;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerHigh,
        borderRadius: Radios.brMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Espacios.botonM,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    titulo ?? context.l10n.tuReservacion,
                    style: tema.textTheme.titleMedium,
                  ),
                ),
                ?accion,
              ],
            ),
          ),
          for (final f in filas) ...[const SizedBox(height: 10), f],
        ],
      ),
    );
  }
}
