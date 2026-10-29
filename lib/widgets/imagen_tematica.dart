import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'icono_svg.dart';

enum TemaImagen { animas, cempasuchil, trajinera, leyenda, mapa, embarcadero }

class ImagenTematica extends StatelessWidget {
  const ImagenTematica({
    super.key,
    required this.tema,
    this.rutaAsset,
    this.alto = 180,
    this.radio,
    this.heroTag,
  });

  final TemaImagen tema;

  final Object? heroTag;

  final String? rutaAsset;
  final double alto;
  final BorderRadius? radio;

  @override
  Widget build(BuildContext context) {
    final ruta = rutaAsset;
    Widget contenido = ruta == null
        ? _Placeholder(tema)
        : Image.asset(
            ruta,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _Placeholder(tema),
          );

    if (radio != null) {
      contenido = ClipRRect(borderRadius: radio!, child: contenido);
    }
    final tag = heroTag;
    if (tag != null) contenido = Hero(tag: tag, child: contenido);
    return SizedBox(height: alto, width: double.infinity, child: contenido);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.tema);

  final TemaImagen tema;

  // Medidas del componente en Figma (328 × 180) para escalar las flores.
  static const double _anchoBase = 328;
  static const double _altoBase = 180;

  static const List<(double, double, double)> _flores = [
    (0.0549, 0.1000, 20),
    (0.8720, 0.1444, 28),
    (0.4573, 0.0889, 16),
    (0.8232, 0.7111, 22),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final degradados = tema.extension<DegradadosImagen>()!;
    final colores = switch (this.tema) {
      TemaImagen.animas => degradados.animas,
      TemaImagen.cempasuchil => degradados.cempasuchil,
      TemaImagen.trajinera => degradados.trajinera,
      TemaImagen.leyenda => degradados.leyenda,
      TemaImagen.mapa => degradados.mapa,
      TemaImagen.embarcadero => degradados.embarcadero,
    };
    final colorIcono = cs.onSurface.withValues(alpha: 0.9);
    final colorFlor = cs.primary.withValues(alpha: 0.4);

    return LayoutBuilder(
      builder: (context, restricciones) {
        final ancho = restricciones.maxWidth;
        final alto = restricciones.maxHeight;
        final escala = [
          ancho / _anchoBase,
          alto / _altoBase,
        ].reduce((a, b) => a < b ? a : b);
        final ladoIcono = 64.0.clamp(0.0, alto * 0.6);

        final Widget icono = switch (this.tema) {
          TemaImagen.animas => IconoSvg(
            IconoPropio.calavera,
            tamano: ladoIcono,
            color: colorIcono,
          ),
          TemaImagen.cempasuchil => IconoSvg(
            IconoPropio.flor,
            tamano: ladoIcono,
            color: colorIcono,
          ),
          TemaImagen.trajinera => Icon(
            Icons.directions_boat,
            size: ladoIcono,
            color: colorIcono,
          ),
          TemaImagen.leyenda => Icon(
            Icons.book,
            size: ladoIcono,
            color: colorIcono,
          ),
          TemaImagen.mapa => Icon(
            Icons.map,
            size: ladoIcono,
            color: colorIcono,
          ),
          TemaImagen.embarcadero => Icon(
            Icons.location_on,
            size: ladoIcono,
            color: colorIcono,
          ),
        };

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colores,
            ),
          ),
          child: Stack(
            children: [
              for (final (x, y, lado) in _flores)
                Positioned(
                  left: x * ancho,
                  top: y * alto,
                  child: IconoSvg(
                    IconoPropio.flor,
                    tamano: lado * escala,
                    color: colorFlor,
                  ),
                ),
              Center(child: ExcludeSemantics(child: icono)),
            ],
          ),
        );
      },
    );
  }
}
