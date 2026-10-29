import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/espacios.dart';
import 'contenido_centrado.dart';

class BarraInferiorAccion extends StatelessWidget {
  const BarraInferiorAccion({
    super.key,
    required this.textoBoton,
    required this.onPressed,
    this.etiqueta,
    this.valor,
    this.valorDestacado = false,
    this.valorGrande = false,
    this.detalle,
    this.cargando = false,
  });

  final String textoBoton;

  final VoidCallback? onPressed;
  final String? etiqueta;
  final String? valor;

  final bool valorDestacado;

  final bool valorGrande;

  final String? detalle;

  final bool cargando;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final hayResumen = etiqueta != null || valor != null;

    Widget boton(double relleno) => FilledButton(
      style: AppTheme.estiloBotonL().copyWith(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: relleno),
        ),
      ),
      onPressed: cargando ? null : onPressed,
      child: cargando
          ? SizedBox.square(
              dimension: Espacios.e24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: cs.onSurface,
              ),
            )
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(textoBoton, maxLines: 1),
            ),
    );

    return Material(
      color: cs.surfaceContainer,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: Espacios.e24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.margenPantalla,
            Espacios.e12,
            Espacios.margenPantalla,
            0,
          ),
          child: ContenidoCentrado(
            ajustarAlto: true,
            child: !hayResumen
                ? boton(Espacios.e32)
                : LayoutBuilder(
                    builder: (context, restricciones) => Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: restricciones.maxWidth * 0.45,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (etiqueta != null)
                                Text(
                                  etiqueta!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.textTheme.labelSmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              if (valor != null)
                                Text(
                                  valor!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: valorGrande
                                      ? tema.textTheme.titleLarge?.copyWith(
                                          color: cs.primary,
                                        )
                                      : valorDestacado
                                      ? tema.textTheme.titleMedium?.copyWith(
                                          color: cs.primary,
                                        )
                                      : tema.textTheme.titleSmall?.copyWith(
                                          color: cs.onSurface,
                                        ),
                                ),
                              if (detalle != null)
                                Text(
                                  detalle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Espacios.e16),
                        Expanded(
                          child: boton(
                            restricciones.maxWidth < 300
                                ? Espacios.e16
                                : Espacios.e32,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
