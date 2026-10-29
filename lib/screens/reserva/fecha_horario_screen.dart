import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../app.dart';
import '../../core/formato.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/ruta.dart';
import '../../models/trajinera.dart';
import '../../services/disponibilidad.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';
import '../../state/reservas_controller.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/carga_futuro.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_aviso.dart';
import 'comun_flujo.dart';

typedef _DatosFecha = (List<Trajinera>, Disponibilidad);

class FechaHorarioScreen extends StatefulWidget {
  const FechaHorarioScreen({super.key});

  @override
  State<FechaHorarioScreen> createState() => _FechaHorarioScreenState();
}

class _FechaHorarioScreenState extends State<FechaHorarioScreen> {
  late Future<_DatosFecha> _datos;

  DateTime? _mes;

  String? _consultado;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _datos = _cargar();
  }

  Future<_DatosFecha> _cargar() async {
    final catalogo = context.read<CatalogoRepository>();
    final reservas = context.read<ReservasController>();
    final flujo = context.read<FlujoReservaController>();
    final datos = (
      await catalogo.listarTrajineras(),
      await reservas.disponibilidad(),
    );
    final soltado = flujo.revisar(datos.$2);
    if (soltado != null) _consultado = soltado;
    return datos;
  }

  void _continuar() {
    final flujo = context.read<FlujoReservaController>();
    final elegido = flujo.horario;
    abrirPaso(
      context,
      RutasApp.datos,
      alVolver: () => setState(() {
        if (flujo.horario == null) _consultado = elegido;
        _datos = _cargar();
      }),
    );
  }

  Future<void> _guardarCambio(String folio) async {
    if (_guardando) return;
    final flujo = context.read<FlujoReservaController>();
    final fecha = flujo.fecha;
    final horario = flujo.horario;
    if (fecha == null || horario == null) return;
    setState(() => _guardando = true);
    final navegador = Navigator.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    try {
      final cambiada = await context.read<ReservasController>().cambiar(
        folio,
        fecha: fecha,
        horario: horario,
      );
      navegador.pop(cambiada);
    } on ReservaException catch (e) {
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _consultado = horario;
        _datos = _cargar();
      });
      mensajero
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.motivo == MotivoRechazo.ocupado
                  ? context.l10n.alguienReservoHorario
                  : context.l10n.noSePudoCambiar,
            ),
          ),
        );
    }
  }

  void _elegirFecha(DateTime dia) {
    context.read<FlujoReservaController>().elegirFecha(dia);
    setState(() {
      _mes = dia;
      _consultado = null;
    });
  }

  void _elegirAlternativa(Alternativa a) {
    final flujo = context.read<FlujoReservaController>();
    final otraTrajinera = a.trajinera.id != flujo.trajinera?.id;
    flujo.elegirAlternativa(a);
    setState(() {
      _mes = a.fecha;
      _consultado = null;
    });
    if (otraTrajinera) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.cambiamosTuTrajinera(a.trajinera.nombre),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flujo = context.watch<FlujoReservaController>();
    final l = context.l10n;
    final ruta = flujo.ruta;
    final trajinera = flujo.trajinera;
    if (ruta == null || trajinera == null) {
      return FlujoIncompleto(titulo: l.pasoFecha);
    }
    final idioma = context.select<PreferenciasController, String>(
      (p) => p.idioma,
    );
    final fecha = flujo.fecha;
    final horario = flujo.horario;
    final folioCambio = flujo.folioCambio;

    return Scaffold(
      appBar: barraPaso(
        context,
        folioCambio == null ? l.pasoFecha : l.cambiarReservacion,
      ),
      // La barra va en bottomNavigationBar: así los SnackBar ("Cambiamos tu
      // trajinera…", "Alguien acaba de reservar…") salen encima y no tapan
      // "Continuar".
      body: ContenidoCentrado(
        child: CargaFuturo<_DatosFecha>(
          futuro: _datos,
          builder: (context, datos) =>
              _cuerpo(context, flujo, ruta, trajinera, datos, idioma),
        ),
      ),
      bottomNavigationBar: BarraInferiorAccion(
        etiqueta: l.fechaYHora,
        valor: fecha == null
            ? l.sinElegir
            : [Formato.fechaCorta(fecha, idioma: idioma), ?horario].join(' · '),
        textoBoton: folioCambio == null ? l.continuar : l.guardar,
        onPressed: folioCambio != null
            ? (flujo.hayCambio && !_guardando
                  ? () => _guardarCambio(folioCambio)
                  : null)
            : (fecha == null || horario == null ? null : _continuar),
      ),
    );
  }

  Widget _cuerpo(
    BuildContext context,
    FlujoReservaController flujo,
    Ruta ruta,
    Trajinera trajinera,
    _DatosFecha datos,
    String idioma,
  ) {
    final tema = Theme.of(context);
    final l = context.l10n;
    final cs = tema.colorScheme;
    final (trajineras, disp) = datos;
    final fecha = flujo.fecha;
    // En "modo cambio" la propia reservación no cuenta como choque.
    final cambio = flujo.reservaCambio;

    final validos = fecha == null
        ? const <String>[]
        : disp.horariosValidos(ruta, fecha);
    final libres = fecha == null
        ? const <String>[]
        : disp.horariosLibres(
            ruta,
            trajinera,
            fecha,
            excluirFolio: cambio?.folio,
          );
    final ocupados = [
      for (final h in validos)
        if (!libres.contains(h)) h,
    ];
    final sinLibres = fecha != null && libres.isEmpty;
    final consultado = ocupados.contains(_consultado)
        ? _consultado
        : sinLibres
        ? null
        : ocupados.firstOrNull;
    final alternativas = fecha == null || (consultado == null && !sinLibres)
        ? null
        : disp.alternativas(
            ruta: ruta,
            trajinera: trajinera,
            fecha: fecha,
            horario: consultado,
            pasajeros: flujo.pasajeros,
            trajineras: cambio == null ? trajineras : const [],
            excluirFolio: cambio?.folio,
          );

    return ListView(
      padding: margenPaso,
      children: [
        if (cambio == null)
          const IndicadorPasos(paso: 2)
        else
          TarjetaAviso(
            icono: Icons.edit_calendar,
            texto: l.cambioAviso(
              cambio.folio,
              trajinera.nombre,
              l.pasajeros(cambio.pasajeros),
            ),
          ),
        const SizedBox(height: Espacios.e16),
        _Calendario(
          disponibilidad: disp,
          mes: _mes ?? fecha ?? disp.fechasValidas().firstOrNull,
          seleccionada: fecha,
          idioma: idioma,
          alElegir: _elegirFecha,
          alCambiarMes: (m) => setState(() => _mes = m),
        ),
        const SizedBox(height: Espacios.e16),
        Text(
          fecha == null
              ? l.horariosDisponibles
              : l.horariosDisponiblesFecha(
                  Formato.fechaCorta(fecha, idioma: idioma),
                ),
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: Espacios.e16),
        if (fecha == null || validos.isEmpty)
          Text(
            fecha == null
                ? l.eligeFechaVerHorarios
                : l.sinSalidasHoy(anticipacionMinima.inHours),
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: Espacios.e8,
            runSpacing: Espacios.e8,
            children: [
              for (final h in validos)
                if (ocupados.contains(h))
                  _ChipOcupado(
                    horario: h,
                    onTap: () => setState(() => _consultado = h),
                  )
                else
                  FilterChip(
                    label: Text(h),
                    selected: flujo.horario == h,
                    onSelected: (_) => flujo.elegirHorario(h),
                  ),
            ],
          ),
        if (alternativas != null) ...[
          const SizedBox(height: Espacios.e16),
          _TarjetaAlternativas(
            titulo: consultado != null
                ? l.yaReservadoEn(consultado, trajinera.nombre)
                : l.sinHorariosEn(trajinera.nombre),
            alternativas: alternativas,
            trajinera: trajinera,
            idioma: idioma,
            alElegir: _elegirAlternativa,
          ),
        ],
      ],
    );
  }
}

