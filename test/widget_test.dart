import 'package:trajineras/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/theme/app_theme.dart';
import 'package:trajineras/screens/perfil/perfil_screen.dart';
import 'package:trajineras/screens/tradiciones/tradiciones_screen.dart';

import 'apoyo_app.dart';

void main() {
  testWidgets('Bienvenida lleva al shell con 4 pestañas y atrás regresa a '
      'Inicio', (tester) async {
    await tester.pumpWidget(appDePrueba());
    await tester.pumpAndSettle();

    expect(find.text('Comenzar'), findsOneWidget);
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    for (final pestana in ['Inicio', 'Rutas', 'Mis reservas', 'Perfil']) {
      expect(find.text(pestana), findsWidgets);
    }

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Perfil'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
  });

  testWidgets('el idioma de Bienvenida se aplica al momento', (tester) async {
    await tester.pumpWidget(appDePrueba());
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('en'));
  });

  Future<void> abrir(WidgetTester tester, Widget pantalla) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      appDePrueba(
        hijo: MaterialApp(
          theme: AppTheme.oscuro,
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: pantalla,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Tradiciones: el chip Galería desplaza hasta su sección', (
    tester,
  ) async {
    await abrir(tester, const TradicionesScreen());
    final titulo = find.text('Galería').last;
    expect(tester.getTopLeft(titulo).dy, greaterThan(800));

    await tester.tap(find.widgetWithText(FilterChip, 'Galería'));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(titulo).dy, lessThan(800));
  });

  testWidgets('Perfil: el diálogo valida el teléfono con 10 dígitos', (
    tester,
  ) async {
    await abrir(tester, const Scaffold(body: PerfilScreen()));

    await tester.tap(find.byTooltip('Editar perfil'));
    await tester.pumpAndSettle();

    final telefono = find.widgetWithText(TextFormField, 'Teléfono');
    await tester.enterText(telefono, '55123');
    await tester.pumpAndSettle();
    expect(find.text('El teléfono debe tener 10 dígitos'), findsOneWidget);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Editar perfil'), findsOneWidget);

    await tester.enterText(telefono, '5511223344');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Editar perfil'), findsNothing);
    expect(find.textContaining('55 1122 3344'), findsOneWidget);
  });
}
