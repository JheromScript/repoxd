import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/reservacion.dart';
import '../../models/servicio_adicional.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/fila_dato.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_aviso.dart';
import '../../widgets/tarjeta_desglose.dart';
import '../../widgets/tarjeta_reservacion.dart';
import 'comun_flujo.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  late final Future<List<ServicioAdicional>> _servicios = context
      .read<CatalogoRepository>()
      .listarServicios();

  bool _enviando = false;

  /// Lo que se envió al confirmar. Se sigue mostrando mientras se espera la
  /// respuesta y mientras esta pantalla sale: el borrador se limpia antes
  /// de que termine la transición y no debe verse "ya no está en curso".
  SolicitudReserva? _enviada;

  Future<void> _confirmar() async {
    if (_enviando) return;
    final flujo = context.read<FlujoReservaController>();
    final reservas = context.read<ReservasController>();
    final navegador = Navigator.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    final idioma = context.read<PreferenciasController>().idioma;
    final l = context.l10n;
    final solicitud = flujo.solicitud;
    if (solicitud == null) return;

    setState(() {
      _enviando = true;
      _enviada = solicitud;
    });
    try {
      final r = await reservas.confirmar(solicitud);
      // El flujo sale de la pila: atrás desde Confirmación lleva a Inicio y
      // no hay forma de volver a confirmar el mismo borrador.
      navegador.pushNamedAndRemoveUntil(
        RutasApp.confirmacion,
        ModalRoute.withName(RutasApp.shell),
        arguments: r.folio,
      );
      flujo.reiniciar();
    } on ReservaException catch (e) {
      final cambiarHorario =
          e.motivo == MotivoRechazo.ocupado ||
          e.motivo == MotivoRechazo.fechaInvalida;
      if (cambiarHorario) {
        flujo.quitarHorario();
        navegador.popUntil(ModalRoute.withName(RutasApp.fechaHorario));
      } else if (mounted) {
        setState(() {
          _enviando = false;
          _enviada = null;
        });
      }
      final fecha = Formato.fechaCorta(solicitud.fecha, idioma: idioma);
      mensajero
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(switch (e.motivo) {
              MotivoRechazo.ocupado => l.reservaOcupado(
                solicitud.horario,
                fecha,
                solicitud.trajinera.nombre,
              ),
              MotivoRechazo.fechaInvalida => l.reservaFechaInvalida(
                solicitud.horario,
                fecha,
              ),
              MotivoRechazo.capacidad => l.reservaSinCapacidad,
              MotivoRechazo.sinServicio => l.reservaSinServicio,
              _ => l.reservaNoConfirmada,
            }),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flujo = context.watch<FlujoReservaController>();
    final s = _enviada ?? flujo.solicitud;
    final l = context.l10n;
    if (s == null) return FlujoIncompleto(titulo: l.pasoResumen);
    final ruta = s.ruta;
    final trajinera = s.trajinera;
    final costos = s.costos;
    final tema = Theme.of(context);
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return PopScope(
      canPop: !_enviando,
      child: Scaffold(
        appBar: barraPaso(context, l.pasoResumen),
        // La barra va en bottomNavigationBar: así los SnackBar salen encima
        // y no tapan "Confirmar".
        body: ContenidoCentrado(
          child: ListView(
            padding: margenPaso,
            children: [
              const IndicadorPasos(paso: 4),
              const SizedBox(height: Espacios.e16),
              TarjetaReservacion(
                accion: TextButton.icon(
                  onPressed: _enviando
                      ? null
                      : () => Navigator.of(context)
                            .popUntil(ModalRoute.withName(RutasApp.reservar)),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(l.editar),
                ),
                filas: [
                  FilaDato(
                    icono: Icons.directions_boat,
                    etiqueta: l.filaRuta,
                    valor: ruta.nombre.resolver(idioma),
                  ),
                  FilaDato(
                    icono: Icons.star,
                    etiqueta: l.filaTrajinera,
                    valor: trajinera.nombre,
                  ),
                  FilaDato(
                    icono: Icons.event,
                    etiqueta: l.filaFecha,
                    valor: Formato.fechaConAnio(s.fecha, idioma: idioma),
                  ),
                  FilaDato(
                    icono: Icons.schedule,
                    etiqueta: l.filaHorario,
                    valor:
                        '${s.horario} · ${Formato.duracion(ruta.duracionMin)}',
                  ),
                  FilaDato(
                    icono: Icons.group,
                    etiqueta: l.filaPasajeros,
                    valor: l.personas(s.pasajeros),
                  ),
                  FilaDato(
                    icono: Icons.person,
                    etiqueta: l.filaResponsable,
                    valor: s.contacto.nombre,
                  ),
                ],
              ),
              const SizedBox(height: Espacios.e16),
              Text(l.serviciosAdicionales, style: tema.textTheme.titleMedium),
              const SizedBox(height: Espacios.e16),
              CargaFuturo<List<ServicioAdicional>>(
                futuro: _servicios,
                builder: (context, todos) => _Servicios(
                  servicios: [
                    for (final x in todos)
                      if (trajinera.serviciosIds.contains(x.id)) x,
                  ],
                  marcados: {for (final x in s.servicios) x.id},
                  idioma: idioma,
                  alMarcar: _enviando ? null : flujo.marcarServicio,
                ),
              ),
              const SizedBox(height: Espacios.e16),
              Text(l.desglose, style: tema.textTheme.titleMedium),
              const SizedBox(height: Espacios.e16),
              TarjetaDesglose(trajinera: trajinera.nombre, costos: costos),
              const SizedBox(height: Espacios.e16),
              TarjetaAviso(texto: l.politicaCancelacion),
              const SizedBox(height: Espacios.e16),
              Text(l.metodoPagoSimulado, style: tema.textTheme.titleMedium),
              const SizedBox(height: Espacios.e16),
              _MetodoPago(
                valor: s.metodoPago,
                alCambiar: _enviando ? null : flujo.elegirMetodoPago,
              ),
              const SizedBox(height: Espacios.e16),
              Text(
                l.pagoDemostracion,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BarraInferiorAccion(
          etiqueta: l.anticipo,
          valor: l.montoMxn(Formato.pesos(costos.anticipo)),
          valorDestacado: true,
          textoBoton: l.confirmar,
          cargando: _enviando,
          onPressed: _confirmar,
        ),
      ),
    );
  }
}

class _Servicios extends StatelessWidget {
  const _Servicios({
    required this.servicios,
    required this.marcados,
    required this.idioma,
    required this.alMarcar,
  });

  final List<ServicioAdicional> servicios;
  final Set<String> marcados;
  final String idioma;
  final void Function(ServicioAdicional, bool)? alMarcar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Espacios.e8),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: Radios.brMedium,
      ),
      child: servicios.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(Espacios.e8),
              child: Text(
                context.l10n.sinServiciosTrajinera,
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            )
          : Column(
              children: [
                for (final s in servicios)
                  _servicio(tema, s, marcados.contains(s.id)),
              ],
            ),
    );
  }

  Widget _servicio(ThemeData tema, ServicioAdicional s, bool marcado) {
    final cs = tema.colorScheme;
    final cambiar = alMarcar == null ? null : () => alMarcar!(s, !marcado);

    return MergeSemantics(
      child: InkWell(
        borderRadius: Radios.brSmall,
        onTap: cambiar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
          child: Row(
            children: [
              Checkbox(
                value: marcado,
                onChanged: cambiar == null ? null : (_) => cambiar(),
              ),
              const SizedBox(width: Espacios.e4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.nombre.resolver(idioma),
                      style: tema.textTheme.bodyLarge,
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
              const SizedBox(width: Espacios.e8),
              Text(
                Formato.pesos(s.precio),
                style: tema.textTheme.labelLarge?.copyWith(
                  color: marcado ? cs.primary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetodoPago extends StatelessWidget {
  const _MetodoPago({required this.valor, required this.alCambiar});

  final MetodoPago valor;
  final ValueChanged<MetodoPago>? alCambiar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    Widget opcion(MetodoPago m, IconData icono, String texto) => InkWell(
      borderRadius: Radios.brSmall,
      onTap: alCambiar == null ? null : () => alCambiar!(m),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        child: Row(
          children: [
            Radio<MetodoPago>(value: m, enabled: alCambiar != null),
            const SizedBox(width: 4),
            Icon(icono, size: 20, color: cs.onSurfaceVariant),
            const SizedBox(width: Espacios.e12),
            Expanded(child: Text(texto, style: tema.textTheme.bodyLarge)),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(Espacios.e8),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: Radios.brMedium,
      ),
      child: RadioGroup<MetodoPago>(
        groupValue: valor,
        onChanged: (m) {
          if (m != null) alCambiar?.call(m);
        },
        child: Column(
          children: [
            opcion(
              MetodoPago.tarjeta,
              Icons.payment,
              MetodoPago.tarjeta.texto(context.l10n),
            ),
            opcion(
              MetodoPago.spei,
              Icons.receipt_long,
              MetodoPago.spei.texto(context.l10n),
            ),
          ],
        ),
      ),
    );
  }
}
