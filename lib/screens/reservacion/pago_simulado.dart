import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../state/reservas_controller.dart';

Future<bool> simularPago(BuildContext context, String folio) async {
  final reservas = context.read<ReservasController>();
  final navegador = Navigator.of(context);
  final mensajero = ScaffoldMessenger.of(context);
  final l = context.l10n;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Semantics(
          liveRegion: true,
          child: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: Espacios.e24),
              Expanded(child: Text(context.l10n.procesandoPago)),
            ],
          ),
        ),
      ),
    ),
  );

  var pagado = true;
  try {
    await Future.wait([
      reservas.pagar(folio),
      Future<void>.delayed(const Duration(milliseconds: 800)),
    ]);
  } on ReservaException {
    pagado = false;
  } finally {
    navegador.pop();
  }
  mensajero.showSnackBar(
    SnackBar(content: Text(pagado ? l.anticipoPagadoMsg : l.noSePudoPagar)),
  );
  return pagado;
}
