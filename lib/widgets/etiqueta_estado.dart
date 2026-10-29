import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import '../models/reservacion.dart';

enum EstadoEtiqueta {
  disponible,
  pocosLugares,
  sinServicio,
  pendiente,
  pagada,
  cancelada;

  String texto(AppLocalizations l) => switch (this) {
    disponible => l.estadoDisponible,
    pocosLugares => l.estadoPocosLugares,
    sinServicio => l.estadoSinServicio,
    pendiente => l.estadoPendiente,
    pagada => l.estadoPagada,
    cancelada => l.estadoCancelada,
  };

  static EstadoEtiqueta deReservacion(EstadoReservacion estado) =>
      switch (estado) {
        EstadoReservacion.pagada => EstadoEtiqueta.pagada,
        EstadoReservacion.pendiente => EstadoEtiqueta.pendiente,
        EstadoReservacion.cancelada => EstadoEtiqueta.cancelada,
      };
}

class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado(this.estado, {super.key, this.texto});

  final EstadoEtiqueta estado;

  final String? texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final ce = tema.extension<ColoresEstado>()!;

    final (fondo, punto, letra) = switch (estado) {
      EstadoEtiqueta.disponible || EstadoEtiqueta.pagada => (
        ce.successContainer,
        ce.success,
        ce.onSuccessContainer,
      ),
      EstadoEtiqueta.pocosLugares => (
        ce.warningContainer,
        ce.warning,
        ce.onWarningContainer,
      ),
      EstadoEtiqueta.sinServicio => (
        ce.neutralContainer,
        ce.onNeutralContainer,
        ce.onNeutralContainer,
      ),
      EstadoEtiqueta.pendiente => (
        cs.tertiaryContainer,
        cs.tertiary,
        cs.onTertiaryContainer,
      ),
      EstadoEtiqueta.cancelada => (
        cs.errorContainer,
        cs.error,
        cs.onErrorContainer,
      ),
    };

    return Container(
      height: 24,
      padding: const EdgeInsets.only(left: Espacios.e8, right: 10),
      decoration: BoxDecoration(color: fondo, borderRadius: Radios.brFull),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: punto, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            texto ?? estado.texto(context.l10n),
            style: tema.textTheme.labelMedium?.copyWith(color: letra),
          ),
        ],
      ),
    );
  }
}