class _Calendario extends StatelessWidget {
  const _Calendario({
    required this.disponibilidad,
    required this.mes,
    required this.seleccionada,
    required this.idioma,
    required this.alElegir,
    required this.alCambiarMes,
  });

  final Disponibilidad disponibilidad;
  final DateTime? mes;
  final DateTime? seleccionada;
  final String idioma;
  final ValueChanged<DateTime> alElegir;
  final ValueChanged<DateTime> alCambiarMes;

  static const _inicialesEs = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  static const _inicialesEn = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final temporada = disponibilidad.temporada;
    final hoy = soloDia(disponibilidad.ahora);
    final primero = soloDia(temporada.inicio);
    final ultimo = soloDia(temporada.fin);

    // table_calendar exige que el mes enfocado esté dentro de la temporada.
    var enfocado = soloDia(mes ?? hoy);
    if (enfocado.isBefore(primero)) enfocado = primero;
    if (enfocado.isAfter(ultimo)) enfocado = ultimo;

    final hayAnterior = DateTime(
      enfocado.year,
      enfocado.month,
    ).isAfter(primero);
    final haySiguiente = DateTime(
      enfocado.year,
      enfocado.month + 1,
    ).isBefore(ultimo.add(const Duration(days: 1)));

    Widget dia(BuildContext context, DateTime d, DateTime enfoque) {
      // Como en Figma: la semana empieza en blanco antes del día 1. Los días
      // de table_calendar vienen en UTC: se comparan por fecha, no por instante.
      if (soloDia(d).isBefore(DateTime(enfoque.year, enfoque.month))) {
        return const SizedBox.shrink();
      }
      final fuera = d.month != enfoque.month;
      final elegida = isSameDay(d, seleccionada);
      final esHoy = isSameDay(d, hoy);

      var color = cs.onSurface;
      Color? fondo;
      BoxBorder? borde;
      TextDecoration? decoracion;
      if (elegida) {
        fondo = cs.primary;
        color = cs.onPrimary;
      } else if (fuera) {
        color = cs.onSurfaceVariant.withValues(alpha: 0.38);
      } else if (disponibilidad.diaSinServicio(d)) {
        color = cs.onSurfaceVariant.withValues(alpha: 0.5);
        decoracion = TextDecoration.lineThrough;
      } else if (esHoy) {
        color = cs.primary;
        borde = Border.all(color: cs.primary);
      } else if (!disponibilidad.fechaValida(d)) {
        color = cs.onSurface.withValues(alpha: 0.38);
      }

      return Center(
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fondo,
            border: borde,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${d.day}',
            style: tema.textTheme.bodyLarge?.copyWith(
              color: color,
              decoration: decoracion,
              decorationColor: color,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: Radios.brLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Formato.mesAnio(enfocado, idioma: idioma),
                  style: tema.textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: context.l10n.mesAnterior,
                icon: const Icon(Icons.chevron_left),
                onPressed: hayAnterior
                    ? () => alCambiarMes(
                        DateTime(enfocado.year, enfocado.month - 1),
                      )
                    : null,
              ),
              IconButton(
                tooltip: context.l10n.mesSiguiente,
                icon: const Icon(Icons.chevron_right),
                onPressed: haySiguiente
                    ? () => alCambiarMes(
                        DateTime(enfocado.year, enfocado.month + 1),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: Espacios.e8),
          TableCalendar<void>(
            locale: idioma,
            firstDay: primero,
            lastDay: ultimo,
            focusedDay: enfocado,
            currentDay: hoy,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            sixWeekMonthsEnforced: false,
            availableGestures: AvailableGestures.horizontalSwipe,
            daysOfWeekHeight: 32,
            rowHeight: 48,
            calendarStyle: const CalendarStyle(cellMargin: EdgeInsets.zero),
            selectedDayPredicate: (d) => isSameDay(d, seleccionada),
            enabledDayPredicate: disponibilidad.fechaValida,
            onDaySelected: (d, _) {
              if (soloDia(d)
                  .isBefore(DateTime(enfocado.year, enfocado.month))) {
                return;
              }
              alElegir(soloDia(d));
            },
            onPageChanged: alCambiarMes,
            calendarBuilders: CalendarBuilders(
              prioritizedBuilder: dia,
              dowBuilder: (context, d) => Center(
                child: ExcludeSemantics(
                  child: Text(
                    (idioma == 'en' ? _inicialesEn : _inicialesEs)[d.weekday -
                        1],
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Espacios.e8),
          Wrap(
            spacing: Espacios.e16,
            runSpacing: Espacios.e8,
            children: [
              _Leyenda(
                texto: context.l10n.seleccionada,
                punto: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
              ),
              _Leyenda(
                texto: context.l10n.leyendaHoy,
                punto: BoxDecoration(
                  border: Border.all(color: cs.primary),
                  shape: BoxShape.circle,
                ),
              ),
              _Leyenda(
                texto: context.l10n.leyendaSinServicio,
                punto: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda({required this.texto, required this.punto});

  final String texto;
  final BoxDecoration punto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: punto),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            texto,
            style: tema.textTheme.labelSmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipOcupado extends StatelessWidget {
  const _ChipOcupado({required this.horario, required this.onTap});

  final String horario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      hint: context.l10n.verAlternativas,
      child: FilterChip(
        label: Text(context.l10n.horarioOcupado(horario)),
        labelStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: cs.onSurface.withValues(alpha: 0.38)),
        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        selected: false,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _TarjetaAlternativas extends StatelessWidget {
  const _TarjetaAlternativas({
    required this.titulo,
    required this.alternativas,
    required this.trajinera,
    required this.idioma,
    required this.alElegir,
  });

  final String titulo;
  final List<Alternativa> alternativas;
  final Trajinera trajinera;
  final String idioma;
  final ValueChanged<Alternativa> alElegir;

  String _texto(Alternativa a) => switch (a.tipo) {
    TipoAlternativa.otroDia =>
      '${Formato.fechaCorta(a.fecha, idioma: idioma)} · ${a.horario} · '
          '${a.trajinera.nombre}',
    _ => '${a.horario} · ${a.trajinera.nombre}',
  };

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final color = cs.onTertiaryContainer;

    return Container(
      padding: const EdgeInsets.all(Espacios.e16),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: Radios.brMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, size: 24, color: color),
              const SizedBox(width: Espacios.e8),
              Expanded(
                child: Text(
                  titulo,
                  style: tema.textTheme.titleSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.e8),
          Text(
            alternativas.isEmpty
                ? context.l10n.sinAlternativas
                : context.l10n.sugerimosAlternativas,
            style: tema.textTheme.bodySmall?.copyWith(color: color),
          ),
          if (alternativas.isNotEmpty) ...[
            const SizedBox(height: Espacios.e8),
            Wrap(
              spacing: Espacios.e8,
              runSpacing: Espacios.e8,
              children: [
                for (final a in alternativas)
                  OutlinedButton(
                    onPressed: () => alElegir(a),
                    child: Text(_texto(a)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
