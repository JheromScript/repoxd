import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../models/ruta.dart';
import '../../models/servicio_adicional.dart';
import '../../models/trajinera.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/imagen_tematica.dart';
import 'elegir_ruta.dart';

typedef _DatosDetalle = (
  List<Embarcadero>,
  List<Trajinera>,
  List<ServicioAdicional>,
);

class DetalleRutaScreen extends StatefulWidget {
  const DetalleRutaScreen({super.key, required this.ruta});

  final Ruta ruta;

  @override
  State<DetalleRutaScreen> createState() => _DetalleRutaScreenState();
}

class _DetalleRutaScreenState extends State<DetalleRutaScreen> {
  late final Future<_DatosDetalle> _datos = _cargar();

  Future<_DatosDetalle> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final embarcaderos = await catalogo.listarEmbarcaderos();
    final trajineras = await catalogo.listarTrajineras();
    final servicios = await catalogo.listarServicios();
    return (embarcaderos, trajineras, servicios);
  }

  @override
  Widget build(BuildContext context) {
    final ruta = widget.ruta;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ContenidoCentrado(
              child: CargaFuturo<_DatosDetalle>(
                futuro: _datos,
                builder: (context, datos) => _Cuerpo(
                  ruta: ruta,
                  idioma: idioma,
                  embarcaderos: datos.$1,
                  trajineras: datos.$2,
                  servicios: datos.$3,
                ),
              ),
            ),
          ),
          BarraInferiorAccion(
            etiqueta: context.l10n.desde,
            valor: context.l10n.montoMxn(Formato.pesos(ruta.precioPorPersona)),
            detalle: context.l10n.porPersona,
            valorGrande: true,
            textoBoton: context.l10n.elegirEstaRuta,
            onPressed: () => elegirRuta(context, ruta),
          ),
        ],
      ),
    );
  }
}

class _Cuerpo extends StatelessWidget {
  const _Cuerpo({
    required this.ruta,
    required this.idioma,
    required this.embarcaderos,
    required this.trajineras,
    required this.servicios,
  });

