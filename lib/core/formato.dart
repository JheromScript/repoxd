abstract final class Formato {
  static const List<String> _diasEs = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom', //
  ];
  static const List<String> _diasEn = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', //
  ];
  static const List<String> _mesesEs = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun', //
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];
  static const List<String> _mesesEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const List<String> _mesesLargosEs = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', //
    'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];
  static const List<String> _mesesLargosEn = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', //
    'August', 'September', 'October', 'November', 'December',
  ];

  static String diaMes(DateTime fecha, {String idioma = 'es'}) {
    return idioma == 'en'
        ? '${_mesesEn[fecha.month - 1]} ${fecha.day}'
        : '${fecha.day} ${_mesesEs[fecha.month - 1]}';
  }

  static String fechaCorta(DateTime fecha, {String idioma = 'es'}) {
    final dia = (idioma == 'en' ? _diasEn : _diasEs)[fecha.weekday - 1];
    return '$dia ${diaMes(fecha, idioma: idioma)}';
  }

  static String fechaConAnio(DateTime fecha, {String idioma = 'es'}) {
    final corta = fechaCorta(fecha, idioma: idioma);
    return idioma == 'en' ? '$corta, ${fecha.year}' : '$corta ${fecha.year}';
  }

  static String mesAnio(DateTime fecha, {String idioma = 'es'}) {
    final meses = idioma == 'en' ? _mesesLargosEn : _mesesLargosEs;
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }

  static String horaAntes(String horario, int minutos) {
    final partes = horario.split(':');
    final total =
        (int.parse(partes[0]) * 60 + int.parse(partes[1]) - minutos) % 1440;
    return '${(total ~/ 60).toString().padLeft(2, '0')}:'
        '${(total % 60).toString().padLeft(2, '0')}';
  }

  static String pesos(int monto) {
    final digitos = monto.abs().toString();
    final grupos = <String>[];
    for (var fin = digitos.length; fin > 0; fin -= 3) {
      grupos.insert(0, digitos.substring(fin < 3 ? 0 : fin - 3, fin));
    }
    return '${monto < 0 ? '-' : ''}\$${grupos.join(',')}';
  }

  static String duracion(int minutos) {
    if (minutos < 60) return '$minutos min';
    final horas = minutos / 60;
    return horas == horas.truncate()
        ? '${horas.truncate()} h'
        : '${horas.toStringAsFixed(1)} h';
  }

  static String telefono(String digitos) {
    if (digitos.length != 10) return digitos;
    return '${digitos.substring(0, 2)} ${digitos.substring(2, 6)} '
        '${digitos.substring(6)}';
  }

  static String iniciales(String nombre) {
    final palabras = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty);
    return palabras.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
