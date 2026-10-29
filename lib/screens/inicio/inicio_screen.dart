import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/reservacion.dart';
import '../../models/ruta.dart';
import '../../models/temporada.dart';
import '../../models/trajinera.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/icono_circular.dart';
import '../../widgets/icono_svg.dart';
import '../../widgets/imagen_tematica.dart';
import '../../widgets/item_lista.dart';
import '../reserva/hoja_elegir_ruta.dart';
import '../shell/shell_screen.dart';
import 'hoja_avisos.dart';

typedef _DatosInicio = (Temporada, List<Ruta>, List<Trajinera>);

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  late final Future<_DatosInicio> _datos = _cargar();

  Future<_DatosInicio> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final temporada = await catalogo.obtenerTemporada();
    final rutas = await catalogo.listarRutas();
    final trajineras = await catalogo.listarTrajineras();
    return (temporada, rutas, trajineras);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final noLeidos = context.select<PreferenciasController, int>(
      (p) => p.noLeidos,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Center(
          child: IconoSvg(IconoPropio.flor, tamano: 24, color: cs.primary),
        ),
        title: Text(
          context.l10n.appNombre,
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: cs.primary),
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.tooltipSeguridad,
            icon: const Icon(Icons.help_outline),
            onPressed: () =>
                Navigator.of(context).pushNamed(RutasApp.seguridad),
          ),
          IconButton(
            tooltip: context.l10n.avisos,
            icon: Badge(
              isLabelVisible: noLeidos > 0,
              label: Text('$noLeidos'),
              child: const Icon(Icons.notifications),
            ),
            onPressed: () => mostrarHojaAvisos(context),
          ),
        ],
      ),
      body: CargaFuturo<_DatosInicio>(
        futuro: _datos,
        builder: (context, datos) => ContenidoCentrado(
          child: _Contenido(
            temporada: datos.$1,
            rutas: datos.$2,
            trajineras: datos.$3,
          ),
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.temporada,
    required this.rutas,
    required this.trajineras,
  });

  final Temporada temporada;
  final List<Ruta> rutas;
  final List<Trajinera> trajineras;

  @override
  Widget build(BuildContext context) {
    final proxima = context.select<ReservasController, Reservacion?>(
      (c) => c.proxima,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Espacios.margenPantalla,
        Espacios.e8,
        Espacios.margenPantalla,
        Espacios.e24,
      ),
      children: [
        _Hero(temporada: temporada),
        const SizedBox(height: Espacios.e24),
        const _Ctas(),
        const SizedBox(height: Espacios.e24),
        const _Explora(),
        if (proxima != null) ...[
          const SizedBox(height: Espacios.e24),
          _ProximaReservacion(
            reservacion: proxima,
            rutas: rutas,
            trajineras: trajineras,
          ),
        ],
        const SizedBox(height: Espacios.e24),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          clipBehavior: Clip.antiAlias,
          child: ItemLista(
            icono: Icons.receipt_long,
            titulo: context.l10n.misReservaciones,
            detalle: context.l10n.misReservacionesDetalle,
            conFlecha: true,
            onTap: () => ShellScreen.irA(context, ShellScreen.pestanaReservas),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.temporada});

  final Temporada temporada;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final fechas =
        '${Formato.diaMes(temporada.inicio, idioma: idioma)} – '
        '${Formato.diaMes(temporada.fin, idioma: idioma)}';

    return ClipRRect(
      borderRadius: Radios.brLarge,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ImagenTematica(
                tema: TemaImagen.animas,
                rutaAsset: 'assets/images/inicio_portada.jpg',
                alto: 200,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      cs.scrim.withValues(alpha: 0),
                      cs.scrim.withValues(alpha: 0.85),
                    ],
                    stops: const [0.3, 1],
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200),
              child: Padding(
                padding: const EdgeInsets.all(Espacios.e16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.inicioTemporada(
                          '${temporada.inicio.year}',
                        ),
                        style: tema.textTheme.labelLarge?.copyWith(
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.inicioNoches,
                        style: tema.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.inicioHorario(
                          fechas,
                          temporada.horaApertura,
                          temporada.horaCierre,
                        ),
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ctas extends StatelessWidget {
  const _Ctas();

  @override
  Widget build(BuildContext context) {
    const ajuste = EdgeInsets.symmetric(horizontal: Espacios.e12);

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(padding: ajuste),
            onPressed: () => ShellScreen.irA(context, ShellScreen.pestanaRutas),
            icon: const Icon(Icons.directions_boat, size: 18),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(context.l10n.verRutas, maxLines: 1),
            ),
          ),
        ),
        const SizedBox(width: Espacios.e12),
        Expanded(
          child: FilledButton.tonalIcon(
            style: FilledButton.styleFrom(padding: ajuste),
            onPressed: () => reservarAhora(context),
            icon: const Icon(Icons.confirmation_number, size: 18),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(context.l10n.reservarAhora, maxLines: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _Explora extends StatelessWidget {
  const _Explora();

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.explora,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Espacios.e12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Acceso(
                  icono: Icons.book,
                  texto: context.l10n.tradiciones,
                  onTap: () => nav.pushNamed(RutasApp.tradiciones),
                ),
              ),
              const SizedBox(width: Espacios.e12),
              Expanded(
                child: _Acceso(
                  icono: Icons.directions,
                  texto: context.l10n.comoLlegar,
                  onTap: () => nav.pushNamed(RutasApp.comoLlegar),
                ),
              ),
              const SizedBox(width: Espacios.e12),
              Expanded(
                child: _Acceso(
                  icono: Icons.shield,
                  texto: context.l10n.seguridadFaq,
                  onTap: () => nav.pushNamed(RutasApp.seguridad),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Acceso extends StatelessWidget {
  const _Acceso({
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Material(
      color: tema.colorScheme.surfaceContainerHigh,
      borderRadius: Radios.brMedium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.e8,
            vertical: Espacios.e12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconoCircular(icono, estilo: EstiloIconoCircular.acento),
              const SizedBox(height: Espacios.e8),
              Text(
                texto,
                style: tema.textTheme.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProximaReservacion extends StatelessWidget {
  const _ProximaReservacion({
    required this.reservacion,
    required this.rutas,
    required this.trajineras,
  });

  final Reservacion reservacion;
  final List<Ruta> rutas;
  final List<Trajinera> trajineras;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    final ruta = rutas.where((r) => r.id == reservacion.rutaId).firstOrNull;
    final trajinera = trajineras
        .where((t) => t.id == reservacion.trajineraId)
        .firstOrNull;
    final fecha = Formato.fechaCorta(
      DateTime.parse(reservacion.fecha),
      idioma: idioma,
    );
    final estado = EstadoEtiqueta.deReservacion(reservacion.estado);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.proximaReservacion,
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: Espacios.e12),
        Material(
          color: cs.surfaceContainer,
          borderRadius: Radios.brMedium,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => ShellScreen.irA(context, ShellScreen.pestanaReservas),
            child: Padding(
              padding: const EdgeInsets.all(Espacios.e16),
              child: Row(
                children: [
                  const IconoCircular(
                    Icons.confirmation_number,
                    estilo: EstiloIconoCircular.secundario,
                    lado: 48,
                    tamanoIcono: 26,
                  ),
                  const SizedBox(width: Espacios.e12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ruta?.nombre.resolver(idioma) ?? reservacion.rutaId,
                          style: tema.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$fecha · ${reservacion.horario} · '
                          '${trajinera?.nombre ?? reservacion.trajineraId}',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.folioConValor(reservacion.folio),
                          style: tema.textTheme.labelMedium?.copyWith(
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Espacios.e12),
                  EtiquetaEstado(estado),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
