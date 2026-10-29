import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/formateador_telefono.dart';
import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../data/catalogo_repository.dart';
import '../../models/reservacion.dart';
import '../../models/trajinera.dart';
import '../../services/validadores.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';
import '../../widgets/barra_inferior_accion.dart';
import '../../widgets/contenido_centrado.dart';
import '../../widgets/hoja_aviso_privacidad.dart';
import '../../widgets/indicador_pasos.dart';
import '../../widgets/tarjeta_aviso.dart';
import 'comun_flujo.dart';

enum _Campo { nombre, telefono, correo, pasajeros }

class DatosScreen extends StatefulWidget {
  const DatosScreen({super.key});

  @override
  State<DatosScreen> createState() => _DatosScreenState();
}

class _DatosScreenState extends State<DatosScreen> {
  final _formulario = GlobalKey<FormState>();
  late final FlujoReservaController _flujo = context
      .read<FlujoReservaController>();

  late final _nombre = TextEditingController(text: _flujo.contacto?.nombre);
  late final _telefono = TextEditingController(
    text: FormateadorTelefono.formatear(_flujo.contacto?.telefono ?? ''),
  );
  late final _correo = TextEditingController(text: _flujo.contacto?.correo);
  late final _pasajeros = TextEditingController(text: '${_flujo.pasajeros}');

