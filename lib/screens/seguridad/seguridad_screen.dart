import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enlaces.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/contenido.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/icono_circular.dart';

class SeguridadScreen extends StatefulWidget {
  const SeguridadScreen({super.key});

  @override
  State<SeguridadScreen> createState() => _SeguridadScreenState();
}

class _SeguridadScreenState extends State<SeguridadScreen> {
  late final Future<Contenido> _contenido = context
      .read<CatalogoRepository>()
      .obtenerContenido();

  static const List<IconData> _iconosReglas = [
    Icons.shield,
    Icons.accessibility_new,
    Icons.group,
    Icons.close,
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.seguridadTitulo)),
      body: CargaFuturo<Contenido>(
        futuro: _contenido,
        builder: (context, contenido) => ContenidoCentrado(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Espacios.margenPantalla,
              Espacios.e8,
              Espacios.margenPantalla,
              Espacios.e24,
            ),
            children: [
              Text(
                context.l10n.reglasNavegacion,
                style: tema.textTheme.titleMedium,
              ),
              const SizedBox(height: Espacios.e16),
              Container(
                padding: const EdgeInsets.all(Espacios.e16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: Radios.brMedium,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < contenido.reglas.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _Regla(
                        icono: _iconosReglas[i % _iconosReglas.length],
                        titulo: contenido.reglas[i].titulo.resolver(idioma),
                        detalle: contenido.reglas[i].detalle.resolver(idioma),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Espacios.e16),
              Text(
                context.l10n.preguntasFrecuentes,
                style: tema.textTheme.titleMedium,
              ),
              const SizedBox(height: Espacios.e16),
              if (contenido.preguntas.isEmpty)
                Text(
                  context.l10n.preguntasVacio,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              for (var i = 0; i < contenido.preguntas.length; i++) ...[
                if (i > 0) const SizedBox(height: Espacios.e8),
                _Pregunta(
                  pregunta: contenido.preguntas[i].pregunta.resolver(idioma),
                  respuesta: contenido.preguntas[i].respuesta.resolver(idioma),
                  expandida: i == 0,
                ),
              ],
              const SizedBox(height: Espacios.e16),
              _Ayuda(contenido: contenido, idioma: idioma),
            ],
          ),
        ),
      ),
    );
  }
}

class _Regla extends StatelessWidget {
  const _Regla({
    required this.icono,
    required this.titulo,
    required this.detalle,
  });

  final IconData icono;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconoCircular(
          icono,
          estilo: EstiloIconoCircular.secundario,
          lado: 36,
          tamanoIcono: 20,
        ),
        const SizedBox(width: Espacios.e12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: tema.textTheme.labelLarge),
              const SizedBox(height: 2),
              Text(
                detalle,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pregunta extends StatelessWidget {
  const _Pregunta({
    required this.pregunta,
    required this.respuesta,
    required this.expandida,
  });

  final String pregunta;
  final String respuesta;
  final bool expandida;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    const forma = RoundedRectangleBorder(borderRadius: Radios.brMedium);

    return ExpansionTile(
      initiallyExpanded: expandida,
      backgroundColor: cs.surfaceContainerHigh,
      collapsedBackgroundColor: cs.surfaceContainer,
      shape: forma,
      collapsedShape: forma,
      iconColor: cs.onSurface,
      collapsedIconColor: cs.onSurface,
      tilePadding: const EdgeInsets.symmetric(horizontal: Espacios.e16),
      childrenPadding: const EdgeInsets.fromLTRB(
        Espacios.e16,
        Espacios.e0,
        Espacios.e16,
        Espacios.e16,
      ),
      expandedAlignment: Alignment.centerLeft,
      title: Text(pregunta, style: tema.textTheme.labelLarge),
      children: [
        Text(
          respuesta,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Ayuda extends StatelessWidget {
  const _Ayuda({required this.contenido, required this.idioma});

  final Contenido contenido;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.e16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.necesitasAyuda, style: tema.textTheme.labelLarge),
            const SizedBox(height: Espacios.e12),
            Text(
              contenido.horarioAtencion.resolver(idioma),
              style: tema.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Espacios.e12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => Enlaces.abrir(
                      context,
                      Enlaces.llamada(contenido.telefonoContacto),
                    ),
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(context.l10n.llamar),
                  ),
                ),
                const SizedBox(width: Espacios.e12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Enlaces.abrir(
                      context,
                      Enlaces.correo(contenido.correoContacto),
                    ),
                    icon: const Icon(Icons.mail, size: 18),
                    label: Text(context.l10n.correo),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
