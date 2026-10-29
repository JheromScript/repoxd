import 'package:flutter_test/flutter_test.dart';
import 'package:trajineras/core/reloj.dart';
import 'package:trajineras/data/datos_mock.dart';
import 'package:trajineras/state/preferencias_controller.dart';

void main() {
  late PreferenciasController prefs;

  setUp(() {
    prefs = PreferenciasController(
      reloj: RelojFijo(DateTime(2026, 10, 27, 10)),
      perfil: DatosMock.perfilDemo,
    );
  });

  test('idioma, notificaciones y recordatorios', () {
    expect(prefs.idioma, 'es');
    prefs.cambiarIdioma('en');
    expect(prefs.idioma, 'en');
    expect(() => prefs.cambiarIdioma('fr'), throwsArgumentError);
    prefs
      ..cambiarNotificaciones(false)
      ..cambiarRecordatorios(false);
    expect((prefs.notificaciones, prefs.recordatorios), (false, false));
  });

  test('editar perfil con los validadores del formulario', () {
    final errores = prefs.actualizarPerfil(
      nombre: 'Al',
      telefono: '55 1234',
      correo: 'lucia@',
    );
    expect(errores.keys, ['nombre', 'telefono', 'correo']);
    expect(prefs.perfil.nombre, 'Lucía Hernández');

    expect(
      prefs.actualizarPerfil(
        nombre: ' Lucía Hernández Ruiz ',
        telefono: '5587654321',
        correo: 'lucia@correo.mx',
      ),
      isEmpty,
    );
    expect(prefs.perfil.nombre, 'Lucía Hernández Ruiz');
    expect(prefs.perfil.telefono, '5587654321');
  });

  test('avisos: respetan los switches y los recordatorios no se repiten', () {
    prefs
      ..avisar(TipoAviso.reservaCreada, 'DM-26-AAAA')
      ..avisar(TipoAviso.recordatorio, 'DM-26-AAAA')
      ..avisar(TipoAviso.recordatorio, 'DM-26-AAAA');
    expect(prefs.avisos.map((a) => a.tipo), [
      TipoAviso.recordatorio,
      TipoAviso.reservaCreada,
    ]);
    expect(prefs.noLeidos, 2);
    prefs.marcarLeidos();
    expect(prefs.noLeidos, 0);

    prefs
      ..cambiarNotificaciones(false)
      ..avisar(TipoAviso.pagoRecibido, 'DM-26-AAAA')
      ..avisar(TipoAviso.recordatorio, 'DM-26-BBBB');
    expect(prefs.avisos.first.tipo, TipoAviso.recordatorio);
    prefs
      ..cambiarRecordatorios(false)
      ..avisar(TipoAviso.recordatorio, 'DM-26-CCCC');
    expect(prefs.avisos, hasLength(3));
  });
}
