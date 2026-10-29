import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconoPropio {
  calavera('assets/icons/calavera.svg'),
  flor('assets/icons/flor.svg');

  const IconoPropio(this.ruta);

  final String ruta;
}

class IconoSvg extends StatelessWidget {
  const IconoSvg(this.icono, {super.key, this.tamano, this.color});

  final IconoPropio icono;
  final double? tamano;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tema = IconTheme.of(context);
    final lado = tamano ?? tema.size ?? 24;
    return SvgPicture.asset(
      icono.ruta,
      width: lado,
      height: lado,
      colorFilter: ColorFilter.mode(
        color ?? tema.color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
