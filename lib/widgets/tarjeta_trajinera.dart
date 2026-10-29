import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'etiqueta_estado.dart';
import 'imagen_tematica.dart';
import 'tarjeta_aviso.dart';

enum EstadoTrajinera { normal, seleccionada, deshabilitada }

class TarjetaTrajinera extends StatelessWidget {
  const TarjetaTrajinera({
    super.key,
    required this.nombre,
    required this.capacidad,
    required this.tarifa,
    required this.servicios,
    this.estado = EstadoTrajinera.normal,
    this.disponibilidad = EstadoEtiqueta.disponible,
    this.accesible = false,
    this.motivo,
    this.rutaImagen,
    this.heroTag,
    this.onVerFoto,
    this.onTap,
  });

  final String nombre;

  final String capacidad;

  final String tarifa;
  final String servicios;
  final EstadoTrajinera estado;
  final EstadoEtiqueta disponibilidad;
  final bool accesible;

  final String? motivo;
  final String? rutaImagen;

  final Object? heroTag;

  final VoidCallback? onVerFoto;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final seleccionada = estado == EstadoTrajinera.seleccionada;
    final deshabilitada = estado == EstadoTrajinera.deshabilitada;

    Widget dato(IconData icono, String texto) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16, color: cs.secondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            texto,
            style: tema.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          ),
        ),
      ],
    );

    final contenido = Padding(
      padding: const EdgeInsets.all(Espacios.e16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nombre,
                  style: tema.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Espacios.e8),
              EtiquetaEstado(disponibilidad),
              if (seleccionada) ...[
                const SizedBox(width: Espacios.e8),
                Icon(Icons.check_circle, size: 24, color: cs.primary),
              ],
            ],
          ),
          const SizedBox(height: Espacios.e8),
          Wrap(
            spacing: Espacios.e16,
            runSpacing: Espacios.e4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              dato(Icons.group, capacidad),
              dato(Icons.payment, tarifa),
              if (accesible)
                Icon(
                  Icons.accessible,
                  size: 20,
                  color: cs.secondary,
                  semanticLabel: context.l10n.accesible,
                ),
            ],
          ),
          const SizedBox(height: Espacios.e8),
          Text(
            servicios,
            style: tema.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

    return Card(
      color: seleccionada ? cs.surfaceContainerHigh : cs.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: Radios.brMedium,
        side: seleccionada
            ? BorderSide(color: cs.primary, width: 2)
            : BorderSide.none,
      ),
      child: Semantics(
        selected: seleccionada,
        enabled: !deshabilitada,
        child: InkWell(
          onTap: deshabilitada ? null : onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                button: onVerFoto != null,
                label: onVerFoto == null
                    ? null
                    : context.l10n.verFotoDe(nombre),
                excludeSemantics: onVerFoto != null,
                child: InkWell(
                  onTap: onVerFoto,
                  child: Opacity(
                    opacity: deshabilitada ? 0.5 : 1,
                    child: ImagenTematica(
                      tema: TemaImagen.trajinera,
                      rutaAsset: rutaImagen,
                      alto: 112,
                      heroTag: heroTag,
                    ),
                  ),
                ),
              ),
              Opacity(opacity: deshabilitada ? 0.6 : 1, child: contenido),
              if (deshabilitada && motivo != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Espacios.e16,
                    0,
                    Espacios.e16,
                    Espacios.e16,
                  ),
                  child: TarjetaAviso(texto: motivo!, tipo: TipoAviso.error),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
