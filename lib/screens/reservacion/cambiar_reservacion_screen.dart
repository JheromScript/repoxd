import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/reloj.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/reservas_controller.dart';
import '../reserva/fecha_horario_screen.dart';

class CambiarReservacionScreen extends StatefulWidget {
  const CambiarReservacionScreen({super.key, required this.folio});

  final String folio;

  @override
  State<CambiarReservacionScreen> createState() =>
      _CambiarReservacionScreenState();
}

class _CambiarReservacionScreenState extends State<CambiarReservacionScreen> {
  late final FlujoReservaController _flujo = FlujoReservaController(
    reloj: context.read<Reloj>(),
    catalogo: context.read<CatalogoRepository>(),
  );
  late final Future<bool> _listo = _preparar();

  Future<bool> _preparar() async {
    final reservas = context.read<ReservasController>();
    final catalogo = context.read<CatalogoRepository>();
    final r = reservas.todas.where((x) => x.folio == widget.folio).firstOrNull;
    if (r == null || !reservas.sePuedeCambiar(r)) return false;
    await _flujo.cargar();
    final ruta = (await catalogo.listarRutas())
        .where((x) => x.id == r.rutaId)
        .firstOrNull;
    final trajinera = (await catalogo.listarTrajineras())
        .where((x) => x.id == r.trajineraId)
        .firstOrNull;
    if (ruta == null || trajinera == null) return false;
    _flujo.iniciarCambio(r, ruta: ruta, trajinera: trajinera);
    return true;
  }

  @override
  void dispose() {
    _flujo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _listo,
      builder: (context, instantanea) {
        if (instantanea.data == true) {
          return ChangeNotifierProvider<FlujoReservaController>.value(
            value: _flujo,
            child: const FechaHorarioScreen(),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.cambiarReservacion)),
          body: Center(
            child: instantanea.connectionState == ConnectionState.done
                ? Padding(
                    padding: const EdgeInsets.all(Espacios.e24),
                    child: Text(
                      context.l10n.reservacionNoSePuedeCambiar,
                      textAlign: TextAlign.center,
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
