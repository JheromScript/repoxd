import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';

Future<void> mostrarAvisoPrivacidad(BuildContext context, String texto) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
    builder: (context) {
      final tema = Theme.of(context);
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.e24,
            Espacios.e0,
            Espacios.e24,
            Espacios.e24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.avisoPrivacidad,
                style: tema.textTheme.headlineSmall,
              ),
              const SizedBox(height: Espacios.e16),
              Text(
                texto,
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Espacios.e24),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.entendido),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
