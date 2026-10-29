import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/ruta.dart';
import '../../models/servicio_adicional.dart';
import '../../models/trajinera.dart';
import '../../services/disponibilidad.dart';
import '../../services/validadores.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/etiqueta_estado.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_aviso.dart';
import '../../widgets/tarjeta_trajinera.dart';
import '../../widgets/imagen_tematica.dart';
import '../../widgets/visor_imagenes.dart';
import 'comun_flujo.dart';

typedef _DatosTrajineras = (
  List<Trajinera>,
  Map<String, ServicioAdicional>,
  Disponibilidad,
);

enum _Filtro {
  todas,
  accesibles,
  grandes;

  String texto(AppLocalizations l) => switch (this) {
    _Filtro.todas => l.filtroTodas,
    _Filtro.accesibles => l.filtroAccesibles,
    _Filtro.grandes => l.filtroGrandes,
  };

  bool incluye(Trajinera t) => switch (this) {
    _Filtro.todas => true,
    _Filtro.accesibles => t.accesible,
    _Filtro.grandes => t.capacidad >= 15,
  };
}

class TrajineraScreen extends StatefulWidget {
  const TrajineraScreen({super.key});

  @override
  State<TrajineraScreen> createState() => _TrajineraScreenState();
}

class _TrajineraScreenState extends State<TrajineraScreen> {
  late Future<_DatosTrajineras> _datos;
  _Filtro _filtro = _Filtro.todas;

  @override
  void initState() {
    super.initState();
    _datos = _cargar();
  }

  void _continuar() => abrirPaso(
    context,
    RutasApp.fechaHorario,
    alVolver: () => setState(() {
      _datos = _cargar();
    }),
  );

