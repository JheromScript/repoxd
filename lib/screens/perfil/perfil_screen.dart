import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/hoja_aviso_privacidad.dart';
import '../../widgets/icono_circular.dart';
import '../../widgets/item_lista.dart';
import 'dialogo_editar_perfil.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Future<void> _verAvisoPrivacidad(BuildContext context) async {
    final catalogo = context.read<CatalogoRepository>();
    final idioma = context.read<PreferenciasController>().idioma;
    final contenido = await catalogo.obtenerContenido();
    if (!context.mounted) return;
    await mostrarAvisoPrivacidad(
      context,
      contenido.avisoPrivacidad.resolver(idioma),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final preferencias = context.watch<PreferenciasController>();
    final perfil = preferencias.perfil;

    void editar() => mostrarDialogoEditarPerfil(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.perfilTitulo),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: context.l10n.editarPerfil,
            icon: const Icon(Icons.edit),
            onPressed: editar,
          ),
        ],
      ),
      body: ContenidoCentrado(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.margenPantalla,
            Espacios.e8,
            Espacios.margenPantalla,
            Espacios.e24,
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.primary, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Formato.iniciales(perfil.nombre),
                    style: tema.textTheme.titleLarge?.copyWith(
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: Espacios.e16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        perfil.nombre,
                        style: tema.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        perfil.correo,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacios.e20),
            _Seccion(context.l10n.datosPersonales),
            _Tarjeta(
              children: [
                ItemLista(
                  icono: Icons.person,
                  titulo: context.l10n.nombreYTelefono,
                  detalle:
                      '${perfil.nombre} · ${Formato.telefono(perfil.telefono)}',
                  conFlecha: true,
                  onTap: editar,
                ),
                ItemLista(
                  icono: Icons.mail,
                  titulo: context.l10n.correoElectronico,
                  detalle: perfil.correo,
                  conFlecha: true,
                  onTap: editar,
                ),
              ],
            ),
            const SizedBox(height: Espacios.e20),
            _Seccion(context.l10n.preferencias),
            _Tarjeta(
              children: [
                _FilaIdioma(
                  idioma: preferencias.idioma,
                  onCambio: preferencias.cambiarIdioma,
                ),
                ItemLista(
                  icono: Icons.notifications,
                  titulo: context.l10n.notificaciones,
                  detalle: context.l10n.notificacionesDetalle,
                  trailing: Switch(
                    value: preferencias.notificaciones,
                    onChanged: preferencias.cambiarNotificaciones,
                  ),
                ),
                ItemLista(
                  icono: Icons.event,
                  titulo: context.l10n.recordatorios,
                  detalle: context.l10n.recordatoriosDetalle,
                  trailing: Switch(
                    value: preferencias.recordatorios,
                    onChanged: preferencias.cambiarRecordatorios,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacios.e20),
            _Seccion(context.l10n.privacidadYAyuda),
            _Tarjeta(
              children: [
                ItemLista(
                  icono: Icons.lock,
                  titulo: context.l10n.avisoPrivacidad,
                  detalle: context.l10n.avisoPrivacidadDetalle,
                  conFlecha: true,
                  onTap: () => _verAvisoPrivacidad(context),
                ),
                ItemLista(
                  icono: Icons.help,
                  titulo: context.l10n.seguridadFaq,
                  conFlecha: true,
                  onTap: () =>
                      Navigator.of(context).pushNamed(RutasApp.seguridad),
                ),
              ],
            ),
            const SizedBox(height: Espacios.e20),
            GestureDetector(
              onLongPress: kDebugMode
                  ? () => Navigator.of(context).pushNamed(RutasApp.galeria)
                  : null,
              child: Text(
                context.l10n.versionApp,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.e8),
      child: Text(
        titulo,
        style: tema.textTheme.labelLarge?.copyWith(
          color: tema.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _FilaIdioma extends StatelessWidget {
  const _FilaIdioma({required this.idioma, required this.onCambio});

  final String idioma;
  final ValueChanged<String> onCambio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.e16,
        vertical: Espacios.e12,
      ),
      child: Row(
        children: [
          const IconoCircular(Icons.language, tamanoIcono: 22),
          const SizedBox(width: Espacios.e16),
          Expanded(
            child: Text(
              context.l10n.idioma,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'es', label: Text('ES')),
              ButtonSegment(value: 'en', label: Text('EN')),
            ],
            selected: {idioma},
            onSelectionChanged: (s) => onCambio(s.first),
          ),
        ],
      ),
    );
  }
}
