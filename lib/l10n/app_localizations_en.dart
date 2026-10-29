// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appNombre => 'Trajineras';

  @override
  String get volver => 'Back';

  @override
  String get cancelar => 'Cancel';

  @override
  String get guardar => 'Save';

  @override
  String get continuar => 'Continue';

  @override
  String get entendido => 'Got it';

  @override
  String get editar => 'Edit';

  @override
  String get elegir => 'Choose';

  @override
  String get ninguno => 'None';

  @override
  String get verRutas => 'See routes';

  @override
  String get tooltipSeguridad => 'Safety and FAQ';

  @override
  String get errorCargar => 'Couldn\'t load the information';

  @override
  String get errorCargarDetalle => 'Close this screen and try again.';

  @override
  String pasajeros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n passengers',
      one: '1 passenger',
    );
    return '$_temp0';
  }

  @override
  String personas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String precioPorPersona(Object precio) {
    return '$precio / person';
  }

  @override
  String precioMxnPorPersona(Object precio) {
    return '$precio MXN / person';
  }

  @override
  String montoMxn(Object monto) {
    return '$monto MXN';
  }

  @override
  String unirConY(Object inicio, Object ultimo) {
    return '$inicio and $ultimo';
  }

  @override
  String folioConValor(Object folio) {
    return 'Booking ref $folio';
  }

  @override
  String embarcaderoNombre(Object nombre) {
    return '$nombre pier';
  }

  @override
  String get noSePudoAbrir => 'Couldn\'t open this on your device';

  @override
  String get navInicio => 'Home';

  @override
  String get navRutas => 'Routes';

  @override
  String get navReservas => 'My bookings';

  @override
  String get navPerfil => 'Profile';

  @override
  String get bienvenidaSubtitulo => 'Day of the Dead · Xochimilco';

  @override
  String get bienvenidaLema => 'Sail through legends and traditions';

  @override
  String get bienvenidaIdioma => 'Idioma · Language';

  @override
  String get comenzar => 'Get started';

  @override
  String inicioTemporada(Object anio) {
    return '$anio season';
  }

  @override
  String get inicioNoches => 'Nights of the Day of the Dead';

  @override
  String inicioHorario(Object fechas, Object apertura, Object cierre) {
    return '$fechas · $apertura to $cierre';
  }

  @override
  String get reservarAhora => 'Book now';

  @override
  String get explora => 'Explore';

  @override
  String get tradiciones => 'Traditions';

  @override
  String get comoLlegar => 'Getting there';

  @override
  String get seguridadFaq => 'Safety & FAQ';

  @override
  String get proximaReservacion => 'Your next booking';

  @override
  String get misReservaciones => 'My bookings';

  @override
  String get misReservacionesDetalle => 'View, change or cancel';

  @override
  String get avisos => 'Alerts';

  @override
  String get avisosVacio =>
      'You have no alerts yet. You\'ll see what happens with your bookings here.';

  @override
  String avisoReservaCreada(Object folio) {
    return 'You created booking $folio.';
  }

  @override
  String avisoPagoRecibido(Object folio) {
    return 'We received the deposit for $folio.';
  }

  @override
  String avisoCancelacion(Object folio) {
    return 'Booking $folio was cancelled.';
  }

  @override
  String avisoCambio(Object folio) {
    return 'You changed the date of $folio.';
  }

  @override
  String avisoRecordatorio(Object folio) {
    return 'Your tour $folio departs in less than 24 h.';
  }

  @override
  String get perfilTitulo => 'Profile';

  @override
  String get editarPerfil => 'Edit profile';

  @override
  String get perfilActualizado => 'Profile updated';

  @override
  String get datosPersonales => 'Personal details';

  @override
  String get nombreYTelefono => 'Name and phone';

  @override
  String get correoElectronico => 'Email';

  @override
  String get preferencias => 'Preferences';

  @override
  String get idioma => 'Language';

  @override
  String get notificaciones => 'Notifications';

  @override
  String get notificacionesDetalle => 'Updates about your booking';

  @override
  String get recordatorios => 'Reminders';

  @override
  String get recordatoriosDetalle => '24 h before your tour';

  @override
  String get privacidadYAyuda => 'Privacy and help';

  @override
  String get avisoPrivacidad => 'Privacy notice';

  @override
  String get avisoPrivacidadDetalle => 'How we use and protect your data';

  @override
  String get versionApp => 'Trajineras v1.0 · Second term project';

  @override
  String get campoNombre => 'Name';

  @override
  String get campoTelefono => 'Phone';

  @override
  String get rutasTitulo => 'Available routes';

  @override
  String get rutasIntro =>
      'Compare the two themed routes and pick the one you like best.';

  @override
  String get rutasVacio =>
      'There are no routes available yet. Please check back later.';

  @override
  String get comparacion => 'Comparison';

  @override
  String duracionDeRecorrido(Object duracion) {
    return '$duracion tour';
  }

  @override
  String get filaAmbiente => 'Mood';

  @override
  String get filaDuracion => 'Duration';

  @override
  String get filaPrecio => 'Price';

  @override
  String get filaSalida => 'Departure';

  @override
  String get filaHorarios => 'Times';

  @override
  String get filaParadas => 'Stops';

  @override
  String get filaIncluye => 'Includes';

  @override
  String get incluyeRecomendaciones => 'Safety tips';

  @override
  String get incluyeServicios => 'Paid add-on services';

  @override
  String get elegirEstaRuta => 'Choose this route';

  @override
  String get desde => 'From';

  @override
  String get porPersona => 'per person';

  @override
  String hastaN(Object n) {
    return 'Up to $n';
  }

  @override
  String get paradas => 'Stops';

  @override
  String get horarios => 'Times';

  @override
  String get serviciosAdicionales => 'Add-on services';

  @override
  String get recomendacionesSeguridad => 'Safety tips';

  @override
  String verFotoDe(Object nombre) {
    return 'View photo: $nombre';
  }

  @override
  String get seguridadTitulo => 'Safety & FAQ';

  @override
  String get reglasNavegacion => 'Boating rules';

  @override
  String get preguntasFrecuentes => 'Frequently asked questions';

  @override
  String get preguntasVacio => 'There are no frequently asked questions yet.';

  @override
  String get necesitasAyuda => 'Need help?';

  @override
  String get llamar => 'Call';

  @override
  String get correo => 'Email';

  @override
  String get tradicionesTitulo => 'Traditions and legends';

  @override
  String get seccionHistoria => 'History';

  @override
  String get seccionLeyendas => 'Legends';

  @override
  String get seccionGaleria => 'Gallery';

  @override
  String get historiaTitulo => 'History of the Day of the Dead';

  @override
  String get leyendasTitulo => 'Legends of Xochimilco';

  @override
  String get galeriaFotoAnimas => 'Floating offering at dusk';

  @override
  String get galeriaFotoCempasuchil => 'Marigold flowers';

  @override
  String get galeriaFotoTrajinera => 'Trajinera on the canal';

  @override
  String get galeriaFotoEmbarcadero => 'Xochimilco pier';

  @override
  String fotoNDeTotal(Object n, Object total) {
    return 'Photo $n of $total';
  }

  @override
  String get cerrar => 'Close';

  @override
  String get comoLlegarTitulo => 'Getting there';

  @override
  String get embarcaderosVacio => 'There are no piers available right now.';

  @override
  String get indicaciones => 'Directions';

  @override
  String get abrirGoogleMaps => 'Open in Google Maps';

  @override
  String get llamarEmbarcadero => 'Call the pier';

  @override
  String get mapaEmbarcadero => 'Pier';

  @override
  String get puntoEncuentro => 'Meeting point';

  @override
  String embarcaderoYMuelle(Object embarcadero, Object muelle) {
    return '$embarcadero pier · $muelle';
  }

  @override
  String presentateA(Object hora, Object minutos) {
    return 'Arrive by $hora ($minutos min before)';
  }

  @override
  String pasoNDeTotal(Object paso, Object total) {
    return 'Step $paso of $total';
  }

  @override
  String pasoSemantica(Object paso, Object total, Object nombre) {
    return 'Step $paso of $total: $nombre';
  }

  @override
  String get pasoTrajinera => 'Choose a trajinera';

  @override
  String get pasoFecha => 'Date and time';

  @override
  String get pasoDatos => 'Contact details';

  @override
  String get pasoResumen => 'Summary and payment';

  @override
  String get pasoConfirmacion => 'Confirmation';

  @override
  String get flujoIncompleto => 'This booking is no longer in progress.';

  @override
  String get irAInicio => 'Go to Home';

  @override
  String get queRuta => 'Which route?';

  @override
  String get eligeRutaEmpezar => 'Choose a route to start your booking.';

  @override
  String get eligeTuTrajinera => 'Choose your trajinera';

  @override
  String get filtroTodas => 'All';

  @override
  String get filtroAccesibles => 'Accessible';

  @override
  String get filtroGrandes => '15+ people';

  @override
  String get pasajerosEtiqueta => 'Passengers';

  @override
  String get seleccionada => 'Selected';

  @override
  String get deshabilitamosMenorCapacidad =>
      'We disable the ones with less capacity';

  @override
  String get quitarPasajero => 'Remove a passenger';

  @override
  String get agregarPasajero => 'Add a passenger';

  @override
  String ningunaTrajineraLugar(Object pasajeros) {
    return 'No trajinera has room for $pasajeros.';
  }

  @override
  String ningunaTrajineraFiltroLugar(Object filtro, Object pasajeros) {
    return 'No \"$filtro\" trajinera has room for $pasajeros. Lower the number of passengers or remove the filter.';
  }

  @override
  String get motivoMantenimiento =>
      'Under maintenance: out of service this season';

  @override
  String motivoCapacidad(Object pasajeros) {
    return 'Not enough capacity for $pasajeros';
  }

  @override
  String hastaPersonas(Object n) {
    return 'Up to $n people';
  }

  @override
  String tarifaPorRecorrido(Object tarifa) {
    return '$tarifa / tour';
  }

  @override
  String trajineraIncluye(Object lista) {
    return 'Includes $lista';
  }

  @override
  String trajineraExtras(Object lista) {
    return 'Extras: $lista';
  }

  @override
  String get accesible => 'Accessible';

  @override
  String get cambiarReservacion => 'Change booking';

  @override
  String get fechaYHora => 'Date and time';

  @override
  String get sinElegir => 'Not selected';

  @override
  String cambioAviso(Object folio, Object trajinera, Object pasajeros) {
    return 'Choose the new date and time for booking $folio. We\'ll keep $trajinera, $pasajeros, your services and your payment.';
  }

  @override
  String get alguienReservoHorario =>
      'Someone just booked that time. Choose another.';

  @override
  String get noSePudoCambiar => 'Couldn\'t change the booking.';

  @override
  String cambiamosTuTrajinera(Object nombre) {
    return 'We switched your trajinera to $nombre';
  }

  @override
  String get horariosDisponibles => 'Available times';

  @override
  String horariosDisponiblesFecha(Object fecha) {
    return 'Available times · $fecha';
  }

  @override
  String get eligeFechaVerHorarios => 'Pick a date to see the times.';

  @override
  String sinSalidasHoy(Object horas) {
    return 'No departures are left on this day: bookings need at least $horas h notice.';
  }

  @override
  String yaReservadoEn(Object horario, Object trajinera) {
    return '$horario is already booked on $trajinera';
  }

  @override
  String sinHorariosEn(Object trajinera) {
    return 'No times left on this day for $trajinera';
  }

  @override
  String get mesAnterior => 'Previous month';

  @override
  String get mesSiguiente => 'Next month';

  @override
  String get leyendaHoy => 'Today';

  @override
  String get leyendaSinServicio => 'No service (maintenance)';

  @override
  String horarioOcupado(Object horario) {
    return '$horario · Booked';
  }

  @override
  String get verAlternativas => 'See alternatives';

  @override
  String get sinAlternativas =>
      'We couldn\'t find alternatives with room this season.';

  @override
  String get sugerimosAlternativas =>
      'We suggest these alternatives with room available:';

  @override
  String get tusDatos => 'Your details';

  @override
  String get datosIntro =>
      'We\'ll use these details for your receipt and to let you know about changes.';

  @override
  String get nombreResponsable => 'Name of the person in charge';

  @override
  String get ayudaNombre => 'As it appears on your ID';

  @override
  String get ayudaTelefono => '10 digits';

  @override
  String get ayudaCorreo => 'It will appear on your receipt';

  @override
  String get numeroPasajeros => 'Number of passengers';

  @override
  String get corrigeCampos => 'Fix the marked fields to continue.';

  @override
  String get completaDatos => 'Complete your details to continue.';

  @override
  String get aceptaAvisoContinuar => 'Accept the privacy notice to continue.';

  @override
  String get continuarAlResumen => 'Continue to summary';

  @override
  String get aceptoAviso =>
      'I accept the privacy notice and the use of my data for this booking.';

  @override
  String get leerAviso => 'Read privacy notice';

  @override
  String get errNombreVacio => 'Enter your name';

  @override
  String get errNombreLetras => 'Use only letters and spaces';

  @override
  String get errNombreCorto => 'Enter at least 3 letters';

  @override
  String get errTelefonoVacio => 'Enter your phone number';

  @override
  String get errTelefonoLargo => 'The phone number must have 10 digits';

  @override
  String get errCorreoVacio => 'Enter your email';

  @override
  String get errCorreoInvalido => 'Enter a valid email';

  @override
  String get errPasajerosVacio => 'Enter how many passengers there are';

  @override
  String get errPasajerosMinimo => 'There must be at least 1 passenger';

  @override
  String errPasajerosMaximo(Object max) {
    return 'Maximum $max people';
  }

  @override
  String maximoPersonasEn(Object max, Object trajinera) {
    return 'Maximum $max people on $trajinera';
  }

  @override
  String get tuReservacion => 'Your booking';

  @override
  String get filaRuta => 'Route';

  @override
  String get filaTrajinera => 'Trajinera';

  @override
  String get filaFecha => 'Date';

  @override
  String get filaHorario => 'Time';

  @override
  String get filaPasajeros => 'Passengers';

  @override
  String get filaResponsable => 'Contact';

  @override
  String get filaServicios => 'Services';

  @override
  String get filaPago => 'Payment';

  @override
  String get desglose => 'Breakdown';

  @override
  String get politicaCancelacion =>
      'Free cancellation up to 24 h before: the deposit is refunded. After that, the deposit is non-refundable.';

  @override
  String get metodoPagoSimulado => 'Payment method (simulated)';

  @override
  String get pagoDemostracion =>
      'Demo payment: no real charge is made and no card details are requested.';

  @override
  String get anticipo => 'Deposit';

  @override
  String get confirmar => 'Confirm';

  @override
  String get sinServiciosTrajinera =>
      'This trajinera offers no add-on services.';

  @override
  String get pagoTarjeta => 'Debit or credit card';

  @override
  String get pagoSpei => 'Bank transfer / SPEI';

  @override
  String get pagoTarjetaSimulado => 'Card (simulated)';

  @override
  String get pagoSpeiSimulado => 'SPEI (simulated)';

  @override
  String reservaOcupado(Object horario, Object fecha, Object trajinera) {
    return 'Someone just booked $horario on $fecha on $trajinera. Choose another time.';
  }

  @override
  String reservaFechaInvalida(Object horario, Object fecha) {
    return '$horario on $fecha can no longer be booked. Choose another time.';
  }

  @override
  String get reservaSinCapacidad =>
      'The trajinera doesn\'t have room for that many passengers.';

  @override
  String get reservaSinServicio =>
      'The trajinera is no longer in service. Choose another.';

  @override
  String get reservaNoConfirmada => 'Couldn\'t confirm. Please try again.';

  @override
  String tarifaTrajineraNombre(Object nombre) {
    return 'Trajinera fee $nombre';
  }

  @override
  String rutaPrecioPorPersonas(Object precio, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n people',
      one: '1 person',
    );
    return 'Route $precio × $_temp0';
  }

  @override
  String get total => 'Total';

  @override
  String get anticipoHoy => 'Deposit due today (30%)';

  @override
  String get anticipoPorPagar => 'Deposit to pay (30%)';

  @override
  String get anticipoPagado30 => 'Deposit paid (30%)';

  @override
  String get anticipo30 => 'Deposit (30%)';

  @override
  String restanEnEmbarcadero(Object monto) {
    return '$monto remaining at the pier';
  }

  @override
  String get folioMayusculas => 'BOOKING REF';

  @override
  String qrDelFolio(Object folio) {
    return 'QR code for booking $folio';
  }

  @override
  String get confirmacionTitulo => 'Confirmation';

  @override
  String get volverAInicio => 'Back to Home';

  @override
  String get reservacionConfirmada => 'Booking confirmed!';

  @override
  String get comprobanteListo =>
      'Your receipt is ready. Show your booking ref at the pier.';

  @override
  String get simularPagoAnticipo => 'Simulate deposit payment';

  @override
  String get comprobante => 'Receipt';

  @override
  String get irAMisReservaciones => 'Go to my bookings';

  @override
  String get procesandoPago => 'Processing payment…';

  @override
  String get anticipoPagadoMsg => 'Deposit paid';

  @override
  String get noSePudoPagar => 'Couldn\'t record the payment';

  @override
  String get reservacionNoSePuedeCambiar =>
      'This booking can no longer be changed.';

  @override
  String get filtroProximas => 'Upcoming';

  @override
  String get filtroPasadas => 'Past';

  @override
  String get filtroCanceladas => 'Cancelled';

  @override
  String get vacioProximas => 'You have no upcoming bookings';

  @override
  String get vacioPasadas => 'You have no past tours yet';

  @override
  String get vacioCanceladas => 'You have no cancelled bookings';

  @override
  String get eligeRutaYReserva => 'Choose a route and book your trajinera.';

  @override
  String get avisoCancelar24h =>
      'You can cancel free of charge or request a change up to 24 h before the tour.';

  @override
  String canceladaReembolso(Object monto) {
    return 'Booking cancelled. We\'ll refund $monto MXN.';
  }

  @override
  String get canceladaMsg => 'Booking cancelled';

  @override
  String get noSePudoCancelar => 'Couldn\'t cancel the booking';

  @override
  String cambiamosTuReservacion(Object fecha, Object horario) {
    return 'We moved your booking to $fecha · $horario';
  }

  @override
  String montosPagada(Object total) {
    return 'Total $total · Deposit paid';
  }

  @override
  String montosPendiente(Object total, Object anticipo) {
    return 'Total $total · Deposit $anticipo';
  }

  @override
  String montosReembolsado(Object monto) {
    return 'Deposit refunded ($monto)';
  }

  @override
  String montosSinReembolso(Object monto) {
    return 'Deposit not refunded ($monto)';
  }

  @override
  String get montosCanceladaSinCargo => 'Cancelled at no charge';

  @override
  String get pagar => 'Pay';

  @override
  String get detalle => 'Details';

  @override
  String get cambiar => 'Change';

  @override
  String get dialogoCancelarTitulo => 'Cancel booking?';

  @override
  String get siCancelar => 'Yes, cancel';

  @override
  String cancelarSinCargo(Object dia, Object folio) {
    return 'Your tour on $dia (ref $folio) has no deposit payment yet, so it will be cancelled at no charge.';
  }

  @override
  String cancelarConReembolso(Object dia, Object folio, Object anticipo) {
    return 'Your tour on $dia (ref $folio) is more than 24 h away, so your $anticipo deposit will be refunded in 3 to 5 business days.';
  }

  @override
  String cancelarSinReembolso(Object dia, Object folio, Object anticipo) {
    return 'Your tour on $dia (ref $folio) is 24 h away or less, so your $anticipo deposit will not be refunded.';
  }

  @override
  String get detalleReservacionTitulo => 'Booking details';

  @override
  String get reservacionNoEncontrada => 'We couldn\'t find this booking.';

  @override
  String detalleCanceladaReembolso(Object monto) {
    return 'Booking cancelled. $monto will be refunded in 3 to 5 business days.';
  }

  @override
  String get detalleCancelada => 'Booking cancelled.';

  @override
  String get estadoDisponible => 'Available';

  @override
  String get estadoPocosLugares => 'Few spots left';

  @override
  String get estadoSinServicio => 'Out of service';

  @override
  String get estadoPendiente => 'Pending verification';

  @override
  String get estadoPagada => 'Paid';

  @override
  String get estadoCancelada => 'Cancelled';
}
