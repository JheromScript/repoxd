import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../models/reservacion.dart';
import '../../models/ruta.dart';
import '../../services/politica_cancelacion.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_folio.dart';
import '../../widgets/tarjeta_punto_encuentro.dart';
import '../reservacion/pago_simulado.dart';
import '../shell/shell_screen.dart';

typedef _DatosConfirmacion = (List<Ruta>, List<Embarcadero>);

class ConfirmacionScreen extends StatefulWidget {
  const ConfirmacionScreen({super.key, required this.folio});

  final String folio;

  @override
  State<ConfirmacionScreen> createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  late final Future<_DatosConfirmacion> _datos = _cargar();
  bool _pagando = false;

  Future<_DatosConfirmacion> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    return (await catalogo.listarRutas(), await catalogo.listarEmbarcaderos());
  }

  void _aInicio() => ShellScreen.mostrar(context, ShellScreen.pestanaInicio);

  Future<void> _simularPago() async {
    if (_pagando) return;
    setState(() => _pagando = true);
    await simularPago(context, widget.folio);
    if (mounted) setState(() => _pagando = false);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final ce = tema.extension<ColoresEstado>()!;
    final reservas = context.watch<ReservasController>();
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final r = reservas.todas.where((x) => x.folio == widget.folio).firstOrNull;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (seCerro, _) {
        if (!seCerro && !_pagando) _aInicio();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: context.l10n.volverAInicio,
            icon: const Icon(Icons.arrow_back),
            onPressed: _aInicio,
          ),
          title: Text(context.l10n.confirmacionTitulo),
        ),
        body: r == null
            ? const Center(child: CircularProgressIndicator())
            : ContenidoCentrado(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Espacios.margenPantalla,
                    Espacios.e8,
                    Espacios.margenPantalla,
                    Espacios.e24,
                  ),
                  children: [
                    const IndicadorPasos(paso: 5),
                    const SizedBox(height: Espacios.e16),
                    const SizedBox(height: Espacios.e8),
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: ce.successContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 48,
                          color: ce.success,
                        ),
                      ),
                    ),
                    const SizedBox(height: Espacios.e8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.l10n.reservacionConfirmada,
                        style: tema.textTheme.headlineMedium?.copyWith(
                          color: cs.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Espacios.e8),
                    Text(
                      context.l10n.comprobanteListo,

                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Espacios.e16),
                    TarjetaFolio(
                      folio: r.folio,
                      estado: EstadoEtiqueta.deReservacion(r.estado),
                    ),
                    const SizedBox(height: Espacios.e16),
                    CargaFuturo<_DatosConfirmacion>(
                      futuro: _datos,
                      builder: (context, datos) {
                        final embarcadero = _embarcaderoDe(r, datos);
                        return embarcadero == null
                            ? const SizedBox.shrink()
                            : TarjetaPuntoEncuentro(
                                embarcadero: embarcadero.nombre,
                                muelle: embarcadero.muelle.resolver(idioma),
                                horario: r.horario,
                              );
                      },
                    ),
                    if (puedePagar(r, reservas.reloj.ahora())) ...[
                      const SizedBox(height: Espacios.e16),
                      FilledButton.icon(
                        style: AppTheme.estiloBotonL(),
                        onPressed: _pagando ? null : _simularPago,
                        icon: const Icon(Icons.payment),
                        label: Text(context.l10n.simularPagoAnticipo),
                      ),
                    ],
                    const SizedBox(height: Espacios.e16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Espacios.e12,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                              RutasApp.detalleReservacion,
                              arguments: r.folio,
                            ),
                            icon: const Icon(Icons.receipt_long, size: 18),
                            label: Text(context.l10n.comprobante, maxLines: 1),
                          ),
                        ),
                        const SizedBox(width: Espacios.e12),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Espacios.e12,
                              ),
                            ),
                            onPressed: () async {
                              final datos = await _datos;
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamed(
                                RutasApp.comoLlegar,
                                arguments: _embarcaderoDe(r, datos)?.id,
                              );
                            },
                            icon: const Icon(Icons.directions, size: 18),
                            label: Text(context.l10n.comoLlegar, maxLines: 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Espacios.e16),
                    TextButton(
                      onPressed: () => ShellScreen.mostrar(
                        context,
                        ShellScreen.pestanaReservas,
                      ),
                      child: Text(context.l10n.irAMisReservaciones),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  static Embarcadero? _embarcaderoDe(Reservacion r, _DatosConfirmacion datos) {
    final ruta = datos.$1.where((x) => x.id == r.rutaId).firstOrNull;
    return datos.$2.where((e) => e.id == ruta?.embarcaderoId).firstOrNull;
  }
}
