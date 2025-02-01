import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Notifacionmodel extends GetConnect {
  final UServidor uservidor = Get.find<UServidor>();

  Future<void> enviaarNotificacionChofer({int? idruta, String? tiponotificacion}) async {
    try {
      uservidor.respuestaservidor = await http.post(
        Uri.parse("${Webservice().api()}enviarNotificacionPush"),
        headers: {'Content-Type': 'application/json'},
        body : jsonEncode({
          "id_ruta": idruta.toString(),
          "tipo_notificacion" : tiponotificacion.toString() //inicio ó finalizacion
        }),
        // body: {
        //   "id_ruta": idruta.toString(),
        //   "tipoNotificacion" : tiponotificacion.toString() //inicio ó finalizacion
        // }
        // body: jsonEncode({"userId": "12345", "token": token}),
      );
    } catch (e) {
      print("⚠️ Error al conectar con el backend: $e");
    }
  }

  Future<void> sendTokenToServer(String token) async {
    final url = Uri.parse('https://tuservidor.com/guardar-token'); // Reemplaza con tu URL
    final headers = {
      'Content-Type': 'application/json', // Configura el encabezado
    };
    final body = jsonEncode({
      'token': token, // Codifica el cuerpo como JSON
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Token guardado en el servidor.');
      } else {
        print('Error al guardar el token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
}
}