import '../models/contenido.dart';
import '../models/embarcadero.dart';
import '../models/perfil.dart';
import '../models/reservacion.dart';
import '../models/ruta.dart';
import '../models/servicio_adicional.dart';
import '../models/temporada.dart';
import '../models/texto_local.dart';
import '../models/trajinera.dart';
import '../services/calculo_costos.dart';

const bool cargarReservasDemo = true;

abstract final class DatosMock {
  static const String usuarioDemoId = 'u1';

  static const Perfil perfilDemo = Perfil(
    id: usuarioDemoId,
    nombre: 'Lucía Hernández',
    telefono: '5512345678',
    correo: 'lucia.hdz@correo.com',
  );

  static const List<ServicioAdicional> servicios = [
    ServicioAdicional(
      id: 'srv_mariachi',
      nombre: TextoLocal('Mariachi exclusivo', 'Private mariachi'),
      descripcion: TextoLocal('45 min a bordo', '45 min on board'),
      precio: 1500,
    ),
    ServicioAdicional(
      id: 'srv_cena',
      nombre: TextoLocal('Cena tradicional', 'Traditional dinner'),
      descripcion: TextoLocal('Paquete para el grupo', 'Package for the group'),
      precio: 1200,
    ),
    ServicioAdicional(
      id: 'srv_fotografo',
      nombre: TextoLocal('Fotógrafo', 'Photographer'),
      descripcion: TextoLocal(
        'Sesión y 30 fotos digitales',
        'Photo session and 30 digital photos',
      ),
      precio: 800,
    ),
  ];

  static const List<Embarcadero> embarcaderos = [
    Embarcadero(
      id: 'emb_nativitas',
      nombre: 'Nuevo Nativitas',
      // TODO: verificar la dirección real.
      direccion:
          'Av. Nuevo León s/n, Barrio Santa Cruz Acalpixca, Xochimilco, CDMX',
      horario: TextoLocal('10:00 – 23:00', '10:00 AM – 11:00 PM'),
      // TODO: verificar la distancia.
      distancia: TextoLocal('A 25 min del centro', '25 min from downtown'),
      muelle: TextoLocal('Muelle 3', 'Dock 3'),
      // TODO: teléfono ficticio; que no pueda ser de una persona real.
      telefono: '5555550101',
      consultaMaps: 'Embarcadero Nuevo Nativitas, Xochimilco, CDMX',
      indicaciones: [
        Indicacion(
          tipo: TipoIndicacion.tren,
          titulo: TextoLocal('En tren ligero', 'By light rail'),
          // TODO: verificar el tiempo de caminata.
          detalle: TextoLocal(
            'Baja en la estación Xochimilco y camina unos 15 minutos hasta '
                'el embarcadero.',
            'Get off at Xochimilco station and walk about 15 minutes to the '
                'pier.',
          ),
        ),
        Indicacion(
          tipo: TipoIndicacion.auto,
          titulo: TextoLocal('En auto', 'By car'),
          detalle: TextoLocal(
            'Hay estacionamiento junto al embarcadero. Son unos 40 minutos '
                'desde Coyoacán.',
            'There is parking next to the pier. It is about a 40-minute '
                'drive from Coyoacán.',
          ),
        ),
        Indicacion(
          tipo: TipoIndicacion.app,
          titulo: TextoLocal('En app de transporte', 'By ride-hailing app'),
          detalle: TextoLocal(
            'Pide el viaje a "Embarcadero Nuevo Nativitas" y baja en la '
                'entrada principal.',
            'Request the ride to "Embarcadero Nuevo Nativitas" and get off '
                'at the main entrance.',
          ),
        ),
      ],
    ),
    Embarcadero(
      id: 'emb_cuemanco',
      nombre: 'Cuemanco',
      // TODO: dirección, horario, distancia, muelle, teléfono e indicaciones
      // de Cuemanco; el mock solo muestra Nativitas.
      direccion: 'Periférico Sur, Pista de Canotaje Cuemanco, Xochimilco, CDMX',
      horario: TextoLocal('10:00 – 23:00', '10:00 AM – 11:00 PM'),
      distancia: TextoLocal('A 30 min del centro', '30 min from downtown'),
      muelle: TextoLocal('Muelle 1', 'Dock 1'),
      telefono: '5555550102',
      consultaMaps: 'Embarcadero Cuemanco, Xochimilco, CDMX',
      indicaciones: [
        Indicacion(
          tipo: TipoIndicacion.tren,
          titulo: TextoLocal('En tren ligero', 'By light rail'),
          detalle: TextoLocal(
            'Baja en la estación Periférico y toma un taxi o transporte '
                'local hasta el embarcadero.',
            'Get off at Periférico station and take a taxi or local '
                'transport to the pier.',
          ),
        ),
        Indicacion(
          tipo: TipoIndicacion.auto,
          titulo: TextoLocal('En auto', 'By car'),
          detalle: TextoLocal(
            'Entra por Periférico Sur; hay estacionamiento cerca del muelle.',
            'Enter via Periférico Sur; there is parking near the dock.',
          ),
        ),
        Indicacion(
          tipo: TipoIndicacion.app,
          titulo: TextoLocal('En app de transporte', 'By ride-hailing app'),
          detalle: TextoLocal(
            'Pide el viaje a "Embarcadero Cuemanco" y baja en la entrada.',
            'Request the ride to "Embarcadero Cuemanco" and get off at the '
                'entrance.',
          ),
        ),
      ],
    ),
  ];

