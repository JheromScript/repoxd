import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/theme/espacios.dart';
import '../l10n/l10n.dart';
import 'etiqueta_estado.dart';

/// Folio, QR y estado de pago (Confirmación y Detalle de reservación). El QR
/// lleva solo el folio, sin datos personales.
class TarjetaFolio extends StatelessWidget {
  const TarjetaFolio({super.key, required this.folio, required this.estado});

  final String folio;
  final EstadoEtiqueta estado;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Espacios.e20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: Radios.brExtraLarge,
      ),
      child: Column(
        children: [
          Text(
            context.l10n.folioMayusculas,
            style: tema.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Espacios.e12),
          Text(
            folio,
            style: tema.textTheme.headlineSmall?.copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: Espacios.e12),
          Semantics(
            label: context.l10n.qrDelFolio(folio),
            child: Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(
                color: cs.inverseSurface,
                borderRadius: Radios.brMedium,
              ),
              child: QrImageView(
                data: folio,
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.transparent,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: cs.onInverseSurface,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: cs.onInverseSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: Espacios.e12),
          FittedBox(fit: BoxFit.scaleDown, child: EtiquetaEstado(estado)),
        ],
      ),
    );
  }
}
