import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';

class FilaDato extends StatelessWidget {
  const FilaDato({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return MergeSemantics(
      child: Row(
        children: [
          Icon(icono, size: 20, color: cs.secondary),
          const SizedBox(width: Espacios.e12),
          Text(
            etiqueta,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: Espacios.e16),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: tema.textTheme.labelLarge?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