  static const List<Ruta> rutas = [
    Ruta(
      id: 'ruta_animas',
      nombre: TextoLocal('Sendero de las Ánimas', 'Trail of the Souls'),
      etiqueta: TextoLocal(
        'RUTA 1 · TRADICIONES Y LEYENDAS',
        'ROUTE 1 · TRADITIONS AND LEGENDS',
      ),
      ambiente: TextoLocal(
        'Místico: ofrendas y leyendas narradas',
        'Mystical: offerings and storytelling',
      ),
      descripcion: TextoLocal(
        'Recorrido nocturno entre ofrendas flotantes y leyendas narradas por '
            'cuenteros locales. Ideal para conocer el significado del Día de '
            'Muertos en los canales de Xochimilco.',
        'A night tour among floating offerings and legends told by local '
            'storytellers. Ideal for learning what the Day of the Dead means '
            'on the canals of Xochimilco.',
      ),
      duracionMin: 120,
      precioPorPersona: 250,
      embarcaderoId: 'emb_nativitas',
      horarios: ['18:00', '19:30', '21:00'],
      paradas: [
        Parada(
          nombre: TextoLocal('Ofrenda flotante', 'Floating offering'),
          minutos: 20,
          descripcion: TextoLocal(
            'Altar sobre el agua con cempasúchil y veladoras.',
            'An altar on the water with marigolds and candles.',
          ),
        ),
        Parada(
          nombre: TextoLocal('Isla de leyendas', 'Island of legends'),
          minutos: 40,
          descripcion: TextoLocal(
            'Narración de La Llorona y la Isla de las Muñecas.',
            'Tales of La Llorona and the Island of the Dolls.',
          ),
        ),
        Parada(
          nombre: TextoLocal('Altar comunitario', 'Community altar'),
          minutos: 30,
          descripcion: TextoLocal(
            'Convivencia y pan de muerto con la comunidad de Nativitas.',
            'Time with the Nativitas community and pan de muerto.',
          ),
        ),
      ],
      recomendaciones: [
        TextoLocal(
          'Usa el chaleco salvavidas todo el recorrido.',
          'Wear your life jacket throughout the tour.',
        ),
        TextoLocal(
          'Llega 30 minutos antes al embarcadero.',
          'Arrive at the pier 30 minutes early.',
        ),
        TextoLocal(
          'Lleva abrigo: de noche baja a 10 °C.',
          'Bring a jacket: at night it drops to 10 °C (50 °F).',
        ),
        TextoLocal(
          'Menores siempre acompañados de un adulto.',
          'Children must always be with an adult.',
        ),
      ],
      tema: 'animas',
      imagen: 'assets/images/ruta_animas.jpg',
    ),
    Ruta(
      id: 'ruta_cempasuchil',
      nombre: TextoLocal('Fiesta de Cempasúchil', 'Marigold Fiesta'),
      // TODO: confirmar la etiqueta.
      etiqueta: TextoLocal(
        'RUTA 2 · MÚSICA Y FIESTA',
        'ROUTE 2 · MUSIC AND FIESTA',
      ),
      ambiente: TextoLocal(
        'Festivo: mariachi y música tradicional',
        'Festive: mariachi and traditional music',
      ),
      // TODO: redactar la descripción definitiva.
      descripcion: TextoLocal(
        'Un paseo de día lleno de color, música y sabor. Disfruta fotos '
            'entre flores, comida tradicional y baile folclórico sobre el agua.',
        'A daytime ride full of color, music and flavor. Enjoy photos among '
            'flowers, traditional food and folk dancing on the water.',
      ),
      duracionMin: 90,
      precioPorPersona: 200,
      embarcaderoId: 'emb_cuemanco',
      horarios: ['12:00', '14:00', '16:00', '18:00'],
      // TODO: confirmar minutos y descripción de cada parada.
      paradas: [
        Parada(
          nombre: TextoLocal('Fotos', 'Photos'),
          minutos: 30,
          descripcion: TextoLocal(
            'Un tramo de canal cubierto de cempasúchil para tomar fotos.',
            'A stretch of canal covered in marigolds for taking photos.',
          ),
        ),
        Parada(
          nombre: TextoLocal('Comida y bebida', 'Food and drinks'),
          minutos: 30,
          descripcion: TextoLocal(
            'Antojitos y bebidas tradicionales servidos a bordo.',
            'Traditional snacks and drinks served on board.',
          ),
        ),
        Parada(
          nombre: TextoLocal('Baile folclórico', 'Folk dance'),
          minutos: 30,
          descripcion: TextoLocal(
            'Un grupo de baile folclórico y música en vivo.',
            'A folk dance group and live music.',
          ),
        ),
      ],
      recomendaciones: [],
      tema: 'cempasuchil',
      imagen: 'assets/images/ruta_cempasuchil.jpg',
    ),
  ];

