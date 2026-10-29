import 'package:flutter/material.dart';

import '../../core/theme/espacios.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/fila_dato.dart';
import '../../widgets/icono_circular.dart';
import '../../widgets/imagen_tematica.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_aviso.dart';
import '../../widgets/tarjeta_ruta.dart';
import '../../widgets/tarjeta_trajinera.dart';

class GaleriaScreen extends StatefulWidget {
  const GaleriaScreen({super.key});

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
  bool _seleccionada = true;
  bool _cargando = false;
  bool _interruptor = true;

  static const _servicios =
      'Incluye chalecos, mesa y decoración · Extras: mariachi, cena, fotógrafo';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Galería de widgets')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Espacios.e16),
        children: [
          _Seccion(
            titulo: 'EtiquetaEstado',
            child: Wrap(
              spacing: Espacios.e8,
              runSpacing: Espacios.e8,
              children: [
                for (final estado in EstadoEtiqueta.values)
                  EtiquetaEstado(estado),
              ],
            ),
          ),
          _Seccion(
            titulo: 'IndicadorPasos',
            child: Column(
              children: [
                for (var paso = 1; paso <= 5; paso++) ...[
                  if (paso > 1) const SizedBox(height: Espacios.e24),
                  IndicadorPasos(paso: paso),
                ],
              ],
            ),
          ),
          _Seccion(
            titulo: 'IconoCircular',
            child: Row(
              children: [
                const IconoCircular(Icons.book),
                const SizedBox(width: Espacios.e16),
                const IconoCircular(
                  Icons.location_on,
                  estilo: EstiloIconoCircular.secundario,
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'IconoCircular en ListTile',
            sinMargen: true,
            child: Column(
              children: [
                ListTile(
                  leading: const IconoCircular(Icons.book),
                  title: const Text('Tradiciones y leyendas'),
                  subtitle: const Text(
                    'Historia del Día de Muertos y La Llorona',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                SwitchListTile(
                  secondary: const IconoCircular(Icons.notifications),
                  title: const Text('Recordatorios'),
                  subtitle: const Text('Un día antes de tu recorrido'),
                  value: _interruptor,
                  onChanged: (v) => setState(() => _interruptor = v),
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'ImagenTematica (6 temas + respaldo de Image.asset)',
            child: Column(
              children: [
                for (final tema in TemaImagen.values) ...[
                  ImagenTematica(tema: tema),
                  const SizedBox(height: Espacios.e12),
                ],
                const ImagenTematica(
                  tema: TemaImagen.animas,
                  rutaAsset: 'assets/images/no_existe.jpg',
                  alto: 120,
                  radio: Radios.brMedium,
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'TarjetaRuta',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TarjetaRuta(
                    nombre: 'Sendero de las Ánimas',
                    duracion: '2 h de recorrido',
                    precio: r'$250 MXN / persona',
                    salida: 'Nuevo Nativitas',
                    tema: TemaImagen.animas,
                    onTap: () {},
                    onElegir: () {},
                  ),
                ),
                const SizedBox(width: Espacios.e16),
                Expanded(
                  child: TarjetaRuta(
                    nombre: 'Noche de Cempasúchil',
                    duracion: '1.5 h de recorrido',
                    precio: r'$350 MXN / persona',
                    salida: 'Cuemanco',
                    tema: TemaImagen.cempasuchil,
                    onTap: () {},
                    onElegir: () {},
                  ),
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'TarjetaTrajinera',
            child: Column(
              children: [
                TarjetaTrajinera(
                  nombre: 'La Catrina',
                  capacidad: 'Hasta 20 personas',
                  tarifa: r'$1,200 / recorrido',
                  servicios: _servicios,
                  estado: _seleccionada
                      ? EstadoTrajinera.seleccionada
                      : EstadoTrajinera.normal,
                  onTap: () => setState(() => _seleccionada = !_seleccionada),
                ),
                const SizedBox(height: Espacios.e16),
                TarjetaTrajinera(
                  nombre: 'Flor de Cempasúchil',
                  capacidad: 'Hasta 15 personas',
                  tarifa: r'$1,000 / recorrido',
                  servicios: _servicios,
                  disponibilidad: EstadoEtiqueta.pocosLugares,
                  accesible: true,
                  onTap: () {},
                ),
                const SizedBox(height: Espacios.e16),
                const TarjetaTrajinera(
                  nombre: 'La Llorona',
                  capacidad: 'Hasta 8 personas',
                  tarifa: r'$800 / recorrido',
                  servicios: _servicios,
                  estado: EstadoTrajinera.deshabilitada,
                  disponibilidad: EstadoEtiqueta.sinServicio,
                  motivo: 'Capacidad insuficiente para 12 pasajeros',
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'FilaDato',
            child: Card(
              color: cs.surfaceContainerHigh,
              child: const Padding(
                padding: EdgeInsets.all(Espacios.e16),
                child: Column(
                  children: [
                    FilaDato(
                      icono: Icons.directions_boat,
                      etiqueta: 'Ruta',
                      valor: 'Sendero de las Ánimas',
                    ),
                    SizedBox(height: 10),
                    FilaDato(
                      icono: Icons.star,
                      etiqueta: 'Trajinera',
                      valor: 'La Catrina',
                    ),
                    SizedBox(height: 10),
                    FilaDato(
                      icono: Icons.event,
                      etiqueta: 'Fecha',
                      valor: 'Sáb 31 oct 2026',
                    ),
                    SizedBox(height: 10),
                    FilaDato(
                      icono: Icons.schedule,
                      etiqueta: 'Horario',
                      valor: '18:00 · 2 h',
                    ),
                    SizedBox(height: 10),
                    FilaDato(
                      icono: Icons.group,
                      etiqueta: 'Pasajeros',
                      valor: '12 personas',
                    ),
                    SizedBox(height: 10),
                    FilaDato(
                      icono: Icons.person,
                      etiqueta: 'Responsable',
                      valor: 'Lucía Hernández',
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _Seccion(
            titulo: 'TarjetaAviso',
            child: Column(
              children: [
                TarjetaAviso(
                  texto:
                      'Cancelación sin costo hasta 24 h antes: se '
                      'reembolsa el anticipo. Después de ese plazo el '
                      'anticipo no es reembolsable.',
                ),
                SizedBox(height: Espacios.e12),
                TarjetaAviso(
                  texto: 'Corrige los campos marcados para continuar.',
                  icono: Icons.lock,
                ),
                SizedBox(height: Espacios.e12),
                TarjetaAviso(
                  texto: 'Capacidad insuficiente para 12 pasajeros',
                  tipo: TipoAviso.error,
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'BarraInferiorAccion',
            sinMargen: true,
            child: Column(
              children: [
                BarraInferiorAccion(
                  etiqueta: 'Fecha y hora',
                  valor: 'Sáb 31 oct · 18:00',
                  textoBoton: 'Continuar',
                  onPressed: () {},
                ),
                const SizedBox(height: Espacios.e12),
                BarraInferiorAccion(
                  etiqueta: 'Anticipo',
                  valor: r'$1,500 MXN',
                  valorDestacado: true,
                  textoBoton: 'Confirmar',
                  cargando: _cargando,
                  onPressed: () async {
                    setState(() => _cargando = true);
                    await Future<void>.delayed(const Duration(seconds: 2));
                    if (mounted) setState(() => _cargando = false);
                  },
                ),
                const SizedBox(height: Espacios.e12),
                const BarraInferiorAccion(
                  textoBoton: 'Continuar',
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({
    required this.titulo,
    required this.child,
    this.sinMargen = false,
  });

  final String titulo;
  final Widget child;

  final bool sinMargen;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    const margen = EdgeInsets.symmetric(horizontal: Espacios.margenPantalla);

    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.e32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: margen,
            child: Text(
              titulo,
              style: tema.textTheme.titleSmall?.copyWith(
                color: tema.colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: Espacios.e12),
          Padding(padding: sinMargen ? EdgeInsets.zero : margen, child: child),
        ],
      ),
    );
  }
}
