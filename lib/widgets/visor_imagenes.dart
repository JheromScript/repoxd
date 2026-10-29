import 'package:flutter/material.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'contenido_centrado.dart';
import 'imagen_tematica.dart';

class ImagenVisor {
  const ImagenVisor({
    required this.tema,
    required this.etiqueta,
    required this.heroTag,
    this.rutaAsset,
  });

  final TemaImagen tema;
  final String? rutaAsset;

  final String etiqueta;
  final Object heroTag;
}

Future<void> abrirVisorImagenes(
  BuildContext context, {
  required List<ImagenVisor> imagenes,
  int inicial = 0,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) =>
          VisorImagenes(imagenes: imagenes, inicial: inicial),
      transitionsBuilder: (_, animacion, _, hijo) =>
          FadeTransition(opacity: animacion, child: hijo),
    ),
  );
}

class VisorImagenes extends StatefulWidget {
  const VisorImagenes({super.key, required this.imagenes, this.inicial = 0});

  final List<ImagenVisor> imagenes;
  final int inicial;

  @override
  State<VisorImagenes> createState() => _VisorImagenesState();
}

class _VisorImagenesState extends State<VisorImagenes> {
  late final PageController _controlador = PageController(
    initialPage: widget.inicial,
  );
  late int _actual = widget.inicial;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final l = context.l10n;
    final imagenes = widget.imagenes;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ContenidoCentrado(
          child: Stack(
            children: [
              PageView.builder(
                controller: _controlador,
                itemCount: imagenes.length,
                onPageChanged: (i) => setState(() => _actual = i),
                itemBuilder: (context, i) {
                  final imagen = imagenes[i];
                  return Center(
                    child: Semantics(
                      image: true,
                      label: imagen.etiqueta,
                      child: InteractiveViewer(
                        maxScale: 4,
                        child: ImagenTematica(
                          tema: imagen.tema,
                          rutaAsset: imagen.rutaAsset,
                          alto: 320,
                          radio: Radios.brLarge,
                          heroTag: imagen.heroTag,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: Espacios.e8,
                left: Espacios.e8,
                child: IconButton.filledTonal(
                  tooltip: l.cerrar,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              Positioned(
                left: Espacios.margenPantalla,
                right: Espacios.margenPantalla,
                bottom: Espacios.e24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      imagenes[_actual].etiqueta,
                      textAlign: TextAlign.center,
                      style: tema.textTheme.titleMedium,
                    ),
                    const SizedBox(height: Espacios.e4),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l.fotoNDeTotal('${_actual + 1}', '${imagenes.length}'),
                        style: tema.textTheme.labelMedium?.copyWith(
                          color: tema.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