  Future<_DatosTrajineras> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final reservas = context.read<ReservasController>();
    final trajineras = await catalogo.listarTrajineras();
    final servicios = await catalogo.listarServicios();
    final disp = await reservas.disponibilidad();
    return (trajineras, {for (final s in servicios) s.id: s}, disp);
  }

  @override
  Widget build(BuildContext context) {
    final flujo = context.watch<FlujoReservaController>();
    final ruta = flujo.ruta;
    final l = context.l10n;
    if (ruta == null) {
      return FlujoIncompleto(titulo: l.eligeTuTrajinera);
    }

    final trajinera = flujo.trajinera;
    final pasajeros = l.pasajeros(flujo.pasajeros);

    return Scaffold(
      appBar: barraPaso(context, l.eligeTuTrajinera),
      body: ContenidoCentrado(
        child: CargaFuturo<_DatosTrajineras>(
          futuro: _datos,
          builder: (context, datos) => _Lista(
            ruta: ruta,
            trajineras: datos.$1,
            servicios: datos.$2,
            disponibilidad: datos.$3,
            filtro: _filtro,
            alFiltrar: (f) => setState(() => _filtro = f),
          ),
        ),
      ),
      bottomNavigationBar: BarraInferiorAccion(
        etiqueta: trajinera == null ? l.pasajerosEtiqueta : l.seleccionada,
        valor: trajinera == null
            ? pasajeros
            : '${trajinera.nombre} · $pasajeros',
        textoBoton: l.continuar,
        onPressed: trajinera == null ? null : _continuar,
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  const _Lista({
    required this.ruta,
    required this.trajineras,
    required this.servicios,
    required this.disponibilidad,
    required this.filtro,
    required this.alFiltrar,
  });

  final Ruta ruta;
  final List<Trajinera> trajineras;
  final Map<String, ServicioAdicional> servicios;
  final Disponibilidad disponibilidad;
  final _Filtro filtro;
  final ValueChanged<_Filtro> alFiltrar;

  @override
  Widget build(BuildContext context) {
    final flujo = context.watch<FlujoReservaController>();
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final l = context.l10n;
    final n = flujo.pasajeros;
    final visibles = trajineras.where(filtro.incluye).toList();
    final hayLugar = visibles.any((t) => trajineraElegible(t, n));

    return ListView(
      padding: margenPaso,
      children: [
        const IndicadorPasos(paso: 1),
        const SizedBox(height: Espacios.e16),
        _Pasajeros(
          valor: n,
          onCambio: context.read<FlujoReservaController>().cambiarPasajeros,
        ),
        const SizedBox(height: Espacios.e16),
        Wrap(
          spacing: Espacios.e8,
          runSpacing: Espacios.e8,
          children: [
            for (final f in _Filtro.values)
              FilterChip(
                label: Text(f.texto(l)),
                selected: f == filtro,
                onSelected: (_) => alFiltrar(f),
              ),
          ],
        ),
        if (!hayLugar) ...[
          const SizedBox(height: Espacios.e16),
          TarjetaAviso(
            texto: filtro == _Filtro.todas
                ? l.ningunaTrajineraLugar(l.pasajeros(n))
                : l.ningunaTrajineraFiltroLugar(
                    filtro.texto(l),
                    l.pasajeros(n),
                  ),
          ),
        ],
        for (final t in visibles) ...[
          const SizedBox(height: Espacios.e16),
          _tarjeta(context, flujo, t, idioma),
        ],
      ],
    );
  }

  Widget _tarjeta(
    BuildContext context,
    FlujoReservaController flujo,
    Trajinera t,
    String idioma,
  ) {
    final l = context.l10n;
    final n = flujo.pasajeros;
    final String? motivo = trajineraElegible(t, n)
        ? null
        : !t.activa
        ? l.motivoMantenimiento
        : l.motivoCapacidad(l.pasajeros(n));

    return TarjetaTrajinera(
      nombre: t.nombre,
      capacidad: l.hastaPersonas(t.capacidad),
      tarifa: l.tarifaPorRecorrido(Formato.pesos(t.tarifa)),
      servicios: _textoServicios(l, t, idioma),
      accesible: t.accesible,
      rutaImagen: t.imagen,
      heroTag: 'trajinera-${t.id}',
      onVerFoto: () => abrirVisorImagenes(
        context,
        imagenes: [
          ImagenVisor(
            tema: TemaImagen.trajinera,
            rutaAsset: t.imagen,
            etiqueta: t.nombre,
            heroTag: 'trajinera-${t.id}',
          ),
        ],
      ),
      disponibilidad: switch (disponibilidad.etiqueta(t, ruta)) {
        EtiquetaTrajinera.disponible => EstadoEtiqueta.disponible,
        EtiquetaTrajinera.pocosLugares => EstadoEtiqueta.pocosLugares,
        EtiquetaTrajinera.sinServicio => EstadoEtiqueta.sinServicio,
      },
      estado: motivo != null
          ? EstadoTrajinera.deshabilitada
          : flujo.trajinera?.id == t.id
          ? EstadoTrajinera.seleccionada
          : EstadoTrajinera.normal,
      motivo: motivo,
      onTap: () => flujo.elegirTrajinera(t),
    );
  }

  String _textoServicios(AppLocalizations l, Trajinera t, String idioma) {
    String minuscula(String s) =>
        s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

    final nota = t.notaAccesibilidad?.resolver(idioma);
    final extras = [
      for (final id in t.serviciosIds)
        if (servicios[id] case final s?) minuscula(s.nombre.resolver(idioma)),
    ];
    final incluye = [for (final i in t.incluye) minuscula(i.resolver(idioma))];
    return [
      if (nota != null)
        nota.endsWith('.') ? nota.substring(0, nota.length - 1) : nota,
      l.trajineraIncluye(l.enLista(incluye)),
      if (extras.isNotEmpty) l.trajineraExtras(extras.join(', ')),
    ].join(' · ');
  }
}

class _Pasajeros extends StatelessWidget {
  const _Pasajeros({required this.valor, required this.onCambio});

  final int valor;
  final ValueChanged<int> onCambio;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final l = context.l10n;

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: Radios.brMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.pasajerosEtiqueta, style: tema.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  l.deshabilitamosMenorCapacidad,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Espacios.e12),
          IconButton.outlined(
            tooltip: l.quitarPasajero,
            icon: const Icon(Icons.remove),
            onPressed: valor > 1 ? () => onCambio(valor - 1) : null,
          ),
          SizedBox(
            width: 36,
            child: Semantics(
              liveRegion: true,
              label: l.pasajeros(valor),
              excludeSemantics: true,
              child: Text(
                '$valor',
                textAlign: TextAlign.center,
                style: tema.textTheme.titleLarge,
              ),
            ),
          ),
          IconButton.filled(
            tooltip: l.agregarPasajero,
            icon: const Icon(Icons.add),
            onPressed: valor < maxPasajeros ? () => onCambio(valor + 1) : null,
          ),
        ],
      ),
    );
  }
}
