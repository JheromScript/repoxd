import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/l10n.dart';
import '../../widgets/contenido_centrado.dart';
import '../inicio/inicio_screen.dart';
import '../perfil/perfil_screen.dart';
import '../reservacion/mis_reservaciones_screen.dart';
import '../rutas/rutas_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  static const int pestanaInicio = 0;
  static const int pestanaRutas = 1;
  static const int pestanaReservas = 2;
  static const int pestanaPerfil = 3;

  /// La instancia montada; `app.dart` la crea con esta llave para que las
  /// pantallas empujadas encima puedan volver a una pestaña.
  static final GlobalKey<ShellScreenState> llave = GlobalKey();

  static void irA(BuildContext context, int pestana) {
    context.findAncestorStateOfType<ShellScreenState>()?.irA(pestana);
  }

  static void mostrar(BuildContext context, int pestana) {
    Navigator.of(context).popUntil(ModalRoute.withName(RutasApp.shell));
    llave.currentState?.irA(pestana);
  }

  @override
  State<ShellScreen> createState() => ShellScreenState();
}

class ShellScreenState extends State<ShellScreen> {
  int _indice = ShellScreen.pestanaInicio;

  void irA(int pestana) => setState(() => _indice = pestana);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: _indice == ShellScreen.pestanaInicio,
      onPopInvokedWithResult: (seCerro, _) {
        if (!seCerro) irA(ShellScreen.pestanaInicio);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _indice,
          children: const [
            InicioScreen(),
            RutasScreen(),
            MisReservacionesScreen(),
            PerfilScreen(),
          ],
        ),
        bottomNavigationBar: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: ContenidoCentrado(
            ajustarAlto: true,
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              selectedIndex: _indice,
              onDestinationSelected: irA,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home),
                  label: l.navInicio,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.directions_boat),
                  label: l.navRutas,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.confirmation_number),
                  label: l.navReservas,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person),
                  label: l.navPerfil,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
