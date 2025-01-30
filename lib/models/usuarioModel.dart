import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Usuariomodel extends GetConnect {
  final UServidor uservidor = Get.find<UServidor>();

  Future<Map<String, dynamic>> login({required Map<String, dynamic> parametros}) async {
    try {
      // Enviar solicitud al servidor
      uservidor.respuestaservidor = await http.post(
        Uri.parse("${Webservice().api()}login_api"),
        body: {
          if (parametros.containsKey("username")) "username": parametros["username"].toString(),
          if (parametros.containsKey("password")) "password": parametros["password"].toString(),
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