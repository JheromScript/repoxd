import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../state/preferencias_controller.dart';

Future<void> mostrarHojaAvisos(BuildContext context) {
  final preferencias = context.read<PreferenciasController>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
    builder: (_) => ChangeNotifierProvider.value(
      value: preferencias,
      child: const _ContenidoAvisos(),
    ),
  ).whenComplete(preferencias.marcarLeidos);
}

class _ContenidoAvisos extends StatelessWidget {
  const _ContenidoAvisos();

  static String _texto(AppLocalizations l, Aviso a) => switch (a.tipo) {
    TipoAviso.reservaCreada => l.avisoReservaCreada(a.folio),
    TipoAviso.pagoRecibido => l.avisoPagoRecibido(a.folio),
    TipoAviso.cancelacion => l.avisoCancelacion(a.folio),
    TipoAviso.cambio => l.avisoCambio(a.folio),
    TipoAviso.recordatorio => l.avisoRecordatorio(a.folio),
  };

  static IconData _icono(TipoAviso tipo) => switch (tipo) {
    TipoAviso.reservaCreada => Icons.confirmation_number,
    TipoAviso.pagoRecibido => Icons.check_circle,
    TipoAviso.cancelacion => Icons.cancel,
    TipoAviso.cambio => Icons.event,
    TipoAviso.recordatorio => Icons.notifications,
  };

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final avisos = context.watch<PreferenciasController>().avisos;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Espacios.e24,
                Espacios.e0,
                Espacios.e24,
                Espacios.e16,
              ),
              child: Text(
                context.l10n.avisos,
                style: tema.textTheme.headlineSmall,
              ),
            ),
            if (avisos.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Espacios.e24,
                  Espacios.e0,
                  Espacios.e24,
                  Espacios.e32,
                ),
                child: Text(
                  context.l10n.avisosVacio,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: Espacios.e16),
                  children: [
                    for (final a in avisos)
                      ListTile(
                        leading: Icon(
                          _icono(a.tipo),
                          color: a.leido ? cs.onSurfaceVariant : cs.primary,
                        ),
                        title: Text(
                          _texto(context.l10n, a),
                          style: tema.textTheme.bodyMedium,
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
