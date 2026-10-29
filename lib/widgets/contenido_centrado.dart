import 'package:flutter/material.dart';

class ContenidoCentrado extends StatelessWidget {
  const ContenidoCentrado({
    super.key,
    required this.child,
    this.ajustarAlto = false,
  });

  static const double anchoMaximo = 600;

  final Widget child;

  final bool ajustarAlto;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: ajustarAlto ? 1 : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: anchoMaximo),
        child: child,
      ),
    );
  }
}