  static const List<Trajinera> trajineras = [
    Trajinera(
      id: 'traj_catrina',
      nombre: 'La Catrina',
      capacidad: 20,
      tarifa: 1200,
      incluye: [
        TextoLocal('Chalecos', 'Life jackets'),
        TextoLocal('Mesa', 'Table'),
        TextoLocal('Decoración', 'Decorations'),
      ],
      serviciosIds: ['srv_mariachi', 'srv_cena', 'srv_fotografo'],
      imagen: 'assets/images/trajinera_catrina.jpg',
    ),
    Trajinera(
      id: 'traj_flor',
      nombre: 'Flor de Cempasúchil',
      capacidad: 14,
      tarifa: 950,
      incluye: [
        TextoLocal('Chalecos', 'Life jackets'),
        TextoLocal('Mesa', 'Table'),
      ],
      serviciosIds: ['srv_cena', 'srv_fotografo'],
      imagen: 'assets/images/trajinera_flor.jpg',
    ),
    Trajinera(
      id: 'traj_xochitl',
      nombre: 'Xóchitl',
      capacidad: 10,
      tarifa: 750,
      incluye: [
        TextoLocal('Chalecos', 'Life jackets'),
        TextoLocal('Decoración floral', 'Floral decorations'),
      ],
      serviciosIds: [],
      imagen: 'assets/images/trajinera_xochitl.jpg',
    ),
    Trajinera(
      id: 'traj_lucero',
      nombre: 'Lucero',
      capacidad: 8,
      tarifa: 650,
      incluye: [TextoLocal('Chalecos', 'Life jackets')],
      serviciosIds: [],
      accesible: true,
      notaAccesibilidad: TextoLocal(
        'Rampa de acceso y espacio para silla de ruedas.',
        'Access ramp and space for a wheelchair.',
      ),
      imagen: 'assets/images/trajinera_lucero.jpg',
    ),
    // TODO: 5.ª trajinera opcional, solo para mostrar "Sin servicio".
    Trajinera(
      id: 'traj_chinampa',
      nombre: 'Chinampa Real',
      capacidad: 16,
      tarifa: 900,
      incluye: [
        TextoLocal('Chalecos', 'Life jackets'),
        TextoLocal('Mesa', 'Table'),
      ],
      serviciosIds: [],
      activa: false,
      imagen: 'assets/images/trajinera_chinampa.jpg',
    ),
  ];

