import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/contenido.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/icono_svg.dart';
import '../../widgets/imagen_tematica.dart';
import '../../widgets/visor_imagenes.dart';

enum _Seccion { historia, leyendas, galeria }

class TradicionesScreen extends StatefulWidget {
  const TradicionesScreen({super.key});

  @override
  State<TradicionesScreen> createState() => _TradicionesScreenState();
}

class _TradicionesScreenState extends State<TradicionesScreen> {
  late final Future<Contenido> _contenido = context
      .read<CatalogoRepository>()
      .obtenerContenido();

  final Map<_Seccion, GlobalKey> _llaves = {
    for (final s in _Seccion.values) s: GlobalKey(),
  };
  _Seccion _activa = _Seccion.historia;

  static String _nombre(AppLocalizations l, _Seccion s) => switch (s) {
    _Seccion.historia => l.seccionHistoria,
    _Seccion.leyendas => l.seccionLeyendas,
    _Seccion.galeria => l.seccionGaleria,
  };

  void _irA(_Seccion seccion) {
    setState(() => _activa = seccion);
    final contexto = _llaves[seccion]!.currentContext;
    if (contexto == null) return;
    Scrollable.ensureVisible(
      contexto,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tradicionesTitulo)),
      body: CargaFuturo<Contenido>(
        futuro: _contenido,
        builder: (context, contenido) => ContenidoCentrado(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              Espacios.margenPantalla,
              Espacios.e8,
              Espacios.margenPantalla,
              Espacios.e24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImagenTematica(
                  tema: TemaImagen.leyenda,
                  rutaAsset: 'assets/images/leyendas_portada.jpg',
                  alto: 180,
                  radio: Radios.brLarge,
                ),
                const SizedBox(height: Espacios.e16),
                Wrap(
                  spacing: Espacios.e8,
                  runSpacing: Espacios.e8,
                  children: [
                    for (final s in _Seccion.values)
                      FilterChip(
                        label: Text(_nombre(context.l10n, s)),
                        selected: _activa == s,
                        onSelected: (_) => _irA(s),
                      ),
                  ],
                ),
                const SizedBox(height: Espacios.e16),
                Text(
                  context.l10n.historiaTitulo,
                  key: _llaves[_Seccion.historia],
                  style: tema.textTheme.headlineSmall,
                ),
                const SizedBox(height: Espacios.e16),
                Text(
                  contenido.historia.resolver(idioma),
                  style: tema.textTheme.bodyMedium,
                ),
                const SizedBox(height: Espacios.e16),
                Text(
                  context.l10n.leyendasTitulo,
                  key: _llaves[_Seccion.leyendas],
                  style: tema.textTheme.titleMedium,
                ),
                for (final l in contenido.leyendas) ...[
                  const SizedBox(height: Espacios.e16),
                  _TarjetaLeyenda(leyenda: l, idioma: idioma),
                ],
                const SizedBox(height: Espacios.e16),
                Text(
                  context.l10n.seccionGaleria,
                  key: _llaves[_Seccion.galeria],
                  style: tema.textTheme.titleMedium,
                ),
                const SizedBox(height: Espacios.e16),
                const _Galeria(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TarjetaLeyenda extends StatelessWidget {
  const _TarjetaLeyenda({required this.leyenda, required this.idioma});

  final Leyenda leyenda;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final colorIcono = cs.onTertiaryContainer;

    final Widget icono = switch (leyenda.id) {
      'ley_llorona' => IconoSvg(
        IconoPropio.calavera,
        tamano: 24,
        color: colorIcono,
      ),
      'ley_muniecas' => IconoSvg(
        IconoPropio.flor,
        tamano: 24,
        color: colorIcono,
      ),
      _ => Icon(Icons.book, size: 24, color: colorIcono),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.e16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ExcludeSemantics(child: icono),
            ),
            const SizedBox(width: Espacios.e12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leyenda.titulo.resolver(idioma),
                    style: tema.textTheme.labelLarge,
                  ),
                  const SizedBox(height: Espacios.e4),
                  Text(
                    leyenda.texto.resolver(idioma),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Galeria extends StatelessWidget {
  const _Galeria();

  static const List<(TemaImagen, String)> _fotos = [
    (TemaImagen.animas, 'assets/images/galeria_animas.jpg'),
    (TemaImagen.cempasuchil, 'assets/images/galeria_cempasuchil.jpg'),
    (TemaImagen.trajinera, 'assets/images/galeria_trajinera.jpg'),
    (TemaImagen.embarcadero, 'assets/images/galeria_embarcadero.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final etiquetas = [
      l.galeriaFotoAnimas,
      l.galeriaFotoCempasuchil,
      l.galeriaFotoTrajinera,
      l.galeriaFotoEmbarcadero,
    ];
    final imagenes = [
      for (final (i, (tema, ruta)) in _fotos.indexed)
        ImagenVisor(
          tema: tema,
          rutaAsset: ruta,
          etiqueta: etiquetas[i],
          heroTag: 'galeria-$i',
        ),
    ];

    Widget foto(int i) => Semantics(
      button: true,
      label: l.verFotoDe(etiquetas[i]),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: Radios.brLarge,
        onTap: () =>
            abrirVisorImagenes(context, imagenes: imagenes, inicial: i),
        child: ImagenTematica(
          tema: imagenes[i].tema,
          rutaAsset: imagenes[i].rutaAsset,
          alto: 110,
          radio: Radios.brLarge,
          heroTag: imagenes[i].heroTag,
        ),
      ),
    );

    Widget fila(int a, int b) => Row(
      children: [
        Expanded(child: foto(a)),
        const SizedBox(width: Espacios.e16),
        Expanded(child: foto(b)),
      ],
    );

    return Column(
      children: [
        fila(0, 1),
        const SizedBox(height: Espacios.e16),
        fila(2, 3),
      ],
    );
  }
}
