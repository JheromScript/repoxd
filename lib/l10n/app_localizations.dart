import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appNombre.
  ///
  /// In es, this message translates to:
  /// **'Trajineras'**
  String get appNombre;

  /// No description provided for @volver.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get volver;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @continuar.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continuar;

  /// No description provided for @entendido.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get entendido;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @elegir.
  ///
  /// In es, this message translates to:
  /// **'Elegir'**
  String get elegir;

  /// No description provided for @ninguno.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get ninguno;

  /// No description provided for @verRutas.
  ///
  /// In es, this message translates to:
  /// **'Ver rutas'**
  String get verRutas;

  /// No description provided for @tooltipSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Seguridad y preguntas frecuentes'**
  String get tooltipSeguridad;

  /// No description provided for @errorCargar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la información'**
  String get errorCargar;

  /// No description provided for @errorCargarDetalle.
  ///
  /// In es, this message translates to:
  /// **'Cierra esta pantalla e inténtalo de nuevo.'**
  String get errorCargarDetalle;

  /// No description provided for @pasajeros.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 pasajero} other{{n} pasajeros}}'**
  String pasajeros(int n);

  /// No description provided for @personas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 persona} other{{n} personas}}'**
  String personas(int n);

  /// No description provided for @precioPorPersona.
  ///
  /// In es, this message translates to:
  /// **'{precio} / persona'**
  String precioPorPersona(Object precio);

  /// No description provided for @precioMxnPorPersona.
  ///
  /// In es, this message translates to:
  /// **'{precio} MXN / persona'**
  String precioMxnPorPersona(Object precio);

  /// No description provided for @montoMxn.
  ///
  /// In es, this message translates to:
  /// **'{monto} MXN'**
  String montoMxn(Object monto);

  /// No description provided for @unirConY.
  ///
  /// In es, this message translates to:
  /// **'{inicio} y {ultimo}'**
  String unirConY(Object inicio, Object ultimo);

  /// No description provided for @folioConValor.
  ///
  /// In es, this message translates to:
  /// **'Folio {folio}'**
  String folioConValor(Object folio);

  /// No description provided for @embarcaderoNombre.
  ///
  /// In es, this message translates to:
  /// **'Embarcadero {nombre}'**
  String embarcaderoNombre(Object nombre);

  /// No description provided for @noSePudoAbrir.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir en este dispositivo'**
  String get noSePudoAbrir;

  /// No description provided for @navInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// No description provided for @navRutas.
  ///
  /// In es, this message translates to:
  /// **'Rutas'**
  String get navRutas;

  /// No description provided for @navReservas.
  ///
  /// In es, this message translates to:
  /// **'Mis reservas'**
  String get navReservas;

  /// No description provided for @navPerfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navPerfil;

  /// No description provided for @bienvenidaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Día de Muertos · Xochimilco'**
  String get bienvenidaSubtitulo;

  /// No description provided for @bienvenidaLema.
  ///
  /// In es, this message translates to:
  /// **'Navega entre leyendas y tradiciones'**
  String get bienvenidaLema;

  /// No description provided for @bienvenidaIdioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma · Language'**
  String get bienvenidaIdioma;

  /// No description provided for @comenzar.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get comenzar;

  /// No description provided for @inicioTemporada.
  ///
  /// In es, this message translates to:
  /// **'Temporada {anio}'**
  String inicioTemporada(Object anio);

  /// No description provided for @inicioNoches.
  ///
  /// In es, this message translates to:
  /// **'Noches de Día de Muertos'**
  String get inicioNoches;

  /// No description provided for @inicioHorario.
  ///
  /// In es, this message translates to:
  /// **'{fechas} · {apertura} a {cierre} h'**
  String inicioHorario(Object fechas, Object apertura, Object cierre);

  /// No description provided for @reservarAhora.
  ///
  /// In es, this message translates to:
  /// **'Reservar ahora'**
  String get reservarAhora;

  /// No description provided for @explora.
  ///
  /// In es, this message translates to:
  /// **'Explora'**
  String get explora;

  /// No description provided for @tradiciones.
  ///
  /// In es, this message translates to:
  /// **'Tradiciones'**
  String get tradiciones;

  /// No description provided for @comoLlegar.
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get comoLlegar;

  /// No description provided for @seguridadFaq.
  ///
  /// In es, this message translates to:
  /// **'Seguridad y FAQ'**
  String get seguridadFaq;

  /// No description provided for @proximaReservacion.
  ///
  /// In es, this message translates to:
  /// **'Tu próxima reservación'**
  String get proximaReservacion;

  /// No description provided for @misReservaciones.
  ///
  /// In es, this message translates to:
  /// **'Mis reservaciones'**
  String get misReservaciones;

  /// No description provided for @misReservacionesDetalle.
  ///
  /// In es, this message translates to:
  /// **'Consulta, cambia o cancela'**
  String get misReservacionesDetalle;

  /// No description provided for @avisos.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get avisos;

  /// No description provided for @avisosVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes avisos. Aquí verás lo que pase con tus reservaciones.'**
  String get avisosVacio;

  /// No description provided for @avisoReservaCreada.
  ///
  /// In es, this message translates to:
  /// **'Creaste la reservación {folio}.'**
  String avisoReservaCreada(Object folio);

  /// No description provided for @avisoPagoRecibido.
  ///
  /// In es, this message translates to:
  /// **'Recibimos el anticipo de {folio}.'**
  String avisoPagoRecibido(Object folio);

  /// No description provided for @avisoCancelacion.
  ///
  /// In es, this message translates to:
  /// **'Se canceló la reservación {folio}.'**
  String avisoCancelacion(Object folio);

  /// No description provided for @avisoCambio.
  ///
  /// In es, this message translates to:
  /// **'Cambiaste la fecha de {folio}.'**
  String avisoCambio(Object folio);

  /// No description provided for @avisoRecordatorio.
  ///
  /// In es, this message translates to:
  /// **'Tu recorrido {folio} sale en menos de 24 h.'**
  String avisoRecordatorio(Object folio);

  /// No description provided for @perfilTitulo.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get perfilTitulo;

  /// No description provided for @editarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editarPerfil;

  /// No description provided for @perfilActualizado.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get perfilActualizado;

  /// No description provided for @datosPersonales.
  ///
  /// In es, this message translates to:
  /// **'Datos personales'**
  String get datosPersonales;

  /// No description provided for @nombreYTelefono.
  ///
  /// In es, this message translates to:
  /// **'Nombre y teléfono'**
  String get nombreYTelefono;

  /// No description provided for @correoElectronico.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get correoElectronico;

  /// No description provided for @preferencias.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferencias;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificaciones;

  /// No description provided for @notificacionesDetalle.
  ///
  /// In es, this message translates to:
  /// **'Avisos sobre tu reservación'**
  String get notificacionesDetalle;

  /// No description provided for @recordatorios.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios'**
  String get recordatorios;

  /// No description provided for @recordatoriosDetalle.
  ///
  /// In es, this message translates to:
  /// **'24 h antes del recorrido'**
  String get recordatoriosDetalle;

  /// No description provided for @privacidadYAyuda.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y ayuda'**
  String get privacidadYAyuda;

  /// No description provided for @avisoPrivacidad.
  ///
  /// In es, this message translates to:
  /// **'Aviso de privacidad'**
  String get avisoPrivacidad;

  /// No description provided for @avisoPrivacidadDetalle.
  ///
  /// In es, this message translates to:
  /// **'Cómo usamos y protegemos tus datos'**
  String get avisoPrivacidadDetalle;

  /// No description provided for @versionApp.
  ///
  /// In es, this message translates to:
  /// **'Trajineras v1.0 · Segundo parcial'**
  String get versionApp;

  /// No description provided for @campoNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get campoNombre;

  /// No description provided for @campoTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get campoTelefono;

  /// No description provided for @rutasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Rutas disponibles'**
  String get rutasTitulo;

  /// No description provided for @rutasIntro.
  ///
  /// In es, this message translates to:
  /// **'Compara las dos rutas temáticas y elige la que más te guste.'**
  String get rutasIntro;

  /// No description provided for @rutasVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay rutas disponibles. Vuelve más tarde.'**
  String get rutasVacio;

  /// No description provided for @comparacion.
  ///
  /// In es, this message translates to:
  /// **'Comparación'**
  String get comparacion;

  /// No description provided for @duracionDeRecorrido.
  ///
  /// In es, this message translates to:
  /// **'{duracion} de recorrido'**
  String duracionDeRecorrido(Object duracion);

  /// No description provided for @filaAmbiente.
  ///
  /// In es, this message translates to:
  /// **'Ambiente'**
  String get filaAmbiente;

  /// No description provided for @filaDuracion.
  ///
  /// In es, this message translates to:
  /// **'Duración'**
  String get filaDuracion;

  /// No description provided for @filaPrecio.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get filaPrecio;

  /// No description provided for @filaSalida.
  ///
  /// In es, this message translates to:
  /// **'Salida'**
  String get filaSalida;

  /// No description provided for @filaHorarios.
  ///
  /// In es, this message translates to:
  /// **'Horarios'**
  String get filaHorarios;

  /// No description provided for @filaParadas.
  ///
  /// In es, this message translates to:
  /// **'Paradas'**
  String get filaParadas;

  /// No description provided for @filaIncluye.
  ///
  /// In es, this message translates to:
  /// **'Incluye'**
  String get filaIncluye;

  /// No description provided for @incluyeRecomendaciones.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones de seguridad'**
  String get incluyeRecomendaciones;

  /// No description provided for @incluyeServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios adicionales con precio'**
  String get incluyeServicios;

  /// No description provided for @elegirEstaRuta.
  ///
  /// In es, this message translates to:
  /// **'Elegir esta ruta'**
  String get elegirEstaRuta;

  /// No description provided for @desde.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get desde;

  /// No description provided for @porPersona.
  ///
  /// In es, this message translates to:
  /// **'por persona'**
  String get porPersona;

  /// No description provided for @hastaN.
  ///
  /// In es, this message translates to:
  /// **'Hasta {n}'**
  String hastaN(Object n);

  /// No description provided for @paradas.
  ///
  /// In es, this message translates to:
  /// **'Paradas'**
  String get paradas;

  /// No description provided for @horarios.
  ///
  /// In es, this message translates to:
  /// **'Horarios'**
  String get horarios;

  /// No description provided for @serviciosAdicionales.
  ///
  /// In es, this message translates to:
  /// **'Servicios adicionales'**
  String get serviciosAdicionales;

  /// No description provided for @recomendacionesSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones de seguridad'**
  String get recomendacionesSeguridad;

  /// No description provided for @verFotoDe.
  ///
  /// In es, this message translates to:
  /// **'Ver foto: {nombre}'**
  String verFotoDe(Object nombre);

  /// No description provided for @seguridadTitulo.
  ///
  /// In es, this message translates to:
  /// **'Seguridad y FAQ'**
  String get seguridadTitulo;

  /// No description provided for @reglasNavegacion.
  ///
  /// In es, this message translates to:
  /// **'Reglas de navegación'**
  String get reglasNavegacion;

  /// No description provided for @preguntasFrecuentes.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes'**
  String get preguntasFrecuentes;

  /// No description provided for @preguntasVacio.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay preguntas frecuentes.'**
  String get preguntasVacio;

  /// No description provided for @necesitasAyuda.
  ///
  /// In es, this message translates to:
  /// **'¿Necesitas ayuda?'**
  String get necesitasAyuda;

  /// No description provided for @llamar.
  ///
  /// In es, this message translates to:
  /// **'Llamar'**
  String get llamar;

  /// No description provided for @correo.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get correo;

  /// No description provided for @tradicionesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tradiciones y leyendas'**
  String get tradicionesTitulo;

  /// No description provided for @seccionHistoria.
  ///
  /// In es, this message translates to:
  /// **'Historia'**
  String get seccionHistoria;

  /// No description provided for @seccionLeyendas.
  ///
  /// In es, this message translates to:
  /// **'Leyendas'**
  String get seccionLeyendas;

  /// No description provided for @seccionGaleria.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get seccionGaleria;

  /// No description provided for @historiaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historia del Día de Muertos'**
  String get historiaTitulo;

  /// No description provided for @leyendasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Leyendas de Xochimilco'**
  String get leyendasTitulo;

  /// No description provided for @galeriaFotoAnimas.
  ///
  /// In es, this message translates to:
  /// **'Ofrenda flotante al anochecer'**
  String get galeriaFotoAnimas;

  /// No description provided for @galeriaFotoCempasuchil.
  ///
  /// In es, this message translates to:
  /// **'Flores de cempasúchil'**
  String get galeriaFotoCempasuchil;

  /// No description provided for @galeriaFotoTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Trajinera en el canal'**
  String get galeriaFotoTrajinera;

  /// No description provided for @galeriaFotoEmbarcadero.
  ///
  /// In es, this message translates to:
  /// **'Embarcadero de Xochimilco'**
  String get galeriaFotoEmbarcadero;

  /// No description provided for @fotoNDeTotal.
  ///
  /// In es, this message translates to:
  /// **'Foto {n} de {total}'**
  String fotoNDeTotal(Object n, Object total);

  /// No description provided for @cerrar.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get cerrar;

  /// No description provided for @comoLlegarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get comoLlegarTitulo;

  /// No description provided for @embarcaderosVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay embarcaderos disponibles por ahora.'**
  String get embarcaderosVacio;

  /// No description provided for @indicaciones.
  ///
  /// In es, this message translates to:
  /// **'Indicaciones'**
  String get indicaciones;

  /// No description provided for @abrirGoogleMaps.
  ///
  /// In es, this message translates to:
  /// **'Abrir en Google Maps'**
  String get abrirGoogleMaps;

  /// No description provided for @llamarEmbarcadero.
  ///
  /// In es, this message translates to:
  /// **'Llamar al embarcadero'**
  String get llamarEmbarcadero;

  /// No description provided for @mapaEmbarcadero.
  ///
  /// In es, this message translates to:
  /// **'Embarcadero'**
  String get mapaEmbarcadero;

  /// No description provided for @puntoEncuentro.
  ///
  /// In es, this message translates to:
  /// **'Punto de encuentro'**
  String get puntoEncuentro;

  /// No description provided for @embarcaderoYMuelle.
  ///
  /// In es, this message translates to:
  /// **'Embarcadero {embarcadero} · {muelle}'**
  String embarcaderoYMuelle(Object embarcadero, Object muelle);

  /// No description provided for @presentateA.
  ///
  /// In es, this message translates to:
  /// **'Preséntate a las {hora} ({minutos} min antes)'**
  String presentateA(Object hora, Object minutos);

  /// No description provided for @pasoNDeTotal.
  ///
  /// In es, this message translates to:
  /// **'Paso {paso} de {total}'**
  String pasoNDeTotal(Object paso, Object total);

  /// No description provided for @pasoSemantica.
  ///
  /// In es, this message translates to:
  /// **'Paso {paso} de {total}: {nombre}'**
  String pasoSemantica(Object paso, Object total, Object nombre);

  /// No description provided for @pasoTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Elige trajinera'**
  String get pasoTrajinera;

  /// No description provided for @pasoFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha y horario'**
  String get pasoFecha;

  /// No description provided for @pasoDatos.
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto'**
  String get pasoDatos;

  /// No description provided for @pasoResumen.
  ///
  /// In es, this message translates to:
  /// **'Resumen y pago'**
  String get pasoResumen;

  /// No description provided for @pasoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'Confirmación'**
  String get pasoConfirmacion;

  /// No description provided for @flujoIncompleto.
  ///
  /// In es, this message translates to:
  /// **'Esta reservación ya no está en curso.'**
  String get flujoIncompleto;

  /// No description provided for @irAInicio.
  ///
  /// In es, this message translates to:
  /// **'Ir a Inicio'**
  String get irAInicio;

  /// No description provided for @queRuta.
  ///
  /// In es, this message translates to:
  /// **'¿Qué ruta?'**
  String get queRuta;

  /// No description provided for @eligeRutaEmpezar.
  ///
  /// In es, this message translates to:
  /// **'Elige la ruta para empezar tu reservación.'**
  String get eligeRutaEmpezar;

  /// No description provided for @eligeTuTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Elige tu trajinera'**
  String get eligeTuTrajinera;

  /// No description provided for @filtroTodas.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get filtroTodas;

  /// No description provided for @filtroAccesibles.
  ///
  /// In es, this message translates to:
  /// **'Accesibles'**
  String get filtroAccesibles;

  /// No description provided for @filtroGrandes.
  ///
  /// In es, this message translates to:
  /// **'15+ personas'**
  String get filtroGrandes;

  /// No description provided for @pasajerosEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'Pasajeros'**
  String get pasajerosEtiqueta;

  /// No description provided for @seleccionada.
  ///
  /// In es, this message translates to:
  /// **'Seleccionada'**
  String get seleccionada;

  /// No description provided for @deshabilitamosMenorCapacidad.
  ///
  /// In es, this message translates to:
  /// **'Deshabilitamos las de menor capacidad'**
  String get deshabilitamosMenorCapacidad;

  /// No description provided for @quitarPasajero.
  ///
  /// In es, this message translates to:
  /// **'Quitar un pasajero'**
  String get quitarPasajero;

  /// No description provided for @agregarPasajero.
  ///
  /// In es, this message translates to:
  /// **'Agregar un pasajero'**
  String get agregarPasajero;

  /// No description provided for @ningunaTrajineraLugar.
  ///
  /// In es, this message translates to:
  /// **'Ninguna trajinera tiene lugar para {pasajeros}.'**
  String ningunaTrajineraLugar(Object pasajeros);

  /// No description provided for @ningunaTrajineraFiltroLugar.
  ///
  /// In es, this message translates to:
  /// **'Ninguna trajinera de \"{filtro}\" tiene lugar para {pasajeros}. Baja el número de pasajeros o quita el filtro.'**
  String ningunaTrajineraFiltroLugar(Object filtro, Object pasajeros);

  /// No description provided for @motivoMantenimiento.
  ///
  /// In es, this message translates to:
  /// **'En mantenimiento: sin servicio esta temporada'**
  String get motivoMantenimiento;

  /// No description provided for @motivoCapacidad.
  ///
  /// In es, this message translates to:
  /// **'Capacidad insuficiente para {pasajeros}'**
  String motivoCapacidad(Object pasajeros);

  /// No description provided for @hastaPersonas.
  ///
  /// In es, this message translates to:
  /// **'Hasta {n} personas'**
  String hastaPersonas(Object n);

  /// No description provided for @tarifaPorRecorrido.
  ///
  /// In es, this message translates to:
  /// **'{tarifa} / recorrido'**
  String tarifaPorRecorrido(Object tarifa);

  /// No description provided for @trajineraIncluye.
  ///
  /// In es, this message translates to:
  /// **'Incluye {lista}'**
  String trajineraIncluye(Object lista);

  /// No description provided for @trajineraExtras.
  ///
  /// In es, this message translates to:
  /// **'Extras: {lista}'**
  String trajineraExtras(Object lista);

  /// No description provided for @accesible.
  ///
  /// In es, this message translates to:
  /// **'Accesible'**
  String get accesible;

  /// No description provided for @cambiarReservacion.
  ///
  /// In es, this message translates to:
  /// **'Cambiar reservación'**
  String get cambiarReservacion;

  /// No description provided for @fechaYHora.
  ///
  /// In es, this message translates to:
  /// **'Fecha y hora'**
  String get fechaYHora;

  /// No description provided for @sinElegir.
  ///
  /// In es, this message translates to:
  /// **'Sin elegir'**
  String get sinElegir;

  /// No description provided for @cambioAviso.
  ///
  /// In es, this message translates to:
  /// **'Elige la nueva fecha y horario del folio {folio}. Se conservan {trajinera}, {pasajeros}, tus servicios y tu pago.'**
  String cambioAviso(Object folio, Object trajinera, Object pasajeros);

  /// No description provided for @alguienReservoHorario.
  ///
  /// In es, this message translates to:
  /// **'Alguien acaba de reservar ese horario. Elige otro.'**
  String get alguienReservoHorario;

  /// No description provided for @noSePudoCambiar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cambiar la reservación.'**
  String get noSePudoCambiar;

  /// No description provided for @cambiamosTuTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Cambiamos tu trajinera a {nombre}'**
  String cambiamosTuTrajinera(Object nombre);

  /// No description provided for @horariosDisponibles.
  ///
  /// In es, this message translates to:
  /// **'Horarios disponibles'**
  String get horariosDisponibles;

  /// No description provided for @horariosDisponiblesFecha.
  ///
  /// In es, this message translates to:
  /// **'Horarios disponibles · {fecha}'**
  String horariosDisponiblesFecha(Object fecha);

  /// No description provided for @eligeFechaVerHorarios.
  ///
  /// In es, this message translates to:
  /// **'Elige una fecha para ver los horarios.'**
  String get eligeFechaVerHorarios;

  /// No description provided for @sinSalidasHoy.
  ///
  /// In es, this message translates to:
  /// **'Ya no quedan salidas este día: se reserva con al menos {horas} h de anticipación.'**
  String sinSalidasHoy(Object horas);

  /// No description provided for @yaReservadoEn.
  ///
  /// In es, this message translates to:
  /// **'{horario} ya está reservado en {trajinera}'**
  String yaReservadoEn(Object horario, Object trajinera);

  /// No description provided for @sinHorariosEn.
  ///
  /// In es, this message translates to:
  /// **'No quedan horarios este día en {trajinera}'**
  String sinHorariosEn(Object trajinera);

  /// No description provided for @mesAnterior.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior'**
  String get mesAnterior;

  /// No description provided for @mesSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Mes siguiente'**
  String get mesSiguiente;

  /// No description provided for @leyendaHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get leyendaHoy;

  /// No description provided for @leyendaSinServicio.
  ///
  /// In es, this message translates to:
  /// **'Sin servicio (mantenimiento)'**
  String get leyendaSinServicio;

  /// No description provided for @horarioOcupado.
  ///
  /// In es, this message translates to:
  /// **'{horario} · Ocupado'**
  String horarioOcupado(Object horario);

  /// No description provided for @verAlternativas.
  ///
  /// In es, this message translates to:
  /// **'Ver alternativas'**
  String get verAlternativas;

  /// No description provided for @sinAlternativas.
  ///
  /// In es, this message translates to:
  /// **'No encontramos alternativas con lugar esta temporada.'**
  String get sinAlternativas;

  /// No description provided for @sugerimosAlternativas.
  ///
  /// In es, this message translates to:
  /// **'Te sugerimos estas alternativas con lugar disponible:'**
  String get sugerimosAlternativas;

  /// No description provided for @tusDatos.
  ///
  /// In es, this message translates to:
  /// **'Tus datos'**
  String get tusDatos;

  /// No description provided for @datosIntro.
  ///
  /// In es, this message translates to:
  /// **'Usaremos estos datos para tu comprobante y para avisarte de cambios.'**
  String get datosIntro;

  /// No description provided for @nombreResponsable.
  ///
  /// In es, this message translates to:
  /// **'Nombre del responsable'**
  String get nombreResponsable;

  /// No description provided for @ayudaNombre.
  ///
  /// In es, this message translates to:
  /// **'Como aparece en tu identificación'**
  String get ayudaNombre;

  /// No description provided for @ayudaTelefono.
  ///
  /// In es, this message translates to:
  /// **'10 dígitos'**
  String get ayudaTelefono;

  /// No description provided for @ayudaCorreo.
  ///
  /// In es, this message translates to:
  /// **'Aparecerá en tu comprobante'**
  String get ayudaCorreo;

  /// No description provided for @numeroPasajeros.
  ///
  /// In es, this message translates to:
  /// **'Número de pasajeros'**
  String get numeroPasajeros;

  /// No description provided for @corrigeCampos.
  ///
  /// In es, this message translates to:
  /// **'Corrige los campos marcados para continuar.'**
  String get corrigeCampos;

  /// No description provided for @completaDatos.
  ///
  /// In es, this message translates to:
  /// **'Completa tus datos para continuar.'**
  String get completaDatos;

  /// No description provided for @aceptaAvisoContinuar.
  ///
  /// In es, this message translates to:
  /// **'Acepta el aviso de privacidad para continuar.'**
  String get aceptaAvisoContinuar;

  /// No description provided for @continuarAlResumen.
  ///
  /// In es, this message translates to:
  /// **'Continuar al resumen'**
  String get continuarAlResumen;

  /// No description provided for @aceptoAviso.
  ///
  /// In es, this message translates to:
  /// **'Acepto el aviso de privacidad y el uso de mis datos para esta reservación.'**
  String get aceptoAviso;

  /// No description provided for @leerAviso.
  ///
  /// In es, this message translates to:
  /// **'Leer aviso de privacidad'**
  String get leerAviso;

  /// No description provided for @errNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu nombre'**
  String get errNombreVacio;

  /// No description provided for @errNombreLetras.
  ///
  /// In es, this message translates to:
  /// **'Usa solo letras y espacios'**
  String get errNombreLetras;

  /// No description provided for @errNombreCorto.
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 3 letras'**
  String get errNombreCorto;

  /// No description provided for @errTelefonoVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu teléfono'**
  String get errTelefonoVacio;

  /// No description provided for @errTelefonoLargo.
  ///
  /// In es, this message translates to:
  /// **'El teléfono debe tener 10 dígitos'**
  String get errTelefonoLargo;

  /// No description provided for @errCorreoVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo'**
  String get errCorreoVacio;

  /// No description provided for @errCorreoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido'**
  String get errCorreoInvalido;

  /// No description provided for @errPasajerosVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe cuántos pasajeros son'**
  String get errPasajerosVacio;

  /// No description provided for @errPasajerosMinimo.
  ///
  /// In es, this message translates to:
  /// **'Debe haber al menos 1 pasajero'**
  String get errPasajerosMinimo;

  /// No description provided for @errPasajerosMaximo.
  ///
  /// In es, this message translates to:
  /// **'Máximo {max} personas'**
  String errPasajerosMaximo(Object max);

  /// No description provided for @maximoPersonasEn.
  ///
  /// In es, this message translates to:
  /// **'Máximo {max} personas en {trajinera}'**
  String maximoPersonasEn(Object max, Object trajinera);

  /// No description provided for @tuReservacion.
  ///
  /// In es, this message translates to:
  /// **'Tu reservación'**
  String get tuReservacion;

  /// No description provided for @filaRuta.
  ///
  /// In es, this message translates to:
  /// **'Ruta'**
  String get filaRuta;

  /// No description provided for @filaTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Trajinera'**
  String get filaTrajinera;

  /// No description provided for @filaFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get filaFecha;

  /// No description provided for @filaHorario.
  ///
  /// In es, this message translates to:
  /// **'Horario'**
  String get filaHorario;

  /// No description provided for @filaPasajeros.
  ///
  /// In es, this message translates to:
  /// **'Pasajeros'**
  String get filaPasajeros;

  /// No description provided for @filaResponsable.
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get filaResponsable;

  /// No description provided for @filaServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get filaServicios;

  /// No description provided for @filaPago.
  ///
  /// In es, this message translates to:
  /// **'Pago'**
  String get filaPago;

  /// No description provided for @desglose.
  ///
  /// In es, this message translates to:
  /// **'Desglose'**
  String get desglose;

  /// No description provided for @politicaCancelacion.
  ///
  /// In es, this message translates to:
  /// **'Cancelación sin costo hasta 24 h antes: se reembolsa el anticipo. Después de ese plazo el anticipo no es reembolsable.'**
  String get politicaCancelacion;

  /// No description provided for @metodoPagoSimulado.
  ///
  /// In es, this message translates to:
  /// **'Método de pago (simulado)'**
  String get metodoPagoSimulado;

  /// No description provided for @pagoDemostracion.
  ///
  /// In es, this message translates to:
  /// **'Pago de demostración: no se realiza ningún cargo real ni se piden datos de tarjeta.'**
  String get pagoDemostracion;

  /// No description provided for @anticipo.
  ///
  /// In es, this message translates to:
  /// **'Anticipo'**
  String get anticipo;

  /// No description provided for @confirmar.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirmar;

  /// No description provided for @sinServiciosTrajinera.
  ///
  /// In es, this message translates to:
  /// **'Esta trajinera no ofrece servicios adicionales.'**
  String get sinServiciosTrajinera;

  /// No description provided for @pagoTarjeta.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta de débito o crédito'**
  String get pagoTarjeta;

  /// No description provided for @pagoSpei.
  ///
  /// In es, this message translates to:
  /// **'Transferencia / SPEI'**
  String get pagoSpei;

  /// No description provided for @pagoTarjetaSimulado.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta (simulado)'**
  String get pagoTarjetaSimulado;

  /// No description provided for @pagoSpeiSimulado.
  ///
  /// In es, this message translates to:
  /// **'SPEI (simulado)'**
  String get pagoSpeiSimulado;

  /// No description provided for @reservaOcupado.
  ///
  /// In es, this message translates to:
  /// **'Alguien acaba de reservar las {horario} del {fecha} en {trajinera}. Elige otro horario.'**
  String reservaOcupado(Object horario, Object fecha, Object trajinera);

  /// No description provided for @reservaFechaInvalida.
  ///
  /// In es, this message translates to:
  /// **'Las {horario} del {fecha} ya no se pueden reservar. Elige otro horario.'**
  String reservaFechaInvalida(Object horario, Object fecha);

  /// No description provided for @reservaSinCapacidad.
  ///
  /// In es, this message translates to:
  /// **'La trajinera no tiene lugar para tantos pasajeros.'**
  String get reservaSinCapacidad;

  /// No description provided for @reservaSinServicio.
  ///
  /// In es, this message translates to:
  /// **'La trajinera ya no tiene servicio. Elige otra.'**
  String get reservaSinServicio;

  /// No description provided for @reservaNoConfirmada.
  ///
  /// In es, this message translates to:
  /// **'No se pudo confirmar. Intenta de nuevo.'**
  String get reservaNoConfirmada;

  /// No description provided for @tarifaTrajineraNombre.
  ///
  /// In es, this message translates to:
  /// **'Tarifa trajinera {nombre}'**
  String tarifaTrajineraNombre(Object nombre);

  /// No description provided for @rutaPrecioPorPersonas.
  ///
  /// In es, this message translates to:
  /// **'Ruta {precio} × {n, plural, =1{1 persona} other{{n} personas}}'**
  String rutaPrecioPorPersonas(Object precio, int n);

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @anticipoHoy.
  ///
  /// In es, this message translates to:
  /// **'Anticipo a pagar hoy (30 %)'**
  String get anticipoHoy;

  /// No description provided for @anticipoPorPagar.
  ///
  /// In es, this message translates to:
  /// **'Anticipo por pagar (30 %)'**
  String get anticipoPorPagar;

  /// No description provided for @anticipoPagado30.
  ///
  /// In es, this message translates to:
  /// **'Anticipo pagado (30 %)'**
  String get anticipoPagado30;

  /// No description provided for @anticipo30.
  ///
  /// In es, this message translates to:
  /// **'Anticipo (30 %)'**
  String get anticipo30;

  /// No description provided for @restanEnEmbarcadero.
  ///
  /// In es, this message translates to:
  /// **'Restan {monto} en el embarcadero'**
  String restanEnEmbarcadero(Object monto);

  /// No description provided for @folioMayusculas.
  ///
  /// In es, this message translates to:
  /// **'FOLIO'**
  String get folioMayusculas;

  /// No description provided for @qrDelFolio.
  ///
  /// In es, this message translates to:
  /// **'Código QR del folio {folio}'**
  String qrDelFolio(Object folio);

  /// No description provided for @confirmacionTitulo.
  ///
  /// In es, this message translates to:
  /// **'Confirmación'**
  String get confirmacionTitulo;

  /// No description provided for @volverAInicio.
  ///
  /// In es, this message translates to:
  /// **'Volver a Inicio'**
  String get volverAInicio;

  /// No description provided for @reservacionConfirmada.
  ///
  /// In es, this message translates to:
  /// **'¡Reservación confirmada!'**
  String get reservacionConfirmada;

  /// No description provided for @comprobanteListo.
  ///
  /// In es, this message translates to:
  /// **'Tu comprobante está listo. Muestra tu folio en el embarcadero.'**
  String get comprobanteListo;

  /// No description provided for @simularPagoAnticipo.
  ///
  /// In es, this message translates to:
  /// **'Simular pago del anticipo'**
  String get simularPagoAnticipo;

  /// No description provided for @comprobante.
  ///
  /// In es, this message translates to:
  /// **'Comprobante'**
  String get comprobante;

  /// No description provided for @irAMisReservaciones.
  ///
  /// In es, this message translates to:
  /// **'Ir a mis reservaciones'**
  String get irAMisReservaciones;

  /// No description provided for @procesandoPago.
  ///
  /// In es, this message translates to:
  /// **'Procesando pago…'**
  String get procesandoPago;

  /// No description provided for @anticipoPagadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Anticipo pagado'**
  String get anticipoPagadoMsg;

  /// No description provided for @noSePudoPagar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo registrar el pago'**
  String get noSePudoPagar;

  /// No description provided for @reservacionNoSePuedeCambiar.
  ///
  /// In es, this message translates to:
  /// **'Esta reservación ya no se puede cambiar.'**
  String get reservacionNoSePuedeCambiar;

  /// No description provided for @filtroProximas.
  ///
  /// In es, this message translates to:
  /// **'Próximas'**
  String get filtroProximas;

  /// No description provided for @filtroPasadas.
  ///
  /// In es, this message translates to:
  /// **'Pasadas'**
  String get filtroPasadas;

  /// No description provided for @filtroCanceladas.
  ///
  /// In es, this message translates to:
  /// **'Canceladas'**
  String get filtroCanceladas;

  /// No description provided for @vacioProximas.
  ///
  /// In es, this message translates to:
  /// **'No tienes reservaciones próximas'**
  String get vacioProximas;

  /// No description provided for @vacioPasadas.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes recorridos pasados'**
  String get vacioPasadas;

  /// No description provided for @vacioCanceladas.
  ///
  /// In es, this message translates to:
  /// **'No tienes reservaciones canceladas'**
  String get vacioCanceladas;

  /// No description provided for @eligeRutaYReserva.
  ///
  /// In es, this message translates to:
  /// **'Elige una ruta y reserva tu trajinera.'**
  String get eligeRutaYReserva;

  /// No description provided for @avisoCancelar24h.
  ///
  /// In es, this message translates to:
  /// **'Puedes cancelar sin costo o solicitar un cambio hasta 24 h antes del recorrido.'**
  String get avisoCancelar24h;

  /// No description provided for @canceladaReembolso.
  ///
  /// In es, this message translates to:
  /// **'Reservación cancelada. Reembolsaremos {monto} MXN.'**
  String canceladaReembolso(Object monto);

  /// No description provided for @canceladaMsg.
  ///
  /// In es, this message translates to:
  /// **'Reservación cancelada'**
  String get canceladaMsg;

  /// No description provided for @noSePudoCancelar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cancelar la reservación'**
  String get noSePudoCancelar;

  /// No description provided for @cambiamosTuReservacion.
  ///
  /// In es, this message translates to:
  /// **'Cambiamos tu reservación al {fecha} · {horario}'**
  String cambiamosTuReservacion(Object fecha, Object horario);

  /// No description provided for @montosPagada.
  ///
  /// In es, this message translates to:
  /// **'Total {total} · Anticipo pagado'**
  String montosPagada(Object total);

  /// No description provided for @montosPendiente.
  ///
  /// In es, this message translates to:
  /// **'Total {total} · Anticipo {anticipo}'**
  String montosPendiente(Object total, Object anticipo);

  /// No description provided for @montosReembolsado.
  ///
  /// In es, this message translates to:
  /// **'Anticipo reembolsado ({monto})'**
  String montosReembolsado(Object monto);

  /// No description provided for @montosSinReembolso.
  ///
  /// In es, this message translates to:
  /// **'Anticipo sin reembolso ({monto})'**
  String montosSinReembolso(Object monto);

  /// No description provided for @montosCanceladaSinCargo.
  ///
  /// In es, this message translates to:
  /// **'Cancelada sin cargo'**
  String get montosCanceladaSinCargo;

  /// No description provided for @pagar.
  ///
  /// In es, this message translates to:
  /// **'Pagar'**
  String get pagar;

  /// No description provided for @detalle.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get detalle;

  /// No description provided for @cambiar.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get cambiar;

  /// No description provided for @dialogoCancelarTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Cancelar reservación?'**
  String get dialogoCancelarTitulo;

  /// No description provided for @siCancelar.
  ///
  /// In es, this message translates to:
  /// **'Sí, cancelar'**
  String get siCancelar;

  /// No description provided for @cancelarSinCargo.
  ///
  /// In es, this message translates to:
  /// **'Tu recorrido del {dia} (folio {folio}) aún no tiene pago del anticipo, así que se cancelará sin cargo.'**
  String cancelarSinCargo(Object dia, Object folio);

  /// No description provided for @cancelarConReembolso.
  ///
  /// In es, this message translates to:
  /// **'Tu recorrido del {dia} (folio {folio}) es en más de 24 h, así que se reembolsará tu anticipo de {anticipo} en 3 a 5 días hábiles.'**
  String cancelarConReembolso(Object dia, Object folio, Object anticipo);

  /// No description provided for @cancelarSinReembolso.
  ///
  /// In es, this message translates to:
  /// **'Tu recorrido del {dia} (folio {folio}) es en 24 h o menos, así que no se reembolsará tu anticipo de {anticipo}.'**
  String cancelarSinReembolso(Object dia, Object folio, Object anticipo);

  /// No description provided for @detalleReservacionTitulo.
  ///
  /// In es, this message translates to:
  /// **'Detalle de reservación'**
  String get detalleReservacionTitulo;

  /// No description provided for @reservacionNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'No encontramos esta reservación.'**
  String get reservacionNoEncontrada;

  /// No description provided for @detalleCanceladaReembolso.
  ///
  /// In es, this message translates to:
  /// **'Reservación cancelada. Se reembolsan {monto} en 3 a 5 días hábiles.'**
  String detalleCanceladaReembolso(Object monto);

  /// No description provided for @detalleCancelada.
  ///
  /// In es, this message translates to:
  /// **'Reservación cancelada.'**
  String get detalleCancelada;

  /// No description provided for @estadoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get estadoDisponible;

  /// No description provided for @estadoPocosLugares.
  ///
  /// In es, this message translates to:
  /// **'Pocos lugares'**
  String get estadoPocosLugares;

  /// No description provided for @estadoSinServicio.
  ///
  /// In es, this message translates to:
  /// **'Sin servicio'**
  String get estadoSinServicio;

  /// No description provided for @estadoPendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente de verificación'**
  String get estadoPendiente;

  /// No description provided for @estadoPagada.
  ///
  /// In es, this message translates to:
  /// **'Pagada'**
  String get estadoPagada;

  /// No description provided for @estadoCancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get estadoCancelada;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
