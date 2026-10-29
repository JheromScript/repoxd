import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/icono_svg.dart';
import '../../state/preferencias_controller.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final preferencias = context.watch<PreferenciasController>();

    final colores = [cs.primary, cs.tertiary, cs.secondary];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.surfaceContainerHigh,
              cs.surfaceContainerLow,
              cs.surface,
            ],
            stops: const [0, 0.55, 1],
          ),
        ),
        child: SafeArea(
          child: ContenidoCentrado(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Espacios.e16,
                          Espacios.e8,
                          Espacios.e16,
                          Espacios.e0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < 7; i++)
                              IconoSvg(
                                IconoPropio.flor,
                                tamano: 28,
                                color: colores[i % colores.length],
                              ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Espacios.e24,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 132,
                              height: 132,
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(color: cs.primary, width: 3),
                              ),
                              alignment: Alignment.center,
                              child: ExcludeSemantics(
                                child: IconoSvg(
                                  IconoPropio.calavera,
                                  tamano: 72,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(height: Espacios.e16),
                            Text(
                              'Trajineras',
                              style: tema.textTheme.displayMedium?.copyWith(
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(height: Espacios.e16),
                            Text(
                              context.l10n.bienvenidaSubtitulo,
                              style: tema.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Espacios.e16),
                            Text(
                              context.l10n.bienvenidaLema,
                              style: tema.textTheme.bodyLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Espacios.e24,
                          Espacios.e0,
                          Espacios.e24,
                          Espacios.e40,
                        ),
                        child: Column(
                          children: [
                            Text(
                              context.l10n.bienvenidaIdioma,
                              style: tema.textTheme.labelMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: Espacios.e16),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'es',
                                  label: Text('Español'),
                                ),
                                ButtonSegment(
                                  value: 'en',
                                  label: Text('English'),
                                ),
                              ],
                              selected: {preferencias.idioma},
                              onSelectionChanged: (s) => context
                                  .read<PreferenciasController>()
                                  .cambiarIdioma(s.first),
                            ),
                            const SizedBox(height: Espacios.e16),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: AppTheme.estiloBotonL(),
                                onPressed: () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                      RutasApp.shell,
                                      (_) => false,
                                    ),
                                child: Text(context.l10n.comenzar),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