  static const Contenido contenido = Contenido(
    historia: TextoLocal(
      'El Día de Muertos es una tradición mexicana que une el legado '
          'prehispánico con la herencia católica. Cada año, entre el 31 de '
          'octubre y el 2 de noviembre, las familias reciben a sus difuntos con '
          'ofrendas de flores de cempasúchil, velas, pan de muerto y los '
          'platillos que más disfrutaban. En Xochimilco, las trajineras llenan '
          'los canales de luz y color para celebrar la memoria.',
      'The Day of the Dead is a Mexican tradition that blends pre-Hispanic '
          'heritage with Catholic influence. Every year, between October 31 '
          'and November 2, families welcome their departed with offerings of '
          'marigold flowers, candles, pan de muerto and the dishes they '
          'loved most. In Xochimilco, the trajineras fill the canals with '
          'light and color to celebrate their memory.',
    ),
    leyendas: [
      Leyenda(
        id: 'ley_llorona',
        titulo: TextoLocal('La Llorona', 'La Llorona'),
        texto: TextoLocal(
          'Dicen que en las noches de niebla se escucha un lamento sobre el '
              'agua: es el de una mujer que busca a sus hijos y vaga por los '
              'canales de Xochimilco.',
          'They say that on foggy nights a wail can be heard over the water: '
              'that of a woman searching for her children, wandering the '
              'canals of Xochimilco.',
        ),
      ),
      Leyenda(
        id: 'ley_muniecas',
        titulo: TextoLocal('La Isla de las Muñecas', 'The Island of the Dolls'),
        texto: TextoLocal(
          'En una chinampa cuelgan cientos de muñecas para calmar el alma de '
              'una niña que, según se cuenta, se ahogó en ese lugar.',
          'On one chinampa hundreds of dolls hang to soothe the soul of a '
              'girl who, the story goes, drowned there.',
        ),
      ),
      Leyenda(
        id: 'ley_xolotl',
        titulo: TextoLocal('Xólotl y el ajolote', 'Xólotl and the axolotl'),
        texto: TextoLocal(
          'El dios Xólotl, guía de los muertos, se transformó en ajolote '
              'para escapar del sacrificio y se escondió en las aguas de '
              'Xochimilco.',
          'The god Xólotl, guide of the dead, turned into an axolotl to '
              'escape sacrifice and hid in the waters of Xochimilco.',
        ),
      ),
    ],
    reglas: [
      ReglaNavegacion(
        id: 'regla_chaleco',
        titulo: TextoLocal(
          'Usa el chaleco salvavidas',
          'Wear your life jacket',
        ),
        detalle: TextoLocal(
          'Debe llevarse puesto durante todo el recorrido.',
          'It must be worn for the whole tour.',
        ),
      ),
      ReglaNavegacion(
        id: 'regla_sentado',
        titulo: TextoLocal('Permanece sentado', 'Stay seated'),
        detalle: TextoLocal(
          'No te pares ni cambies de lugar mientras la trajinera avanza.',
          'Do not stand up or change seats while the trajinera is moving.',
        ),
      ),
      ReglaNavegacion(
        id: 'regla_capacidad',
        titulo: TextoLocal('Respeta la capacidad', 'Respect the capacity'),
        detalle: TextoLocal(
          'No se permite subir más pasajeros que los reservados.',
          'No more passengers than those booked may board.',
        ),
      ),
      ReglaNavegacion(
        id: 'regla_basura',
        titulo: TextoLocal('Cuida los canales', 'Take care of the canals'),
        detalle: TextoLocal(
          'No tires basura ni objetos al agua.',
          'Do not throw trash or objects into the water.',
        ),
      ),
    ],
    // TODO: faltan 4 de las 5 respuestas; las de abajo son borradores.
    preguntas: [
      PreguntaFrecuente(
        id: 'faq_1',
        pregunta: TextoLocal(
          '¿Con cuánta anticipación debo llegar?',
          'How early should I arrive?',
        ),
        respuesta: TextoLocal(
          'Preséntate 30 minutos antes de la salida en el embarcadero.',
          'Arrive at the pier 30 minutes before departure.',
        ),
      ),
      PreguntaFrecuente(
        id: 'faq_2',
        pregunta: TextoLocal(
          '¿Puedo cancelar mi reservación?',
          'Can I cancel my booking?',
        ),
        respuesta: TextoLocal(
          'Sí. Con más de 24 horas de anticipación se reembolsa el anticipo; '
              'con 24 horas o menos se cancela sin reembolso.',
          'Yes. With more than 24 hours notice the deposit is refunded; with '
              '24 hours or less it is cancelled without a refund.',
        ),
      ),
      PreguntaFrecuente(
        id: 'faq_3',
        pregunta: TextoLocal('¿Qué pasa si llueve?', 'What if it rains?'),
        respuesta: TextoLocal(
          'Las trajineras operan con lluvia ligera. Si el servicio se '
              'suspende, te contactaremos para cambiar tu fecha.',
          'Trajineras run in light rain. If service is suspended, we will '
              'contact you to change your date.',
        ),
      ),
      PreguntaFrecuente(
        id: 'faq_4',
        pregunta: TextoLocal(
          '¿Pueden subir niños y personas mayores?',
          'Can children and older adults come aboard?',
        ),
        respuesta: TextoLocal(
          'Sí. Todos usan chaleco salvavidas; la trajinera Lucero es '
              'accesible.',
          'Yes. Everyone wears a life jacket; the Lucero trajinera is '
              'accessible.',
        ),
      ),
      PreguntaFrecuente(
        id: 'faq_5',
        pregunta: TextoLocal(
          '¿Puedo llevar mi propia comida?',
          'Can I bring my own food?',
        ),
        respuesta: TextoLocal(
          'Puedes contratar la cena tradicional como servicio adicional. '
              'Consulta las reglas del embarcadero para alimentos propios.',
          'You can add the traditional dinner as an extra service. Check the '
              'pier rules about bringing your own food.',
        ),
      ),
    ],
    // TODO: redactar el aviso de privacidad definitivo.
    avisoPrivacidad: TextoLocal(
      'Usamos tu nombre, teléfono y correo solo para gestionar tu '
          'reservación. No pedimos datos de tarjeta ni compartimos tu '
          'información con terceros.',
      'We use your name, phone number and email only to manage your '
          'booking. We do not ask for card details or share your information '
          'with third parties.',
    ),
    // TODO: teléfono y correo ficticios; que no puedan ser de una persona
    // real.
    telefonoContacto: '5555550100',
    correoContacto: 'contacto@trajineras.example',
    horarioAtencion: TextoLocal(
      'Atención a clientes: 9:00 – 21:00',
      'Customer service: 9:00 AM – 9:00 PM',
    ),
  );

