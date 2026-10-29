import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'imagen_tematica.dart';

class TarjetaRuta extends StatelessWidget {
  const TarjetaRuta({
    super.key,
    required this.nombre,
    required this.duracion,
    required this.precio,
    required this.salida,
    required this.tema,
    this.rutaImagen,
    this.onTap,
    this.onElegir,
    this.textoBoton,
    this.heroTag,
    this.ladoALado = false,
  });

  final String nombre;
  final String duracion;
  final String precio;
  final String salida;
  final TemaImagen tema;
  final String? rutaImagen;

  final VoidCallback? onTap;

  final VoidCallback? onElegir;

  final String? textoBoton;

  final Object? heroTag;

  /// Dos tarjetas lado a lado dentro de un `IntrinsicHeight`: reserva 2 líneas
  /// para el nombre y baja el botón al fondo, así los dos botones quedan a la
  /// misma altura aunque un texto ocupe más líneas en una de las tarjetas.
  /// Exige alto acotado; no usar en una lista sin `IntrinsicHeight`.
  final bool ladoALado;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    Widget dato(IconData icono, String texto) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 16, color: cs.secondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: tema.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );

    final contenido = Padding(
      padding: const EdgeInsets.all(Espacios.e12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: ladoALado ? 40 : 0),
            child: Text(
              nombre,
              style: tema.textTheme.titleSmall?.copyWith(color: cs.onSurface),
            ),
          ),
          const SizedBox(height: Espacios.e8),
          dato(Icons.schedule, duracion),
          const SizedBox(height: Espacios.e8),
          dato(Icons.payment, precio),
          const SizedBox(height: Espacios.e8),
          dato(Icons.location_on, salida),
          if (ladoALado) const Spacer(),
          const SizedBox(height: Espacios.e8),
          FilledButton(
            onPressed: onElegir,
            child: Text(textoBoton ?? context.l10n.elegir),
          ),
        ],
      ),
    );

    return Card(
      color: cs.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagenTematica(
              tema: this.tema,
              rutaAsset: rutaImagen,
              alto: 96,
              heroTag: heroTag,
            ),
            if (ladoALado) Expanded(child: contenido) else contenido,
          ],
        ),
      ),
    );
  }
}
