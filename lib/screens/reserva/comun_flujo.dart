import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../shell/shell_screen.dart';

AppBar barraPaso(BuildContext context, String titulo) => AppBar(
  title: Text(titulo),
  actions: [
    IconButton(
      tooltip: context.l10n.tooltipSeguridad,
      icon: const Icon(Icons.help),
      onPressed: () => Navigator.of(context).pushNamed(RutasApp.seguridad),
    ),
  ],
);

/// Abre el paso [ruta] y, al volver, llama a [alVolver] para recargar la
/// ocupación (otra persona pudo reservar mientras tanto). Si se confirmó,
/// esta pantalla ya salió de la pila y no se recarga nada.
Future<void> abrirPaso(
  BuildContext context,
  String ruta, {
  required VoidCallback alVolver,
}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  await Navigator.of(context).pushNamed(ruta);
  if (context.mounted && ModalRoute.of(context)?.isActive == true) alVolver();
}

const EdgeInsets margenPaso = EdgeInsets.fromLTRB(
  Espacios.margenPantalla,
  Espacios.e8,
  Espacios.margenPantalla,
  Espacios.e24,
);

/// Se muestra si un paso se abre sin el dato que necesita del borrador (al
/// confirmar se limpia mientras las pantallas del flujo salen de la pila).
class FlujoIncompleto extends StatelessWidget {
  const FlujoIncompleto({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Espacios.e24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.flujoIncompleto,
                style: tema.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Espacios.e16),
              FilledButton(
                onPressed: () =>
                    ShellScreen.mostrar(context, ShellScreen.pestanaInicio),
                child: Text(context.l10n.irAInicio),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
