import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../models/reservacion.dart';
import '../../models/ruta.dart';
import '../../state/flujo_reserva_controller.dart';
import '../../state/preferencias_controller.dart';

void elegirRuta(BuildContext context, Ruta ruta) {
  final perfil = context.read<PreferenciasController>().perfil;
  context.read<FlujoReservaController>().iniciar(
    ruta,
    contacto: Contacto(
      nombre: perfil.nombre,
      telefono: perfil.telefono,
      correo: perfil.correo,
    ),
  );
  Navigator.of(context).pushNamed(RutasApp.reservar);
}

Object heroTagRuta(Ruta ruta) => 'ruta-imagen-${ruta.id}';
