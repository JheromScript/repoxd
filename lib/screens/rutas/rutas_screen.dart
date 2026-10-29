import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/embarcadero.dart';
import '../../models/ruta.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/imagen_tematica.dart';
import '../../widgets/tarjeta_ruta.dart';
import 'elegir_ruta.dart';

typedef _DatosRutas = (List<Ruta>, List<Embarcadero>);

const double _anchoDosColumnas = 340;

class RutasScreen extends StatefulWidget {
  const RutasScreen({super.key});

  @override
  State<RutasScreen> createState() => _RutasScreenState();
}

class _RutasScreenState extends State<RutasScreen> {
  late final Future<_DatosRutas> _datos = _cargar();

  Future<_DatosRutas> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final rutas = await catalogo.listarRutas();
    final embarcaderos = await catalogo.listarEmbarcaderos();
    return (rutas, embarcaderos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.rutasTitulo),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: context.l10n.tooltipSeguridad,
            icon: const Icon(Icons.help_outline),
            onPressed: () =>
                Navigator.of(context).pushNamed(RutasApp.seguridad),
          ),
        ],
      ),
      body: CargaFuturo<_DatosRutas>(
        futuro: _datos,
        builder: (context, datos) => ContenidoCentrado(
          child: _Contenido(rutas: datos.$1, embarcaderos: datos.$2),
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.rutas, required this.embarcaderos});

  final List<Ruta> rutas;
  final List<Embarcadero> embarcaderos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final l = context.l10n;
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    if (rutas.isEmpty) return _Vacio(texto: l.rutasVacio);

    String salida(Ruta r) =>
        embarcaderos
            .where((e) => e.id == r.embarcaderoId)
            .map((e) => e.nombre)
            .firstOrNull ??
        r.embarcaderoId;

    return LayoutBuilder(
      builder: (context, restricciones) {
        final dosColumnas = restricciones.maxWidth >= _anchoDosColumnas;

        Widget tarjeta(Ruta r) => TarjetaRuta(
          nombre: r.nombre.resolver(idioma),
          duracion: l.duracionDeRecorrido(Formato.duracion(r.duracionMin)),
          heroTag: heroTagRuta(r),
          precio: l.precioPorPersona(Formato.pesos(r.precioPorPersona)),
          salida: salida(r),
          tema: TemaImagen.values.byName(r.tema),
          rutaImagen: r.imagen,
          ladoALado: dosColumnas,
          onTap: () =>
              Navigator.of(context)
                  .pushNamed(RutasApp.detalleRuta, arguments: r),
          onElegir: () => elegirRuta(context, r),
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.margenPantalla,
            Espacios.e8,
            Espacios.margenPantalla,
            Espacios.e24,
          ),
          children: [
            Text(
              l.rutasIntro,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Espacios.e20),
            if (dosColumnas)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, r) in rutas.take(2).indexed) ...[
                      if (i > 0) const SizedBox(width: Espacios.e16),
                      Expanded(child: tarjeta(r)),
                    ],
                  ],
                ),
              )
            else
              for (final (i, r) in rutas.indexed) ...[
                if (i > 0) const SizedBox(height: Espacios.e16),
                tarjeta(r),
              ],
            const SizedBox(height: Espacios.e20),
            Text(l.comparacion, style: tema.textTheme.titleMedium),
            const SizedBox(height: Espacios.e20),
            _TablaComparativa(
              rutas: rutas.take(2).toList(),
              filas: _filas(l, rutas.take(2).toList(), idioma, salida),
            ),
          ],
        );
      },
    );
  }

  static List<_Fila> _filas(
    AppLocalizations l,
    List<Ruta> rutas,
    String idioma,
    String Function(Ruta) salida,
  ) {
    List<String> porRuta(String Function(Ruta) f) => rutas.map(f).toList();

    String paradas(Ruta r) => [
      for (final (i, p) in r.paradas.indexed)
        i == 0
            ? p.nombre.resolver(idioma)
            : _minuscula(p.nombre.resolver(idioma)),
    ].join(', ');

    return [
      _Fila(l.filaAmbiente, porRuta((r) => r.ambiente.resolver(idioma))),
      _Fila(l.filaDuracion, porRuta((r) => Formato.duracion(r.duracionMin))),
      _Fila(
        l.filaPrecio,
        porRuta(
          (r) => l.precioMxnPorPersona(Formato.pesos(r.precioPorPersona)),
        ),
      ),
      _Fila(l.filaSalida, porRuta((r) => l.embarcaderoNombre(salida(r)))),
      _Fila(l.filaHorarios, porRuta((r) => r.horarios.join(' · '))),
      _Fila(l.filaParadas, porRuta(paradas)),
      _Fila(
        l.filaIncluye,
        porRuta(
          (r) => r.recomendaciones.isNotEmpty
              ? l.incluyeRecomendaciones
              : l.incluyeServicios,
        ),
      ),
    ];
  }

  static String _minuscula(String s) =>
      s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.e24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_boat,
              size: Espacios.e48,
              color: tema.colorScheme.primary,
            ),
            const SizedBox(height: Espacios.e16),
            Text(
              texto,
              style: tema.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Fila {
  const _Fila(this.etiqueta, this.celdas);

  final String etiqueta;
  final List<String> celdas;
}

/// Tabla comparativa de dos columnas. Nunca parte una palabra a la mitad
/// ("Recomendacio-nes"): mide la palabra más larga y, si no cabe en
/// una columna, reduce los márgenes y, en último caso, pone la etiqueta de la
/// fila encima de los dos valores.
class _TablaComparativa extends StatelessWidget {
  const _TablaComparativa({required this.rutas, required this.filas});

  final List<Ruta> rutas;
  final List<_Fila> filas;

  static const double _maxAnchoEtiqueta = 72;

  /// Medidas (margen horizontal, separación, tamaño de letra de los valores)
  /// en el orden en que se prueban. A 360 dp "Recomendaciones" (119 dp a
  /// 12 pt) no cabe en una columna de 111 dp: se baja a 11 pt.
  static const List<(double, double, double)> _medidas = [
    (Espacios.e16, Espacios.e12, 12),
    (Espacios.e12, Espacios.e8, 12),
    (Espacios.e12, Espacios.e8, 11),
  ];

  static double _palabraMasLarga(
    Iterable<String> textos,
    TextStyle estilo,
    TextScaler escala,
  ) {
    var maximo = 0.0;
    for (final texto in textos) {
      for (final palabra in texto.split(RegExp(r'\s+'))) {
        final medida = TextPainter(
          text: TextSpan(text: palabra, style: estilo),
          textDirection: TextDirection.ltr,
          textScaler: escala,
        )..layout();
        if (medida.width > maximo) maximo = medida.width;
        medida.dispose();
      }
    }
    return maximo;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final escala = MediaQuery.textScalerOf(context);
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );

    final estiloBase = tema.textTheme.bodySmall!.copyWith(color: cs.onSurface);
    final estiloEtiqueta = tema.textTheme.labelMedium!.copyWith(
      color: cs.onSurfaceVariant,
    );
    final estiloNombre = tema.textTheme.titleSmall!;

    double palabraCelda(double tamano) => _palabraMasLarga(
      filas.expand((f) => f.celdas),
      estiloBase.copyWith(fontSize: tamano),
      escala,
    );
    final palabraEtiqueta = _palabraMasLarga(
      filas.map((f) => f.etiqueta),
      estiloEtiqueta,
      escala,
    );

    final anchoEtiqueta = palabraEtiqueta.ceilToDouble() + 2;

    final nombres = [
      for (final r in rutas) r.nombre.resolver(idioma).split(' ').last,
    ];
    final colores = [cs.tertiary, cs.primary];

    return LayoutBuilder(
      builder: (context, restricciones) {
        final ancho = restricciones.maxWidth;
        double columna(double margen, double separacion) =>
            (ancho - 2 * margen - anchoEtiqueta - 2 * separacion) / 2;

        (double, double, double)? lateral;
        if (anchoEtiqueta <= _maxAnchoEtiqueta) {
          for (final m in _medidas) {
            if (columna(m.$1, m.$2) >= palabraCelda(m.$3) + 1) {
              lateral = m;
              break;
            }
          }
        }
        final apilada = lateral == null;
        final (margen, separacion, tamano) =
            lateral ?? (Espacios.e16, Espacios.e12, 12.0);
        final estiloCelda = estiloBase.copyWith(fontSize: tamano);

        Widget celdas(List<String> textos) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, t) in textos.indexed) ...[
              if (i > 0) SizedBox(width: separacion),
              Expanded(child: Text(t, style: estiloCelda)),
            ],
          ],
        );

        Widget fila(_Fila f) => DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: cs.outlineVariant)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: margen,
              vertical: Espacios.e12,
            ),
            child: apilada
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.etiqueta, style: estiloEtiqueta),
                      const SizedBox(height: Espacios.e4),
                      celdas(f.celdas),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: anchoEtiqueta,
                        child: Text(f.etiqueta, style: estiloEtiqueta),
                      ),
                      SizedBox(width: separacion),
                      Expanded(child: celdas(f.celdas)),
                    ],
                  ),
          ),
        );

        return Material(
          color: cs.surfaceContainer,
          borderRadius: Radios.brMedium,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: cs.surfaceContainerHigh,
                padding: EdgeInsets.symmetric(
                  horizontal: margen,
                  vertical: Espacios.e12,
                ),
                child: Row(
                  children: [
                    if (!apilada) ...[
                      SizedBox(width: anchoEtiqueta),
                      SizedBox(width: separacion),
                    ],
                    for (final (i, n) in nombres.indexed) ...[
                      if (i > 0) SizedBox(width: separacion),
                      Expanded(
                        child: Text(
                          n,
                          style: estiloNombre.copyWith(color: colores[i]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              for (final f in filas) fila(f),
            ],
          ),
        );
      },
    );
  }
}
