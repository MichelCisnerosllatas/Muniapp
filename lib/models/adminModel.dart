import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Adminmodel extends GetConnect{
  final UServidor uservidor = Get.find<UServidor>();

  Future<Map<String, dynamic>> datosgenerales({required Map<String, dynamic> parametros}) async {
    try {
      // Enviar solicitud al servidor
      uservidor.respuestaservidor = await http.post(
        Uri.parse("${Webservice().api()}datos_generales_admin_api"),
        body: {
          if (parametros.containsKey("idusuario")) "id_users": parametros["idusuario"].toString(),
        },
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName("utf-8"),
      );

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if(!uservidor.validar.value){
        throw "Error al conectar con el servidor";
      }

      uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body) as Map<String, dynamic>;
    } catch (ex) {
      uservidor.servidorExpecion(ex);
    }
    return uservidor.jsondecode.value ?? {};
  }
}