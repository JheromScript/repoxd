import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';

/// Abre Maps, el marcador y el correo fuera de la app. Solo viaja texto del
/// embarcadero o del contacto de la empresa, nunca datos de la persona.
abstract final class Enlaces {
  static Uri maps(String consulta) => Uri.https(
    'www.google.com',
    '/maps/search/',
    {'api': '1', 'query': consulta},
  );

  static Uri llamada(String telefono) => Uri(scheme: 'tel', path: telefono);

  static Uri correo(String direccion) => Uri(scheme: 'mailto', path: direccion);

  static Future<void> abrir(BuildContext context, Uri uri) async {
    final mensajero = ScaffoldMessenger.of(context);
    final mensaje = context.l10n.noSePudoAbrir;
    var abierto = false;
    try {
      abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      abierto = false;
    }
    if (!abierto) {
      mensajero.showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }
}
