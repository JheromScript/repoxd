import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/reservacion.dart';
import '../../models/ruta.dart';
import '../../models/trajinera.dart';
import '../../services/politica_cancelacion.dart';
import '../../state/preferencias_controller.dart' show PreferenciasController;
import '../../state/reservas_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/tarjeta_aviso.dart';
import '../shell/shell_screen.dart';
import 'pago_simulado.dart';

typedef _Catalogo = (List<Ruta>, List<Trajinera>);

enum _Filtro {
  proximas,
  pasadas,
  canceladas;

  String texto(AppLocalizations l) => switch (this) {
    _Filtro.proximas => l.filtroProximas,
    _Filtro.pasadas => l.filtroPasadas,
    _Filtro.canceladas => l.filtroCanceladas,
  };

  String vacio(AppLocalizations l) => switch (this) {
    _Filtro.proximas => l.vacioProximas,
    _Filtro.pasadas => l.vacioPasadas,
    _Filtro.canceladas => l.vacioCanceladas,
  };
}

class MisReservacionesScreen extends StatefulWidget {
  const MisReservacionesScreen({super.key});

  @override
  State<MisReservacionesScreen> createState() => _MisReservacionesScreenState();
}

class _MisReservacionesScreenState extends State<MisReservacionesScreen> {
  late final Future<_Catalogo> _catalogo = _cargar();
  _Filtro _filtro = _Filtro.proximas;

  Future<_Catalogo> _cargar() async {
    final c = context.read<CatalogoRepository>();
    return (await c.listarRutas(), await c.listarTrajineras());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.misReservaciones),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: context.l10n.tooltipSeguridad,
            icon: const Icon(Icons.help),
            onPressed: () =>
                Navigator.of(context).pushNamed(RutasApp.seguridad),
          ),
        ],
      ),
      body: ContenidoCentrado(
        child: CargaFuturo<_Catalogo>(futuro: _catalogo, builder: _cuerpo),
      ),
    );
  }

  Widget _cuerpo(BuildContext context, _Catalogo catalogo) {
    final reservas = context.watch<ReservasController>();
    final lista = switch (_filtro) {
      _Filtro.proximas => reservas.proximas,
      _Filtro.pasadas => reservas.pasadas,
      _Filtro.canceladas => reservas.canceladas,
    };

    return ListView(
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
            for (final f in _Filtro.values)
              FilterChip(
                label: Text(f.texto(context.l10n)),
                selected: f == _filtro,
                onSelected: (_) => setState(() => _filtro = f),
              ),
          ],
        ),
        const SizedBox(height: Espacios.e16),
        if (reservas.cargando && reservas.todas.isEmpty)
          const Padding(
            padding: EdgeInsets.all(Espacios.e32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (lista.isEmpty)
          _Vacio(texto: _filtro.vacio(context.l10n))
        else
          for (final r in lista) ...[
            _TarjetaMiReservacion(
              key: ValueKey('reserva-${r.folio}'),
              reservacion: r,
              catalogo: catalogo,
            ),
            const SizedBox(height: Espacios.e16),
          ],
        if (lista.isNotEmpty)
          TarjetaAviso(texto: context.l10n.avisoCancelar24h),
      ],
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.e48),
      child: Column(
        children: [
          Icon(
            Icons.confirmation_number,
            size: Espacios.e48,
            color: cs.primary,
          ),
          const SizedBox(height: Espacios.e16),
          Text(
            texto,
            style: tema.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Espacios.e8),
          Text(
            context.l10n.eligeRutaYReserva,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Espacios.e24),
          FilledButton(
            onPressed: () => ShellScreen.irA(context, ShellScreen.pestanaRutas),
            child: Text(context.l10n.verRutas),
          ),
        ],
      ),
    );
  }
}

class _TarjetaMiReservacion extends StatefulWidget {
  const _TarjetaMiReservacion({
    super.key,
    required this.reservacion,
    required this.catalogo,
  });

  final Reservacion reservacion;
  final _Catalogo catalogo;

  @override
  State<_TarjetaMiReservacion> createState() => _TarjetaMiReservacionState();
}

class _TarjetaMiReservacionState extends State<_TarjetaMiReservacion> {
  bool _ocupada = false;

  Reservacion get _r => widget.reservacion;

  Future<void> _pagar() async {
    setState(() => _ocupada = true);
    await simularPago(context, _r.folio);
    if (mounted) setState(() => _ocupada = false);
  }

  Future<void> _cancelar() async {
    final reservas = context.read<ReservasController>();
    final mensajero = ScaffoldMessenger.of(context);
    final variante = reservas.varianteDe(_r);
    if (variante == null) return;
    final idioma = context.read<PreferenciasController>().idioma;
    final l = context.l10n;

    final confirmo = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogoCancelar(reservacion: _r, variante: variante, idioma: idioma),
    );
    if (confirmo != true || !mounted) return;

