import 'dart:io';
import 'package:path/path.dart';
import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Usuariomodel extends GetConnect {
  final UServidor uservidor = Get.find<UServidor>();
  final Notificacioncontroller notificacioncontroller = Get.find<Notificacioncontroller>();

  Future<Map<String, dynamic>> login({required Map<String, dynamic> parametros}) async {
    try {
      // Enviar solicitud al servidor
      uservidor.respuestaservidor = await http.post(
        Uri.parse("${Webservice().api()}login_api"),
        body: {
          if (parametros.containsKey("username")) "username": parametros["username"].toString(),
          if (parametros.containsKey("password")) "password": parametros["password"].toString(),
          "fcm_token": notificacioncontroller.deviceToken.value,
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

  Future<Map<String, dynamic>> editarUsuario({required Map<String, dynamic> datosJson}) async {
    try {
      var uri = Uri.parse("${Webservice().api()}actualizar_usuario_api");
      var request = http.MultipartRequest("POST", uri);

      // Agregar los datos como campos normales
      request.fields.addAll({
        if (datosJson.containsKey("idusuario")) "id_users": datosJson["idusuario"].toString(),
        if (datosJson.containsKey("nombre")) "name": datosJson["nombre"].toString(),
        if (datosJson.containsKey("apellido")) "last_name": datosJson["apellido"].toString(),
        if (datosJson.containsKey("apellido2")) "maternal_surname": datosJson["apellido2"].toString(),
        if (datosJson.containsKey("correo")) "email": datosJson["correo"].toString(),
        if (datosJson.containsKey("celular")) "users_phone": datosJson["celular"].toString(),
        // if (datosJson.containsKey("usuario")) "username": datosJson["usuario"].toString(),
        // if (datosJson.containsKey("clave")) "password": datosJson["clave"].toString(),
        if (datosJson.containsKey("sexo")) "user_sexo": (datosJson["sexo"].toString() == "Masculino" ? "M" : "F"),
      });

      // 🔹 Agregar la imagen solo si existe
      if (datosJson.containsKey("foto") && datosJson["foto"] != null) {
        File imagen = datosJson["foto"];
        request.files.add(await http.MultipartFile.fromPath(
          "profile_picture", // Nombre del campo esperado por el servidor
          imagen.path,
          filename: basename(imagen.path),
        ));
      }

      // 🔹 Enviar la solicitud
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      // 🔹 Manejar la respuesta del servidor
      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: responseData);
      if (!uservidor.validar.value) {
        throw Exception("Error en la petición: ${response.reasonPhrase}");
      }

      uservidor.jsondecode.value = jsonDecode(responseData.body);
      return uservidor.jsondecode.value;
    } catch (ex) {
      uservidor.servidorExpecion(ex, modal: true);
      print("❌ Error al enviar datos: $ex");
      return {};
    }
  }
}