  static List<Reservacion> reservasSemilla(Temporada temporada) {
    if (!cargarReservasDemo) return const [];

    final anio = temporada.inicio.year;
    final aa = (anio % 100).toString().padLeft(2, '0');
    final inicio = temporada.inicio;
    DateTime dia(int desdeInicio) =>
        DateTime(inicio.year, inicio.month, inicio.day + desdeInicio);

    const lucia = Contacto(
      nombre: 'Lucía Hernández',
      telefono: '5512345678',
      correo: 'lucia.hdz@correo.com',
    );
    const otro = Contacto(
      nombre: 'Cliente de ejemplo',
      telefono: '5555550199',
      correo: 'cliente@ejemplo.com',
    );
    final creada = dia(-10);

    Reservacion reserva({
      required String folio,
      required String usuarioId,
      required Ruta ruta,
      required Trajinera trajinera,
      required DateTime fecha,
      required String horario,
      required int pasajeros,
      required Contacto contacto,
      List<ServicioAdicional> extras = const [],
      required EstadoReservacion estado,
      DateTime? creadaEn,
      MetodoPago? metodoPago,
      DateTime? pagadaEn,
      DateTime? canceladaEn,
      int montoReembolsado = 0,
    }) {
      final costos = Costos.calcular(
        tarifaTrajinera: trajinera.tarifa,
        precioPorPersona: ruta.precioPorPersona,
        pasajeros: pasajeros,
        servicios: extras.map((s) => s.precio),
      );
      return Reservacion(
        folio: folio,
        usuarioId: usuarioId,
        rutaId: ruta.id,
        trajineraId: trajinera.id,
        fecha: _fechaIso(fecha),
        horario: horario,
        pasajeros: pasajeros,
        contacto: contacto,
        serviciosIds: [for (final s in extras) s.id],
        tarifaTrajinera: trajinera.tarifa,
        precioPorPersona: ruta.precioPorPersona,
        preciosServicios: {for (final s in extras) s.id: s.precio},
        subtotal: costos.subtotal,
        anticipo: costos.anticipo,
        estado: estado,
        creadaEn: creadaEn ?? creada,
        metodoPago: metodoPago,
        pagadaEn: pagadaEn,
        canceladaEn: canceladaEn,
        montoReembolsado: montoReembolsado,
      );
    }

    final animas = rutas[0];
    final cempasuchil = rutas[1];
    final catrina = trajineras[0];
    final flor = trajineras[1];
    final xochitl = trajineras[2];
    final lucero = trajineras[3];
    final fotografo = servicios[2];

    final semilla = <Reservacion>[
      reserva(
        folio: 'DM-$aa-K7Q2',
        usuarioId: usuarioDemoId,
        ruta: animas,
        trajinera: catrina,
        fecha: dia(6),
        horario: '18:00',
        pasajeros: 12,
        contacto: lucia,
        extras: [fotografo],
        estado: EstadoReservacion.pagada,
        metodoPago: MetodoPago.tarjeta,
        pagadaEn: dia(-9),
      ),
      reserva(
        folio: 'DM-$aa-A3F9',
        usuarioId: usuarioDemoId,
        ruta: cempasuchil,
        trajinera: flor,
        fecha: dia(7),
        horario: '14:00',
        pasajeros: 6,
        contacto: lucia,
        estado: EstadoReservacion.pendiente,
        metodoPago: MetodoPago.spei,
      ),
      reserva(
        folio: 'DM-$aa-Z81M',
        usuarioId: usuarioDemoId,
        ruta: animas,
        trajinera: xochitl,
        fecha: dia(5),
        horario: '21:00',
        pasajeros: 4,
        contacto: lucia,
        estado: EstadoReservacion.cancelada,
        metodoPago: MetodoPago.tarjeta,
        pagadaEn: dia(-8),
        canceladaEn: dia(-6),
        montoReembolsado: 525,
      ),
      // Otro cliente: La Catrina el 1 nov a las 21:00. Al reservarla ese día,
      // 19:30 y 21:00 salen "Ocupado" (traslape) y 18:00 queda libre.
      reserva(
        folio: 'DM-$aa-R4NB',
        usuarioId: 'u2',
        ruta: animas,
        trajinera: catrina,
        fecha: dia(7),
        horario: '21:00',
        pasajeros: 10,
        contacto: otro,
        estado: EstadoReservacion.pagada,
        metodoPago: MetodoPago.tarjeta,
        pagadaEn: dia(-7),
      ),
    ];

    // Ocupación de Flor de Cempasúchil (~75 %): 3 de cada 4 horarios de la
    // Ruta 2 en toda la temporada, salvo el de A3F9, que ya ocupa su lugar.
    const alfabeto = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    var indice = 0;
    for (var d = 0; ; d++) {
      final fecha = dia(d);
      if (fecha.isAfter(temporada.fin)) break;
      if (temporada.fechasSinServicio.contains(fecha)) continue;
      for (final horario in cempasuchil.horarios) {
        final ocupar = indice % 4 != 3;
        final esDeA3F9 = d == 7 && horario == '14:00';
        if (ocupar && !esDeA3F9) {
          final clave =
              'W${alfabeto[indice ~/ 32 % 32]}'
              '${alfabeto[indice % 32]}${alfabeto[(indice * 7) % 32]}';
          semilla.add(
            reserva(
              folio: 'DM-$aa-$clave',
              usuarioId: 'u_otros',
              ruta: cempasuchil,
              trajinera: flor,
              fecha: fecha,
              horario: horario,
              pasajeros: 6,
              contacto: otro,
              estado: EstadoReservacion.pagada,
              metodoPago: MetodoPago.tarjeta,
              pagadaEn: dia(-5),
            ),
          );
        }
        indice++;
      }
    }

    final aaPrevio = ((anio - 1) % 100).toString().padLeft(2, '0');
    final previa = DateTime(anio - 1, 11, 1);
    semilla.add(
      reserva(
        folio: 'DM-$aaPrevio-P5T8',
        usuarioId: usuarioDemoId,
        ruta: animas,
        trajinera: lucero,
        fecha: previa,
        horario: '19:30',
        pasajeros: 6,
        contacto: lucia,
        estado: EstadoReservacion.pagada,
        creadaEn: DateTime(anio - 1, 10, 15),
        metodoPago: MetodoPago.tarjeta,
        pagadaEn: DateTime(anio - 1, 10, 16),
      ),
    );
    return semilla;
  }

  static String _fechaIso(DateTime f) =>
      '${f.year.toString().padLeft(4, '0')}-'
      '${f.month.toString().padLeft(2, '0')}-'
      '${f.day.toString().padLeft(2, '0')}';
}
