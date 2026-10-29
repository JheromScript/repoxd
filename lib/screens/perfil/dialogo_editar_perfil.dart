import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/espacios.dart';
import '../../l10n/l10n.dart';
import '../../services/validadores.dart';
import '../../state/preferencias_controller.dart';

Future<void> mostrarDialogoEditarPerfil(BuildContext context) {
  final preferencias = context.read<PreferenciasController>();
  return showDialog<void>(
    context: context,
    builder: (_) => _DialogoEditarPerfil(preferencias: preferencias),
  );
}

class _DialogoEditarPerfil extends StatefulWidget {
  const _DialogoEditarPerfil({required this.preferencias});

  final PreferenciasController preferencias;

  @override
  State<_DialogoEditarPerfil> createState() => _DialogoEditarPerfilState();
}

class _DialogoEditarPerfilState extends State<_DialogoEditarPerfil> {
  final _formulario = GlobalKey<FormState>();
  late final _nombre = TextEditingController(
    text: widget.preferencias.perfil.nombre,
  );
  late final _telefono = TextEditingController(
    text: widget.preferencias.perfil.telefono,
  );
  late final _correo = TextEditingController(
    text: widget.preferencias.perfil.correo,
  );

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _correo.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!(_formulario.currentState?.validate() ?? false)) return;
    final errores = widget.preferencias.actualizarPerfil(
      nombre: _nombre.text,
      telefono: _telefono.text,
      correo: _correo.text,
    );
    if (errores.isNotEmpty) return;
    final mensaje = context.l10n.perfilActualizado;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.editarPerfil),
      content: SingleChildScrollView(
        child: Form(
          key: _formulario,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                decoration: InputDecoration(labelText: l.campoNombre),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => Validadores.nombre(v)?.texto(l),
              ),
              const SizedBox(height: Espacios.e16),
              TextFormField(
                controller: _telefono,
                decoration: InputDecoration(labelText: l.campoTelefono),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) => Validadores.telefono(v)?.texto(l),
              ),
              const SizedBox(height: Espacios.e16),
              TextFormField(
                controller: _correo,
                decoration: InputDecoration(labelText: l.correoElectronico),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => Validadores.correo(v)?.texto(l),
                onFieldSubmitted: (_) => _guardar(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancelar),
        ),
        FilledButton(onPressed: _guardar, child: Text(l.guardar)),
      ],
    );
  }
}