    setState(() => _ocupada = true);
    String mensaje;
    try {
      final cancelada = await reservas.cancelar(_r.folio);
      mensaje = cancelada.montoReembolsado > 0
          ? l.canceladaReembolso(Formato.pesos(cancelada.montoReembolsado))
          : l.canceladaMsg;
    } on ReservaException {
      mensaje = l.noSePudoCancelar;
    }
    if (mounted) setState(() => _ocupada = false);
    mensajero
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _cambiar() async {
    final mensajero = ScaffoldMessenger.of(context);
    final idioma = context.read<PreferenciasController>().idioma;
    final l = context.l10n;
    final cambiada = await Navigator.of(context)
        .pushNamed(RutasApp.cambiarReservacion, arguments: _r.folio);
    if (cambiada is! Reservacion) return;
    mensajero
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            l.cambiamosTuReservacion(
              Formato.fechaCorta(
                DateTime.parse(cambiada.fecha),
                idioma: idioma,
              ),
              cambiada.horario,
            ),
          ),
        ),
      );
  }

  String _montos(AppLocalizations l) {
    final r = _r;
    return switch (r.estado) {
      EstadoReservacion.pagada => l.montosPagada(Formato.pesos(r.subtotal)),
      EstadoReservacion.pendiente => l.montosPendiente(
        Formato.pesos(r.subtotal),
        Formato.pesos(r.anticipo),
      ),
      EstadoReservacion.cancelada when r.montoReembolsado > 0 =>
        l.montosReembolsado(Formato.pesos(r.montoReembolsado)),
      EstadoReservacion.cancelada when r.pagadaEn != null =>
        l.montosSinReembolso(Formato.pesos(r.anticipo)),
      EstadoReservacion.cancelada => l.montosCanceladaSinCargo,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final r = _r;
    final l = context.l10n;
    final (rutas, trajineras) = widget.catalogo;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final ahora = context.read<ReservasController>().reloj.ahora();
    final ruta = rutas.where((x) => x.id == r.rutaId).firstOrNull;
    final trajinera = trajineras
        .where((x) => x.id == r.trajineraId)
        .firstOrNull;
    final cancelada = r.estado == EstadoReservacion.cancelada;

    final pagar = puedePagar(r, ahora);
    final cambiar = puedeCambiar(r, ahora);
    final cancelar = puedeCancelar(r, ahora);
    final compactas = [pagar, cambiar, cancelar].every((x) => x);
    final relleno = EdgeInsets.symmetric(
      horizontal: compactas ? Espacios.e8 : Espacios.e12,
    );
    const minimo = Size(0, Espacios.botonM);
    final estiloTexto = TextButton.styleFrom(
      padding: relleno,
      minimumSize: minimo,
    );

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: Radios.brMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                r.folio,
                style: tema.textTheme.labelLarge?.copyWith(color: cs.primary),
              ),
              const SizedBox(width: Espacios.e8),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: EtiquetaEstado(
                      EstadoEtiqueta.deReservacion(r.estado),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.e8),
          Text(
            ruta?.nombre.resolver(idioma) ?? r.rutaId,
            style: tema.textTheme.titleMedium?.copyWith(
              color: cancelada ? cs.onSurfaceVariant : cs.onSurface,
            ),
          ),
          const SizedBox(height: Espacios.e8),
          _Meta(
            icono: Icons.event,
            texto:
                '${Formato.fechaCorta(DateTime.parse(r.fecha), idioma: idioma)}'
                ' · ${r.horario}',
          ),
          const SizedBox(height: Espacios.e8),
          _Meta(
            icono: Icons.directions_boat,
            texto:
                '${trajinera?.nombre ?? r.trajineraId} · '
                '${l.personas(r.pasajeros)}',
          ),
          const SizedBox(height: Espacios.e8),
          _Meta(icono: Icons.payment, texto: _montos(l)),
          const SizedBox(height: Espacios.e8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: compactas ? 0 : Espacios.e4,
            children: [
              if (pagar)
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: relleno,
                    minimumSize: minimo,
                  ),
                  onPressed: _ocupada ? null : _pagar,
                  child: Text(l.pagar),
                ),
              TextButton(
                style: estiloTexto,
                onPressed: () => Navigator.of(context)
                    .pushNamed(RutasApp.detalleReservacion, arguments: r.folio),
                child: Text(l.detalle),
              ),
              if (cambiar)
                TextButton(
                  style: estiloTexto,
                  onPressed: _ocupada ? null : _cambiar,
                  child: Text(l.cambiar),
                ),
              if (cancelar)
                TextButton(
                  style: estiloTexto.copyWith(
                    foregroundColor: WidgetStatePropertyAll(cs.error),
                  ),
                  onPressed: _ocupada ? null : _cancelar,
                  child: Text(l.cancelar),
                ),
            ],
          ),
        ],
      ),
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
      children: [
        Icon(icono, size: 18, color: cs.secondary),
        const SizedBox(width: Espacios.e8),
        Expanded(
          child: Text(
            texto,
            style: tema.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class DialogoCancelar extends StatelessWidget {
  const DialogoCancelar({
    super.key,
    required this.reservacion,
    required this.variante,
    this.idioma = 'es',
  });

  final Reservacion reservacion;
  final VarianteCancelacion variante;
  final String idioma;

  static String texto(
    AppLocalizations l,
    Reservacion r,
    VarianteCancelacion variante, {
    String idioma = 'es',
  }) {
    final dia = Formato.fechaCorta(DateTime.parse(r.fecha), idioma: idioma);
    final anticipo = l.montoMxn(Formato.pesos(r.anticipo));
    return switch (variante) {
      VarianteCancelacion.sinCargo => l.cancelarSinCargo(dia, r.folio),
      VarianteCancelacion.conReembolso => l.cancelarConReembolso(
        dia,
        r.folio,
        anticipo,
      ),
      VarianteCancelacion.sinReembolso => l.cancelarSinReembolso(
        dia,
        r.folio,
        anticipo,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = context.l10n;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Espacios.e24,
        vertical: Espacios.e24,
      ),
      icon: Icon(Icons.event, color: cs.secondary),
      title: Text(l.dialogoCancelarTitulo),
      content: Text(texto(l, reservacion, variante, idioma: idioma)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.volver),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: cs.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l.siCancelar),
        ),
      ],
    );
  }
}
