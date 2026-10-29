import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';

enum TipoAviso { info, error }

class TarjetaAviso extends StatelessWidget {
  const TarjetaAviso({
    super.key,
    required this.texto,
    this.tipo = TipoAviso.info,
    this.icono,
  });

  final String texto;
  final TipoAviso tipo;

  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    final esError = tipo == TipoAviso.error;
    final fondo = esError ? cs.errorContainer : cs.surfaceContainerLow;
    final colorTexto = esError ? cs.onErrorContainer : cs.onSurfaceVariant;
    final colorIcono = esError
        ? cs.onErrorContainer
        : (icono == null ? cs.secondary : cs.onSurfaceVariant);
    final estilo = esError
        ? tema.textTheme.labelMedium
        : tema.textTheme.bodySmall;

    return Container(
      width: double.infinity,
      padding: esError
          ? const EdgeInsets.symmetric(
              horizontal: Espacios.e12,
              vertical: Espacios.e8,
            )
          : const EdgeInsets.all(Espacios.e12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: esError ? Radios.brSmall : Radios.brMedium,
      ),
      child: Row(
        crossAxisAlignment: esError
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(
            icono ?? (esError ? Icons.error : Icons.info),
            size: esError || icono != null ? 18 : 20,
            color: colorIcono,
          ),
          const SizedBox(width: Espacios.e8),
          Expanded(
            child: Text(texto, style: estilo?.copyWith(color: colorTexto)),
          ),
        ],
      ),
    );
  }
}
