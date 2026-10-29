import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enlaces.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/icono_circular.dart';
import '../../widgets/imagen_tematica.dart';

class ComoLlegarScreen extends StatefulWidget {
  const ComoLlegarScreen({super.key, this.embarcaderoId});

  final String? embarcaderoId;

  @override
  State<ComoLlegarScreen> createState() => _ComoLlegarScreenState();
}

class _ComoLlegarScreenState extends State<ComoLlegarScreen> {
  late final Future<List<Embarcadero>> _embarcaderos = context
      .read<CatalogoRepository>()
      .listarEmbarcaderos();

  int? _elegido;

  static IconData _icono(TipoIndicacion tipo) => switch (tipo) {
    TipoIndicacion.tren => Icons.directions,
    TipoIndicacion.auto => Icons.directions_car,
    TipoIndicacion.app => Icons.phone,
  };

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.comoLlegarTitulo)),
      body: CargaFuturo<List<Embarcadero>>(
        futuro: _embarcaderos,
        builder: (context, lista) {
          if (lista.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Espacios.e24),
                child: Text(
                  context.l10n.embarcaderosVacio,
                  style: tema.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final elegido =
              (_elegido ??
                      lista.indexWhere((e) => e.id == widget.embarcaderoId))
                  .clamp(0, lista.length - 1);
          final e = lista[elegido];

          return ContenidoCentrado(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Espacios.margenPantalla,
                Espacios.e8,
                Espacios.margenPantalla,
                Espacios.e24,
              ),
              children: [
                Wrap(
                  spacing: Espacios.e8,
                  runSpacing: Espacios.e8,
                  children: [
                    for (var i = 0; i < lista.length; i++)
                      FilterChip(
                        label: Text(lista[i].nombre),
                        selected: i == elegido,
                        onSelected: (_) => setState(() => _elegido = i),
                      ),
                  ],
                ),
                const SizedBox(height: Espacios.e16),
                _Mapa(),
                const SizedBox(height: Espacios.e16),
                Container(
                  padding: const EdgeInsets.all(Espacios.e16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHigh,
                    borderRadius: Radios.brMedium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.embarcaderoNombre(e.nombre),
                        style: tema.textTheme.titleMedium,
                      ),
                      const SizedBox(height: Espacios.e8),
                      Text(
                        e.direccion,
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Espacios.e8),
                      Wrap(
                        spacing: Espacios.e16,
                        runSpacing: Espacios.e4,
                        children: [
                          _Meta(
                            icono: Icons.schedule,
                            texto: e.horario.resolver(idioma),
                          ),
                          _Meta(
                            icono: Icons.location_on,
                            texto: e.distancia.resolver(idioma),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Espacios.e16),
                Text(
                  context.l10n.indicaciones,
                  style: tema.textTheme.titleMedium,
                ),
                const SizedBox(height: Espacios.e16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final i in e.indicaciones)
                        ListTile(
                          minTileHeight: 72,
                          contentPadding: const EdgeInsets.only(
                            left: Espacios.e16,
                            right: Espacios.e24,
                          ),
                          minVerticalPadding: Espacios.e12,
                          horizontalTitleGap: Espacios.e16,
                          leading: IconoCircular(_icono(i.tipo)),
                          title: Text(
                            i.titulo.resolver(idioma),
                            style: tema.textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            i.detalle.resolver(idioma),
                            style: tema.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: Espacios.e16),
                FilledButton.icon(
                  style: AppTheme.estiloBotonL(),
                  onPressed: () =>
                      Enlaces.abrir(context, Enlaces.maps(e.consultaMaps)),
                  icon: const Icon(Icons.map),
                  label: Text(context.l10n.abrirGoogleMaps),
                ),
                const SizedBox(height: Espacios.e16),
                OutlinedButton.icon(
                  onPressed: () =>
                      Enlaces.abrir(context, Enlaces.llamada(e.telefono)),
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(context.l10n.llamarEmbarcadero),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Mapa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        const ImagenTematica(
          tema: TemaImagen.mapa,
          alto: 200,
          radio: Radios.brLarge,
        ),
        ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 48, color: cs.primary),
              const SizedBox(height: Espacios.e4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: Radios.brSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_boat, size: 16, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.mapaEmbarcadero,
                      style: tema.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16, color: cs.secondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            texto,
            style: tema.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