  final Set<_Campo> _tocados = {};
  bool _avisoTocado = false;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _correo.dispose();
    _pasajeros.dispose();
    super.dispose();
  }

  TextEditingController _controlador(_Campo campo) => switch (campo) {
    _Campo.nombre => _nombre,
    _Campo.telefono => _telefono,
    _Campo.correo => _correo,
    _Campo.pasajeros => _pasajeros,
  };

  /// Valida [texto] y no el controlador: `Form` puede llamar al validador
  /// del cuadro anterior, así que no debe depender de valores capturados.
  static ErrorCampo? _validar(_Campo campo, String texto, Trajinera t) =>
      switch (campo) {
        _Campo.nombre => Validadores.nombre(texto),
        _Campo.telefono => Validadores.telefono(
          FormateadorTelefono.soloDigitos(texto),
        ),
        _Campo.correo => Validadores.correo(texto),
        _Campo.pasajeros => Validadores.pasajeros(
          texto,
          capacidad: t.capacidad,
          trajinera: t.nombre,
        ),
      };

  ErrorCampo? _error(_Campo campo, Trajinera t) =>
      _validar(campo, _controlador(campo).text, t);

  void _cambio(_Campo campo) {
    setState(() => _tocados.add(campo));
    if (campo == _Campo.pasajeros) {
      // Solo un número válido llega al borrador: uno mayor a la capacidad
      // soltaría la trajinera (y su horario) estando ya en el paso 3.
      final t = _flujo.trajinera;
      final n = int.tryParse(_pasajeros.text);
      if (t != null && n != null && _error(campo, t) == null) {
        _flujo.cambiarPasajeros(n);
      }
      return;
    }
    _flujo.actualizarContacto(
      Contacto(
        nombre: _nombre.text,
        telefono: FormateadorTelefono.soloDigitos(_telefono.text),
        correo: _correo.text,
      ),
    );
  }

  Future<void> _leerAviso() async {
    final catalogo = context.read<CatalogoRepository>();
    final idioma = context.read<PreferenciasController>().idioma;
    final contenido = await catalogo.obtenerContenido();
    if (!mounted) return;
    await mostrarAvisoPrivacidad(
      context,
      contenido.avisoPrivacidad.resolver(idioma),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flujo = context.watch<FlujoReservaController>();
    final t = flujo.trajinera;
    if (flujo.ruta == null || t == null) {
      return FlujoIncompleto(titulo: context.l10n.tusDatos);
    }
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final l = context.l10n;

    final errores = {for (final c in _Campo.values) c: _error(c, t)};
    final camposValidos = errores.values.every((e) => e == null);
    final valido = camposValidos && flujo.avisoAceptado && flujo.datosValidos;
    final marcados = _tocados.any((c) => errores[c] != null);

    void continuar() => Navigator.of(context).pushNamed(RutasApp.resumen);

    Widget campo({
      required _Campo campo,
      required TextEditingController controlador,
      required String etiqueta,
      required IconData icono,
      String? ayuda,
      TextInputType? teclado,
      List<TextInputFormatter>? formateadores,
      TextCapitalization mayusculas = TextCapitalization.none,
      List<String>? autocompletar,
    }) {
      final conError = _tocados.contains(campo) && errores[campo] != null;
      return TextFormField(
        controller: controlador,
        decoration: InputDecoration(
          labelText: etiqueta,
          helperText: ayuda,
          prefixIcon: Icon(icono),
          suffixIcon: conError ? Icon(Icons.error, color: cs.error) : null,
        ),
        keyboardType: teclado,
        inputFormatters: formateadores,
        textCapitalization: mayusculas,
        autofillHints: autocompletar,
        textInputAction: campo == _Campo.pasajeros
            ? TextInputAction.done
            : TextInputAction.next,
        onChanged: (_) => _cambio(campo),
        onFieldSubmitted: campo == _Campo.pasajeros && valido
            ? (_) => continuar()
            : null,
        validator: (v) => _validar(campo, v ?? '', t)?.texto(l),
      );
    }

    return Scaffold(
      appBar: barraPaso(context, l.tusDatos),
      body: Column(
        children: [
          Expanded(
            child: ContenidoCentrado(
              child: Form(
                key: _formulario,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: margenPaso,
                  children: [
                    const IndicadorPasos(paso: 3),
                    const SizedBox(height: Espacios.e16),
                    Text(
                      l.datosIntro,

                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Espacios.e16),
                    campo(
                      campo: _Campo.nombre,
                      controlador: _nombre,
                      etiqueta: l.nombreResponsable,
                      icono: Icons.person,
                      ayuda: l.ayudaNombre,
                      mayusculas: TextCapitalization.words,
                      autocompletar: const [AutofillHints.name],
                    ),
                    const SizedBox(height: Espacios.e16),
                    campo(
                      campo: _Campo.telefono,
                      controlador: _telefono,
                      etiqueta: l.campoTelefono,
                      icono: Icons.phone,
                      ayuda: l.ayudaTelefono,
                      teclado: TextInputType.phone,
                      formateadores: [FormateadorTelefono()],
                      autocompletar: const [AutofillHints.telephoneNumber],
                    ),
                    const SizedBox(height: Espacios.e16),
                    campo(
                      campo: _Campo.correo,
                      controlador: _correo,
                      etiqueta: l.correoElectronico,
                      icono: Icons.mail,
                      ayuda: l.ayudaCorreo,
                      teclado: TextInputType.emailAddress,
                      autocompletar: const [AutofillHints.email],
                    ),
                    const SizedBox(height: Espacios.e16),
                    campo(
                      campo: _Campo.pasajeros,
                      controlador: _pasajeros,
                      etiqueta: l.numeroPasajeros,
                      icono: Icons.group,
                      ayuda: l.maximoPersonasEn(t.capacidad, t.nombre),
                      teclado: TextInputType.number,
                      formateadores: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                    const SizedBox(height: Espacios.e16),
                    _AvisoPrivacidad(
                      aceptado: flujo.avisoAceptado,
                      conError: _avisoTocado && !flujo.avisoAceptado,
                      alCambiar: (v) {
                        setState(() => _avisoTocado = true);
                        flujo.aceptarAviso(v);
                      },
                      alLeer: _leerAviso,
                    ),
                    if (!valido) ...[
                      const SizedBox(height: Espacios.e16),
                      TarjetaAviso(
                        icono: Icons.lock,
                        texto: marcados
                            ? l.corrigeCampos
                            : !camposValidos
                            ? l.completaDatos
                            : l.aceptaAvisoContinuar,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          BarraInferiorAccion(
            textoBoton: l.continuarAlResumen,
            onPressed: valido ? continuar : null,
          ),
        ],
      ),
    );
  }
}

class _AvisoPrivacidad extends StatelessWidget {
  const _AvisoPrivacidad({
    required this.aceptado,
    required this.conError,
    required this.alCambiar,
    required this.alLeer,
  });

  final bool aceptado;
  final bool conError;
  final ValueChanged<bool> alCambiar;
  final VoidCallback alLeer;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Row(
      children: [
        Checkbox(
          value: aceptado,
          isError: conError,
          onChanged: (v) => alCambiar(v ?? false),
        ),
        const SizedBox(width: Espacios.e4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => alCambiar(!aceptado),
                child: Text(
                  context.l10n.aceptoAviso,

                  style: tema.textTheme.bodySmall?.copyWith(
                    color: conError ? cs.error : cs.onSurface,
                  ),
                ),
              ),
              Semantics(
                link: true,
                child: InkWell(
                  onTap: alLeer,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        context.l10n.leerAviso,
                        style: tema.textTheme.labelMedium?.copyWith(
                          color: cs.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
