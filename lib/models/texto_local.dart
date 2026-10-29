import 'mapas.dart';

class TextoLocal {
  const TextoLocal(this.es, this.en);

  final String es;
  final String en;

  String resolver(String idioma) => idioma == 'en' ? en : es;

  Mapa toMap() => {'es': es, 'en': en};

  factory TextoLocal.fromMap(Mapa m) =>
      TextoLocal(m['es']! as String, m['en']! as String);

  TextoLocal copyWith({String? es, String? en}) =>
      TextoLocal(es ?? this.es, en ?? this.en);

  static List<TextoLocal> listaDesde(Object? valor) =>
      listaDeMapas(valor, TextoLocal.fromMap);

  static List<Mapa> listaAMapas(List<TextoLocal> lista) => [
    for (final t in lista) t.toMap(),
  ];

  @override
  bool operator ==(Object other) =>
      other is TextoLocal && other.es == es && other.en == en;

  @override
  int get hashCode => Object.hash(es, en);

  @override
  String toString() => es;
}
