// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appNombre => 'Trajineras';

  @override
  String get volver => 'Volver';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get guardar => 'Guardar';

  @override
  String get continuar => 'Continuar';

  @override
  String get entendido => 'Entendido';

  @override
  String get editar => 'Editar';

  @override
  String get elegir => 'Elegir';

  @override
  String get ninguno => 'Ninguno';

  @override
  String get verRutas => 'Ver rutas';

  @override
  String get tooltipSeguridad => 'Seguridad y preguntas frecuentes';

  @override
  String get errorCargar => 'No se pudo cargar la información';

  @override
  String get errorCargarDetalle => 'Cierra esta pantalla e inténtalo de nuevo.';

  @override
  String pasajeros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pasajeros',
      one: '1 pasajero',
    );
    return '$_temp0';
  }

  @override
  String personas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n personas',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String precioPorPersona(Object precio) {
    return '$precio / persona';
  }

  @override
  String precioMxnPorPersona(Object precio) {
    return '$precio MXN / persona';
  }

  @override
  String montoMxn(Object monto) {
    return '$monto MXN';
  }

  @override
  String unirConY(Object inicio, Object ultimo) {
    return '$inicio y $ultimo';
  }

  @override
  String folioConValor(Object folio) {
    return 'Folio $folio';
  }

  @override
  String embarcaderoNombre(Object nombre) {
    return 'Embarcadero $nombre';
  }

  @override
  String get noSePudoAbrir => 'No se pudo abrir en este dispositivo';

  @override
  String get navInicio => 'Inicio';

  @override
  String get navRutas => 'Rutas';

  @override
  String get navReservas => 'Mis reservas';

  @override
  String get navPerfil => 'Perfil';

  @override
  String get bienvenidaSubtitulo => 'Día de Muertos · Xochimilco';

  @override
  String get bienvenidaLema => 'Navega entre leyendas y tradiciones';

  @override
  String get bienvenidaIdioma => 'Idioma · Language';

  @override
  String get comenzar => 'Comenzar';

  @override
  String inicioTemporada(Object anio) {
    return 'Temporada $anio';
  }

  @override
  String get inicioNoches => 'Noches de Día de Muertos';

  @override
  String inicioHorario(Object fechas, Object apertura, Object cierre) {
    return '$fechas · $apertura a $cierre h';
  }

  @override
  String get reservarAhora => 'Reservar ahora';

  @override
  String get explora => 'Explora';

  @override
  String get tradiciones => 'Tradiciones';

  @override
  String get comoLlegar => 'Cómo llegar';

  @override
  String get seguridadFaq => 'Seguridad y FAQ';

  @override
  String get proximaReservacion => 'Tu próxima reservación';

  @override
  String get misReservaciones => 'Mis reservaciones';

  @override
  String get misReservacionesDetalle => 'Consulta, cambia o cancela';

  @override
  String get avisos => 'Avisos';

  @override
  String get avisosVacio =>
      'Aún no tienes avisos. Aquí verás lo que pase con tus reservaciones.';

  @override
  String avisoReservaCreada(Object folio) {
    return 'Creaste la reservación $folio.';
  }

  @override
  String avisoPagoRecibido(Object folio) {
    return 'Recibimos el anticipo de $folio.';
  }

  @override
  String avisoCancelacion(Object folio) {
    return 'Se canceló la reservación $folio.';
  }

  @override
  String avisoCambio(Object folio) {
    return 'Cambiaste la fecha de $folio.';
  }

  @override
  String avisoRecordatorio(Object folio) {
    return 'Tu recorrido $folio sale en menos de 24 h.';
  }

  @override
  String get perfilTitulo => 'Perfil';

  @override
  String get editarPerfil => 'Editar perfil';

  @override
  String get perfilActualizado => 'Perfil actualizado';

  @override
  String get datosPersonales => 'Datos personales';

  @override
  String get nombreYTelefono => 'Nombre y teléfono';

  @override
  String get correoElectronico => 'Correo electrónico';

  @override
  String get preferencias => 'Preferencias';

  @override
  String get idioma => 'Idioma';

  @override
  String get notificaciones => 'Notificaciones';

  @override
  String get notificacionesDetalle => 'Avisos sobre tu reservación';

  @override
  String get recordatorios => 'Recordatorios';

  @override
  String get recordatoriosDetalle => '24 h antes del recorrido';

  @override
  String get privacidadYAyuda => 'Privacidad y ayuda';

  @override
  String get avisoPrivacidad => 'Aviso de privacidad';

  @override
  String get avisoPrivacidadDetalle => 'Cómo usamos y protegemos tus datos';

  @override
  String get versionApp => 'Trajineras v1.0 · Segundo parcial';

  @override
  String get campoNombre => 'Nombre';

  @override
  String get campoTelefono => 'Teléfono';

  @override
  String get rutasTitulo => 'Rutas disponibles';

  @override
  String get rutasIntro =>
      'Compara las dos rutas temáticas y elige la que más te guste.';

  @override
  String get rutasVacio => 'Aún no hay rutas disponibles. Vuelve más tarde.';

  @override
  String get comparacion => 'Comparación';

  @override
  String duracionDeRecorrido(Object duracion) {
    return '$duracion de recorrido';
  }

  @override
  String get filaAmbiente => 'Ambiente';

  @override
  String get filaDuracion => 'Duración';

  @override
  String get filaPrecio => 'Precio';

  @override
  String get filaSalida => 'Salida';

  @override
  String get filaHorarios => 'Horarios';

  @override
  String get filaParadas => 'Paradas';

  @override
  String get filaIncluye => 'Incluye';

  @override
  String get incluyeRecomendaciones => 'Recomendaciones de seguridad';

  @override
  String get incluyeServicios => 'Servicios adicionales con precio';

  @override
  String get elegirEstaRuta => 'Elegir esta ruta';

  @override
  String get desde => 'Desde';

  @override
  String get porPersona => 'por persona';

  @override
  String hastaN(Object n) {
    return 'Hasta $n';
  }

  @override
  String get paradas => 'Paradas';

  @override
  String get horarios => 'Horarios';

  @override
  String get serviciosAdicionales => 'Servicios adicionales';

  @override
  String get recomendacionesSeguridad => 'Recomendaciones de seguridad';

  @override
  String verFotoDe(Object nombre) {
    return 'Ver foto: $nombre';
  }

  @override
  String get seguridadTitulo => 'Seguridad y FAQ';

  @override
  String get reglasNavegacion => 'Reglas de navegación';

  @override
  String get preguntasFrecuentes => 'Preguntas frecuentes';

  @override
  String get preguntasVacio => 'Todavía no hay preguntas frecuentes.';

  @override
  String get necesitasAyuda => '¿Necesitas ayuda?';

  @override
  String get llamar => 'Llamar';

  @override
  String get correo => 'Correo';

  @override
  String get tradicionesTitulo => 'Tradiciones y leyendas';

  @override
  String get seccionHistoria => 'Historia';

  @override
  String get seccionLeyendas => 'Leyendas';

  @override
  String get seccionGaleria => 'Galería';

  @override
  String get historiaTitulo => 'Historia del Día de Muertos';

  @override
  String get leyendasTitulo => 'Leyendas de Xochimilco';

  @override
  String get galeriaFotoAnimas => 'Ofrenda flotante al anochecer';

  @override
  String get galeriaFotoCempasuchil => 'Flores de cempasúchil';

  @override
  String get galeriaFotoTrajinera => 'Trajinera en el canal';

  @override
  String get galeriaFotoEmbarcadero => 'Embarcadero de Xochimilco';

  @override
  String fotoNDeTotal(Object n, Object total) {
    return 'Foto $n de $total';
  }

  @override
  String get cerrar => 'Cerrar';

  @override
  String get comoLlegarTitulo => 'Cómo llegar';

  @override
  String get embarcaderosVacio => 'No hay embarcaderos disponibles por ahora.';

  @override
  String get indicaciones => 'Indicaciones';

  @override
  String get abrirGoogleMaps => 'Abrir en Google Maps';

  @override
  String get llamarEmbarcadero => 'Llamar al embarcadero';

  @override
  String get mapaEmbarcadero => 'Embarcadero';

  @override
  String get puntoEncuentro => 'Punto de encuentro';

  @override
  String embarcaderoYMuelle(Object embarcadero, Object muelle) {
    return 'Embarcadero $embarcadero · $muelle';
  }

  @override
  String presentateA(Object hora, Object minutos) {
    return 'Preséntate a las $hora ($minutos min antes)';
  }

  @override
  String pasoNDeTotal(Object paso, Object total) {
    return 'Paso $paso de $total';
  }

  @override
  String pasoSemantica(Object paso, Object total, Object nombre) {
    return 'Paso $paso de $total: $nombre';
  }

  @override
  String get pasoTrajinera => 'Elige trajinera';

  @override
  String get pasoFecha => 'Fecha y horario';

  @override
  String get pasoDatos => 'Datos de contacto';

  @override
  String get pasoResumen => 'Resumen y pago';

  @override
  String get pasoConfirmacion => 'Confirmación';

  @override
  String get flujoIncompleto => 'Esta reservación ya no está en curso.';

  @override
  String get irAInicio => 'Ir a Inicio';

  @override
  String get queRuta => '¿Qué ruta?';

  @override
  String get eligeRutaEmpezar => 'Elige la ruta para empezar tu reservación.';

  @override
  String get eligeTuTrajinera => 'Elige tu trajinera';

  @override
  String get filtroTodas => 'Todas';

  @override
  String get filtroAccesibles => 'Accesibles';

  @override
  String get filtroGrandes => '15+ personas';

  @override
  String get pasajerosEtiqueta => 'Pasajeros';

  @override
  String get seleccionada => 'Seleccionada';

  @override
  String get deshabilitamosMenorCapacidad =>
      'Deshabilitamos las de menor capacidad';

  @override
  String get quitarPasajero => 'Quitar un pasajero';

  @override
  String get agregarPasajero => 'Agregar un pasajero';

  @override
  String ningunaTrajineraLugar(Object pasajeros) {
    return 'Ninguna trajinera tiene lugar para $pasajeros.';
  }

  @override
  String ningunaTrajineraFiltroLugar(Object filtro, Object pasajeros) {
    return 'Ninguna trajinera de \"$filtro\" tiene lugar para $pasajeros. Baja el número de pasajeros o quita el filtro.';
  }

  @override
  String get motivoMantenimiento =>
      'En mantenimiento: sin servicio esta temporada';

  @override
  String motivoCapacidad(Object pasajeros) {
    return 'Capacidad insuficiente para $pasajeros';
  }

  @override
  String hastaPersonas(Object n) {
    return 'Hasta $n personas';
  }

  @override
  String tarifaPorRecorrido(Object tarifa) {
    return '$tarifa / recorrido';
  }

  @override
  String trajineraIncluye(Object lista) {
    return 'Incluye $lista';
  }

  @override
  String trajineraExtras(Object lista) {
    return 'Extras: $lista';
  }

  @override
  String get accesible => 'Accesible';

  @override
  String get cambiarReservacion => 'Cambiar reservación';

  @override
  String get fechaYHora => 'Fecha y hora';

  @override
  String get sinElegir => 'Sin elegir';

  @override
  String cambioAviso(Object folio, Object trajinera, Object pasajeros) {
    return 'Elige la nueva fecha y horario del folio $folio. Se conservan $trajinera, $pasajeros, tus servicios y tu pago.';
  }

  @override
  String get alguienReservoHorario =>
      'Alguien acaba de reservar ese horario. Elige otro.';

  @override
  String get noSePudoCambiar => 'No se pudo cambiar la reservación.';

  @override
  String cambiamosTuTrajinera(Object nombre) {
    return 'Cambiamos tu trajinera a $nombre';
  }

  @override
  String get horariosDisponibles => 'Horarios disponibles';

  @override
  String horariosDisponiblesFecha(Object fecha) {
    return 'Horarios disponibles · $fecha';
  }

  @override
  String get eligeFechaVerHorarios => 'Elige una fecha para ver los horarios.';

  @override
  String sinSalidasHoy(Object horas) {
    return 'Ya no quedan salidas este día: se reserva con al menos $horas h de anticipación.';
  }

  @override
  String yaReservadoEn(Object horario, Object trajinera) {
    return '$horario ya está reservado en $trajinera';
  }

  @override
  String sinHorariosEn(Object trajinera) {
    return 'No quedan horarios este día en $trajinera';
  }

  @override
  String get mesAnterior => 'Mes anterior';

  @override
  String get mesSiguiente => 'Mes siguiente';

  @override
  String get leyendaHoy => 'Hoy';

  @override
  String get leyendaSinServicio => 'Sin servicio (mantenimiento)';

  @override
  String horarioOcupado(Object horario) {
    return '$horario · Ocupado';
  }

  @override
  String get verAlternativas => 'Ver alternativas';

  @override
  String get sinAlternativas =>
      'No encontramos alternativas con lugar esta temporada.';

  @override
  String get sugerimosAlternativas =>
      'Te sugerimos estas alternativas con lugar disponible:';

  @override
  String get tusDatos => 'Tus datos';

  @override
  String get datosIntro =>
      'Usaremos estos datos para tu comprobante y para avisarte de cambios.';

  @override
  String get nombreResponsable => 'Nombre del responsable';

  @override
  String get ayudaNombre => 'Como aparece en tu identificación';

  @override
  String get ayudaTelefono => '10 dígitos';

  @override
  String get ayudaCorreo => 'Aparecerá en tu comprobante';

  @override
  String get numeroPasajeros => 'Número de pasajeros';

  @override
  String get corrigeCampos => 'Corrige los campos marcados para continuar.';

  @override
  String get completaDatos => 'Completa tus datos para continuar.';

  @override
  String get aceptaAvisoContinuar =>
      'Acepta el aviso de privacidad para continuar.';

  @override
  String get continuarAlResumen => 'Continuar al resumen';

  @override
  String get aceptoAviso =>
      'Acepto el aviso de privacidad y el uso de mis datos para esta reservación.';

  @override
  String get leerAviso => 'Leer aviso de privacidad';

  @override
  String get errNombreVacio => 'Escribe tu nombre';

  @override
  String get errNombreLetras => 'Usa solo letras y espacios';

  @override
  String get errNombreCorto => 'Escribe al menos 3 letras';

  @override
  String get errTelefonoVacio => 'Escribe tu teléfono';

  @override
  String get errTelefonoLargo => 'El teléfono debe tener 10 dígitos';

  @override
  String get errCorreoVacio => 'Escribe tu correo';

  @override
  String get errCorreoInvalido => 'Escribe un correo válido';

  @override
  String get errPasajerosVacio => 'Escribe cuántos pasajeros son';

  @override
  String get errPasajerosMinimo => 'Debe haber al menos 1 pasajero';

  @override
  String errPasajerosMaximo(Object max) {
    return 'Máximo $max personas';
  }

  @override
  String maximoPersonasEn(Object max, Object trajinera) {
    return 'Máximo $max personas en $trajinera';
  }

  @override
  String get tuReservacion => 'Tu reservación';

  @override
  String get filaRuta => 'Ruta';

  @override
  String get filaTrajinera => 'Trajinera';

  @override
  String get filaFecha => 'Fecha';

  @override
  String get filaHorario => 'Horario';

  @override
  String get filaPasajeros => 'Pasajeros';

  @override
  String get filaResponsable => 'Responsable';

  @override
  String get filaServicios => 'Servicios';

  @override
  String get filaPago => 'Pago';

  @override
  String get desglose => 'Desglose';

  @override
  String get politicaCancelacion =>
      'Cancelación sin costo hasta 24 h antes: se reembolsa el anticipo. Después de ese plazo el anticipo no es reembolsable.';

  @override
  String get metodoPagoSimulado => 'Método de pago (simulado)';

  @override
  String get pagoDemostracion =>
      'Pago de demostración: no se realiza ningún cargo real ni se piden datos de tarjeta.';

  @override
  String get anticipo => 'Anticipo';

  @override
  String get confirmar => 'Confirmar';

  @override
  String get sinServiciosTrajinera =>
      'Esta trajinera no ofrece servicios adicionales.';

  @override
  String get pagoTarjeta => 'Tarjeta de débito o crédito';

  @override
  String get pagoSpei => 'Transferencia / SPEI';

  @override
  String get pagoTarjetaSimulado => 'Tarjeta (simulado)';

  @override
  String get pagoSpeiSimulado => 'SPEI (simulado)';

  @override
  String reservaOcupado(Object horario, Object fecha, Object trajinera) {
    return 'Alguien acaba de reservar las $horario del $fecha en $trajinera. Elige otro horario.';
  }

  @override
  String reservaFechaInvalida(Object horario, Object fecha) {
    return 'Las $horario del $fecha ya no se pueden reservar. Elige otro horario.';
  }

  @override
  String get reservaSinCapacidad =>
      'La trajinera no tiene lugar para tantos pasajeros.';

  @override
  String get reservaSinServicio =>
      'La trajinera ya no tiene servicio. Elige otra.';

  @override
  String get reservaNoConfirmada => 'No se pudo confirmar. Intenta de nuevo.';

  @override
  String tarifaTrajineraNombre(Object nombre) {
    return 'Tarifa trajinera $nombre';
  }

  @override
  String rutaPrecioPorPersonas(Object precio, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n personas',
      one: '1 persona',
    );
    return 'Ruta $precio × $_temp0';
  }

  @override
  String get total => 'Total';

  @override
  String get anticipoHoy => 'Anticipo a pagar hoy (30 %)';

  @override
  String get anticipoPorPagar => 'Anticipo por pagar (30 %)';

  @override
  String get anticipoPagado30 => 'Anticipo pagado (30 %)';

  @override
  String get anticipo30 => 'Anticipo (30 %)';

  @override
  String restanEnEmbarcadero(Object monto) {
    return 'Restan $monto en el embarcadero';
  }

  @override
  String get folioMayusculas => 'FOLIO';

  @override
  String qrDelFolio(Object folio) {
    return 'Código QR del folio $folio';
  }

  @override
  String get confirmacionTitulo => 'Confirmación';

  @override
  String get volverAInicio => 'Volver a Inicio';

  @override
  String get reservacionConfirmada => '¡Reservación confirmada!';

  @override
  String get comprobanteListo =>
      'Tu comprobante está listo. Muestra tu folio en el embarcadero.';

  @override
  String get simularPagoAnticipo => 'Simular pago del anticipo';

  @override
  String get comprobante => 'Comprobante';

  @override
  String get irAMisReservaciones => 'Ir a mis reservaciones';

  @override
  String get procesandoPago => 'Procesando pago…';

  @override
  String get anticipoPagadoMsg => 'Anticipo pagado';

  @override
  String get noSePudoPagar => 'No se pudo registrar el pago';

  @override
  String get reservacionNoSePuedeCambiar =>
      'Esta reservación ya no se puede cambiar.';

  @override
  String get filtroProximas => 'Próximas';

  @override
  String get filtroPasadas => 'Pasadas';

  @override
  String get filtroCanceladas => 'Canceladas';

  @override
  String get vacioProximas => 'No tienes reservaciones próximas';

  @override
  String get vacioPasadas => 'Aún no tienes recorridos pasados';

  @override
  String get vacioCanceladas => 'No tienes reservaciones canceladas';

  @override
  String get eligeRutaYReserva => 'Elige una ruta y reserva tu trajinera.';

  @override
  String get avisoCancelar24h =>
      'Puedes cancelar sin costo o solicitar un cambio hasta 24 h antes del recorrido.';

  @override
  String canceladaReembolso(Object monto) {
    return 'Reservación cancelada. Reembolsaremos $monto MXN.';
  }

  @override
  String get canceladaMsg => 'Reservación cancelada';

  @override
  String get noSePudoCancelar => 'No se pudo cancelar la reservación';

  @override
  String cambiamosTuReservacion(Object fecha, Object horario) {
    return 'Cambiamos tu reservación al $fecha · $horario';
  }

  @override
  String montosPagada(Object total) {
    return 'Total $total · Anticipo pagado';
  }

  @override
  String montosPendiente(Object total, Object anticipo) {
    return 'Total $total · Anticipo $anticipo';
  }

  @override
  String montosReembolsado(Object monto) {
    return 'Anticipo reembolsado ($monto)';
  }

  @override
  String montosSinReembolso(Object monto) {
    return 'Anticipo sin reembolso ($monto)';
  }

  @override
  String get montosCanceladaSinCargo => 'Cancelada sin cargo';

  @override
  String get pagar => 'Pagar';

  @override
  String get detalle => 'Detalle';

  @override
  String get cambiar => 'Cambiar';

  @override
  String get dialogoCancelarTitulo => '¿Cancelar reservación?';

  @override
  String get siCancelar => 'Sí, cancelar';

  @override
  String cancelarSinCargo(Object dia, Object folio) {
    return 'Tu recorrido del $dia (folio $folio) aún no tiene pago del anticipo, así que se cancelará sin cargo.';
  }

  @override
  String cancelarConReembolso(Object dia, Object folio, Object anticipo) {
    return 'Tu recorrido del $dia (folio $folio) es en más de 24 h, así que se reembolsará tu anticipo de $anticipo en 3 a 5 días hábiles.';
  }

  @override
  String cancelarSinReembolso(Object dia, Object folio, Object anticipo) {
    return 'Tu recorrido del $dia (folio $folio) es en 24 h o menos, así que no se reembolsará tu anticipo de $anticipo.';
  }

  @override
  String get detalleReservacionTitulo => 'Detalle de reservación';

  @override
  String get reservacionNoEncontrada => 'No encontramos esta reservación.';

  @override
  String detalleCanceladaReembolso(Object monto) {
    return 'Reservación cancelada. Se reembolsan $monto en 3 a 5 días hábiles.';
  }

  @override
  String get detalleCancelada => 'Reservación cancelada.';

  @override
  String get estadoDisponible => 'Disponible';

  @override
  String get estadoPocosLugares => 'Pocos lugares';

  @override
  String get estadoSinServicio => 'Sin servicio';

  @override
  String get estadoPendiente => 'Pendiente de verificación';

  @override
  String get estadoPagada => 'Pagada';

  @override
  String get estadoCancelada => 'Cancelada';
}
