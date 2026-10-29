import 'package:flutter/material.dart';

enum EstiloIconoCircular { primario, secundario, acento, terciario }

class IconoCircular extends StatelessWidget {
  const IconoCircular(
    this.icono, {
    super.key,
    this.estilo = EstiloIconoCircular.primario,
    this.lado = 40,
    this.tamanoIcono,
  });

  final IconData icono;
  final EstiloIconoCircular estilo;

  final double lado;

  final double? tamanoIcono;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (fondo, color, tamano) = switch (estilo) {
      EstiloIconoCircular.primario => (
        cs.surfaceContainerHighest,
        cs.primary,
        24.0,
      ),
      EstiloIconoCircular.secundario => (
        cs.secondaryContainer,
        cs.onSecondaryContainer,
        22.0,
      ),
      EstiloIconoCircular.acento => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
        22.0,
      ),
      EstiloIconoCircular.terciario => (
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
        24.0,
      ),
    };

    return Container(
      width: lado,
      height: lado,
      decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icono, size: tamanoIcono ?? tamano, color: color),
    );
  }
}
