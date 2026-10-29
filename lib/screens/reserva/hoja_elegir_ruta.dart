import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../models/ruta.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/imagen_tematica.dart';
import '../rutas/elegir_ruta.dart';

void reservarAhora(BuildContext context) {
  if (context.read<FlujoReservaController>().ruta != null) {
    Navigator.of(context).pushNamed(RutasApp.reservar);
    return;
  }
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
    builder: (_) => _HojaElegirRuta(
      // La hoja se cierra antes de navegar: se usa el contexto de Inicio.
      alElegir: (ruta) => elegirRuta(context, ruta),
    ),
  );
}

typedef _DatosHoja = (List<Ruta>, List<Embarcadero>);

class _HojaElegirRuta extends StatefulWidget {
  const _HojaElegirRuta({required this.alElegir});

  final ValueChanged<Ruta> alElegir;

  @override
  State<_HojaElegirRuta> createState() => _HojaElegirRutaState();
}

class _HojaElegirRutaState extends State<_HojaElegirRuta> {
  late final Future<_DatosHoja> _datos = _cargar();

  Future<_DatosHoja> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final rutas = await catalogo.listarRutas();
    final embarcaderos = await catalogo.listarEmbarcaderos();
    return (rutas, embarcaderos);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Espacios.e24,
          0,
          Espacios.e24,
          Espacios.e24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.queRuta, style: tema.textTheme.headlineSmall),
            const SizedBox(height: Espacios.e4),
            Text(
              context.l10n.eligeRutaEmpezar,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Espacios.e16),
            CargaFuturo<_DatosHoja>(
              futuro: _datos,
              builder: (context, datos) => Column(
                children: [
                  for (final (i, ruta) in datos.$1.indexed) ...[
                    if (i > 0) const SizedBox(height: Espacios.e12),
                    _OpcionRuta(
                      ruta: ruta,
                      embarcadero: datos.$2
                          .where((e) => e.id == ruta.embarcaderoId)
                          .firstOrNull,
                      idioma: idioma,
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.alElegir(ruta);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionRuta extends StatelessWidget {
  const _OpcionRuta({
    required this.ruta,
    required this.embarcadero,
    required this.idioma,
    required this.onTap,
  });

  final Ruta ruta;
  final Embarcadero? embarcadero;
  final String idioma;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final datos = [
      Formato.duracion(ruta.duracionMin),
      context.l10n.precioPorPersona(Formato.pesos(ruta.precioPorPersona)),
      ?embarcadero?.nombre,
    ].join(' · ');

    return Material(
      color: cs.surfaceContainer,
      borderRadius: Radios.brMedium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Espacios.e12),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: ImagenTematica(
                  tema: TemaImagen.values.byName(ruta.tema),
                  rutaAsset: ruta.imagen,
                  alto: 72,
                  radio: Radios.brSmall,
                ),
              ),
              const SizedBox(width: Espacios.e12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ruta.etiqueta.resolver(idioma),
                      style: tema.textTheme.labelSmall?.copyWith(
                        color: cs.tertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ruta.nombre.resolver(idioma),
                      style: tema.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      datos,
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.e8),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
