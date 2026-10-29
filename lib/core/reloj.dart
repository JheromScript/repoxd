/// Fuente del "ahora". Todo lo que depende de la fecha actual (fechas
/// pasadas, límite de 24 h, temporada) la pide aquí.
abstract class Reloj {
  const Reloj();

  DateTime ahora();
}

class RelojSistema extends Reloj {
  const RelojSistema();

  @override
  DateTime ahora() => DateTime.now();
}

class RelojFijo extends Reloj {
  const RelojFijo(this.momento);

  final DateTime momento;

  @override
  DateTime ahora() => momento;
}
