import 'package:flutter/widgets.dart';

import '../models/reservacion.dart';
import '../services/validadores.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension ContextoL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension ErrorCampoTexto on ErrorCampo {
  String texto(AppLocalizations l) => switch (tipo) {
    TipoErrorCampo.nombreVacio => l.errNombreVacio,
    TipoErrorCampo.nombreLetras => l.errNombreLetras,
    TipoErrorCampo.nombreCorto => l.errNombreCorto,
    TipoErrorCampo.telefonoVacio => l.errTelefonoVacio,
    TipoErrorCampo.telefonoLargo => l.errTelefonoLargo,
    TipoErrorCampo.correoVacio => l.errCorreoVacio,
    TipoErrorCampo.correoInvalido => l.errCorreoInvalido,
    TipoErrorCampo.pasajerosVacio => l.errPasajerosVacio,
    TipoErrorCampo.pasajerosMinimo => l.errPasajerosMinimo,
    TipoErrorCampo.pasajerosMaximo =>
      trajinera == null
          ? l.errPasajerosMaximo(capacidad ?? 0)
          : l.maximoPersonasEn(capacidad ?? 0, trajinera!),
    TipoErrorCampo.avisoPrivacidad => l.aceptaAvisoContinuar,
  };
}

extension MetodoPagoTexto on MetodoPago {
  String texto(AppLocalizations l, {bool simulado = false}) => switch (this) {
    MetodoPago.tarjeta => simulado ? l.pagoTarjetaSimulado : l.pagoTarjeta,
    MetodoPago.spei => simulado ? l.pagoSpeiSimulado : l.pagoSpei,
  };
}

extension ListaTexto on AppLocalizations {
  String enLista(List<String> xs) => xs.length < 2
      ? xs.join()
      : unirConY(xs.sublist(0, xs.length - 1).join(', '), xs.last);
}
