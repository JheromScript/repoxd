import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../models/reservacion.dart';
import '../../models/ruta.dart';
import '../../models/servicio_adicional.dart';
import '../../models/trajinera.dart';
import '../../services/calculo_costos.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/fila_dato.dart';
import '../../widgets/tarjeta_aviso.dart';
import '../../widgets/tarjeta_desglose.dart';
import '../../widgets/tarjeta_folio.dart';
import '../../widgets/tarjeta_punto_encuentro.dart';
import '../../widgets/tarjeta_reservacion.dart';

typedef _Catalogo = (
  List<Ruta>,
  List<Trajinera>,
  List<ServicioAdicional>,
  List<Embarcadero>,
);

class DetalleReservacionScreen extends StatefulWidget {
  const DetalleReservacionScreen({super.key, required this.folio});

  final String folio;

  @override
  State<DetalleReservacionScreen> createState() =>
      _DetalleReservacionScreenState();
}

class _DetalleReservacionScreenState extends State<DetalleReservacionScreen> {
  late final Future<_Catalogo> _catalogo = _cargar();

  Future<_Catalogo> _cargar() async {
    final c = context.read<CatalogoRepository>();
    return (
      await c.listarRutas(),
      await c.listarTrajineras(),
      await c.listarServicios(),
      await c.listarEmbarcaderos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.select<ReservasController, Reservacion?>(
      (c) => c.todas.where((x) => x.folio == widget.folio).firstOrNull,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.detalleReservacionTitulo)),
      body: r == null
          ? Center(child: Text(context.l10n.reservacionNoEncontrada))
          : ContenidoCentrado(
              child: CargaFuturo<_Catalogo>(
                futuro: _catalogo,
                builder: (context, catalogo) =>
                    _Cuerpo(reservacion: r, catalogo: catalogo),
              ),
            ),
    );
  }
}

class _Cuerpo extends StatelessWidget {
  const _Cuerpo({required this.reservacion, required this.catalogo});

  final Reservacion reservacion;
  final _Catalogo catalogo;

  @override
  Widget build(BuildContext context) {
    final r = reservacion;
    final l = context.l10n;
    final (rutas, trajineras, servicios, embarcaderos) = catalogo;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final ruta = rutas.where((x) => x.id == r.rutaId).firstOrNull;
    final trajinera = trajineras
        .where((x) => x.id == r.trajineraId)
        .firstOrNull;
    final embarcadero = embarcaderos
        .where((e) => e.id == ruta?.embarcaderoId)
        .firstOrNull;
    final contratados = [
      for (final id in r.serviciosIds)
        servicios
                .where((s) => s.id == id)
                .firstOrNull
                ?.nombre
                .resolver(idioma) ??
            id,
    ];
    final nombreTrajinera = trajinera?.nombre ?? r.trajineraId;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Espacios.margenPantalla,
        Espacios.e8,
        Espacios.margenPantalla,
        Espacios.e24,
      ),
      children: [
        TarjetaFolio(
          folio: r.folio,
          estado: EstadoEtiqueta.deReservacion(r.estado),
        ),
        if (r.estado == EstadoReservacion.cancelada) ...[
          const SizedBox(height: Espacios.e16),
          TarjetaAviso(
            texto: r.montoReembolsado > 0
                ? l.detalleCanceladaReembolso(Formato.pesos(r.montoReembolsado))
                : l.detalleCancelada,
          ),
        ],
        const SizedBox(height: Espacios.e16),
        TarjetaReservacion(
          filas: [
            FilaDato(
              icono: Icons.directions_boat,
              etiqueta: l.filaRuta,
              valor: ruta?.nombre.resolver(idioma) ?? r.rutaId,
            ),
            FilaDato(
              icono: Icons.star,
              etiqueta: l.filaTrajinera,
              valor: nombreTrajinera,
            ),
            FilaDato(
              icono: Icons.event,
              etiqueta: l.filaFecha,
              valor: Formato.fechaConAnio(
                DateTime.parse(r.fecha),
                idioma: idioma,
              ),
            ),
            FilaDato(
              icono: Icons.schedule,
              etiqueta: l.filaHorario,
              valor: ruta == null
                  ? r.horario
                  : '${r.horario} · ${Formato.duracion(ruta.duracionMin)}',
            ),
            FilaDato(
              icono: Icons.group,
              etiqueta: l.filaPasajeros,
              valor: l.personas(r.pasajeros),
            ),
            FilaDato(
              icono: Icons.person,
              etiqueta: l.filaResponsable,
              valor: r.contacto.nombre,
            ),
            FilaDato(
              icono: Icons.add_circle,
              etiqueta: l.filaServicios,
              valor: contratados.isEmpty ? l.ninguno : contratados.join(', '),
            ),
            FilaDato(
              icono: Icons.payment,
              etiqueta: l.filaPago,
              valor: switch (r.metodoPago) {
                MetodoPago.tarjeta => l.pagoTarjetaSimulado,
                MetodoPago.spei => l.pagoSpeiSimulado,
                null => '—',
              },
            ),
          ],
        ),
        const SizedBox(height: Espacios.e16),
        TarjetaDesglose(
          trajinera: nombreTrajinera,
          costos: Costos.deReservacion(r),
          tituloAnticipo: switch (r.estado) {
            EstadoReservacion.pendiente => l.anticipoPorPagar,
            EstadoReservacion.pagada => l.anticipoPagado30,
            EstadoReservacion.cancelada => l.anticipo30,
          },
        ),
        if (embarcadero != null) ...[
          const SizedBox(height: Espacios.e16),
          TarjetaPuntoEncuentro(
            embarcadero: embarcadero.nombre,
            muelle: embarcadero.muelle.resolver(idioma),
            horario: r.horario,
          ),
        ],
      ],
    );
  }
}