  final Ruta ruta;
  final String idioma;
  final List<Embarcadero> embarcaderos;
  final List<Trajinera> trajineras;
  final List<ServicioAdicional> servicios;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    final embarcadero = embarcaderos
        .where((e) => e.id == ruta.embarcaderoId)
        .firstOrNull;
    final capacidad = trajineras
        .where((t) => t.activa)
        .map((t) => t.capacidad)
        .fold<int>(0, (a, b) => a > b ? a : b);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Hero(ruta: ruta),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.margenPantalla,
            Espacios.e8,
            Espacios.margenPantalla,
            Espacios.e24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ruta.etiqueta.resolver(idioma),
                style: tema.textTheme.labelLarge?.copyWith(color: cs.tertiary),
              ),
              const SizedBox(height: Espacios.e16),
              Text(
                ruta.nombre.resolver(idioma),
                style: tema.textTheme.headlineMedium?.copyWith(
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: Espacios.e16),
              Wrap(
                spacing: Espacios.e8,
                runSpacing: Espacios.e8,
                children: [
                  _Etiqueta(
                    icono: Icons.schedule,
                    texto: Formato.duracion(ruta.duracionMin),
                  ),
                  _Etiqueta(
                    icono: Icons.payment,
                    texto: context.l10n.precioPorPersona(
                      Formato.pesos(ruta.precioPorPersona),
                    ),
                  ),
                  if (capacidad > 0)
                    _Etiqueta(
                      icono: Icons.group,
                      texto: context.l10n.hastaN(capacidad),
                    ),
                  _Etiqueta(
                    icono: Icons.location_on,
                    texto: embarcadero?.nombre ?? ruta.embarcaderoId,
                  ),
                ],
              ),
              const SizedBox(height: Espacios.e16),
              Text(
                ruta.descripcion.resolver(idioma),
                style: tema.textTheme.bodyMedium,
              ),
              const SizedBox(height: Espacios.e16),
              Text(context.l10n.paradas, style: tema.textTheme.titleMedium),
              const SizedBox(height: Espacios.e16),
              _Itinerario(paradas: ruta.paradas, idioma: idioma),
              const SizedBox(height: Espacios.e16),
              Text(context.l10n.horarios, style: tema.textTheme.titleMedium),
              const SizedBox(height: Espacios.e16),
              Wrap(
                spacing: Espacios.e8,
                runSpacing: Espacios.e8,
                children: [for (final h in ruta.horarios) _Etiqueta(texto: h)],
              ),
              const SizedBox(height: Espacios.e16),
              if (ruta.recomendaciones.isNotEmpty)
                _TarjetaRecomendaciones(
                  recomendaciones: [
                    for (final r in ruta.recomendaciones) r.resolver(idioma),
                  ],
                )
              else
                _TarjetaServicios(servicios: servicios, idioma: idioma),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.ruta});

  final Ruta ruta;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final arriba = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 248,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImagenTematica(
            tema: TemaImagen.values.byName(ruta.tema),
            rutaAsset: ruta.imagen,
            alto: 248,
            heroTag: heroTagRuta(ruta),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cs.surface.withValues(alpha: 0.6),
                  cs.surface.withValues(alpha: 0),
                  cs.surface.withValues(alpha: 0),
                  cs.surface,
                ],
                stops: const [0, 0.35, 0.7, 1],
              ),
            ),
          ),
          Positioned(
            left: Espacios.e12,
            top: (arriba > 0 ? arriba : 28) + Espacios.e12,
            child: IconButton.filledTonal(
              tooltip: context.l10n.volver,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta({required this.texto, this.icono});

  final String texto;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: EdgeInsets.fromLTRB(
        icono != null ? Espacios.e8 : Espacios.e16,
        0,
        Espacios.e16,
        0,
      ),
      decoration: BoxDecoration(
        borderRadius: Radios.brSmall,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 18, color: cs.primary),
            const SizedBox(width: Espacios.e8),
          ],
          Flexible(
            child: Text(
              texto,
              style: tema.textTheme.labelLarge?.copyWith(
                color: icono != null ? cs.onSurface : cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Itinerario extends StatelessWidget {
  const _Itinerario({required this.paradas, required this.idioma});

  final List<Parada> paradas;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Column(
      children: [
        for (final (i, p) in paradas.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: tema.textTheme.labelLarge?.copyWith(
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                    if (i < paradas.length - 1)
                      Expanded(
                        child: Container(width: 2, color: cs.outlineVariant),
                      ),
                  ],
                ),
                const SizedBox(width: Espacios.e12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: Espacios.e16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: Espacios.e8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              p.nombre.resolver(idioma),
                              style: tema.textTheme.labelLarge,
                            ),
                            Text(
                              Formato.duracion(p.minutos),
                              style: tema.textTheme.labelSmall?.copyWith(
                                color: cs.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.descripcion.resolver(idioma),
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TarjetaBase extends StatelessWidget {
  const _TarjetaBase({
    required this.icono,
    required this.titulo,
    required this.children,
  });

  final IconData icono;
  final String titulo;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: Radios.brMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 24, color: cs.secondary),
              const SizedBox(width: Espacios.e8),
              Expanded(child: Text(titulo, style: tema.textTheme.labelLarge)),
            ],
          ),
          for (final c in children) ...[
            const SizedBox(height: Espacios.e12),
            c,
          ],
        ],
      ),
    );
  }
}

class _TarjetaRecomendaciones extends StatelessWidget {
  const _TarjetaRecomendaciones({required this.recomendaciones});

  final List<String> recomendaciones;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return _TarjetaBase(
      icono: Icons.verified_user,
      titulo: context.l10n.recomendacionesSeguridad,
      children: [
        for (final r in recomendaciones)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check, size: 18, color: cs.secondary),
              const SizedBox(width: Espacios.e8),
              Expanded(
                child: Text(
                  r,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _TarjetaServicios extends StatelessWidget {
  const _TarjetaServicios({required this.servicios, required this.idioma});

  final List<ServicioAdicional> servicios;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return _TarjetaBase(
      icono: Icons.add_circle,
      titulo: context.l10n.serviciosAdicionales,
      children: [
        for (final s in servicios)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.nombre.resolver(idioma),
                      style: tema.textTheme.bodyMedium,
                    ),
                    Text(
                      s.descripcion.resolver(idioma),
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.e12),
              Text(
                Formato.pesos(s.precio),
                style: tema.textTheme.labelLarge?.copyWith(color: cs.primary),
              ),
            ],
          ),
      ],
    );
  }
}
