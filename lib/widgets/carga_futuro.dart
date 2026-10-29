import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';

/// Espera un `Future` del repositorio: indicador mientras carga y mensaje si
/// falla. Las implementaciones en memoria tardan ~300 ms a propósito.
class CargaFuturo<T> extends StatelessWidget {
  const CargaFuturo({super.key, required this.futuro, required this.builder});

  final Future<T> futuro;
  final Widget Function(BuildContext context, T datos) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: futuro,
      builder: (context, instantanea) {
        if (instantanea.hasError) {
          final tema = Theme.of(context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(Espacios.margenPantalla),
              child: Semantics(
                liveRegion: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: Espacios.e48,
                      color: tema.colorScheme.error,
                    ),
                    const SizedBox(height: Espacios.e16),
                    Text(
                      context.l10n.errorCargar,
                      style: tema.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Espacios.e8),
                    Text(
                      context.l10n.errorCargarDetalle,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (!instantanea.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, instantanea.data as T);
      },
    );
  }
}
