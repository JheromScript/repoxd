import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import 'icono_circular.dart';

class ItemLista extends StatelessWidget {
  const ItemLista({
    super.key,
    required this.icono,
    required this.titulo,
    this.detalle,
    this.onTap,
    this.trailing,
    this.conFlecha = false,
  });

  final IconData icono;
  final String titulo;
  final String? detalle;
  final VoidCallback? onTap;

  final Widget? trailing;
  final bool conFlecha;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return ListTile(
      onTap: onTap,
      minTileHeight: 72,
      contentPadding: const EdgeInsets.only(
        left: Espacios.e16,
        right: Espacios.e24,
      ),
      minVerticalPadding: Espacios.e12,
      horizontalTitleGap: Espacios.e16,
      leading: IconoCircular(icono),
      title: Text(titulo, style: tema.textTheme.bodyLarge),
      subtitle: detalle == null
          ? null
          : Text(
              detalle!,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
      trailing:
          trailing ??
          (conFlecha
              ? Icon(Icons.chevron_right, color: cs.onSurfaceVariant)
              : null),
    );
  }
}
