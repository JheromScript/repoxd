typedef Mapa = Map<String, Object?>;

Mapa comoMapa(Object? valor) => Mapa.from(valor! as Map);

List<T> listaDeMapas<T>(Object? valor, T Function(Mapa) desde) => [
  for (final item in valor! as List) desde(comoMapa(item)),
];

List<String> listaDeTextos(Object? valor) => List<String>.from(valor! as List);

DateTime? fechaOpcional(Object? valor) =>
    valor == null ? null : DateTime.parse(valor as String);
