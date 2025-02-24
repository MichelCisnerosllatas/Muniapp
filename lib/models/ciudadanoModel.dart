import '../config/library/import.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class Ciudadanomodel extends GetxController {
  final UServidor uservidor = Get.find<UServidor>();

  Future<List<double>?> listarCoordenadTiempoRealCamion({required Map<String, dynamic> parametros}) async {
    try {
      await Future.delayed(Duration.zero, () {}); 

      uservidor.respuestaservidor = await http.post(
        Uri.parse("${Webservice().api()}obtener_ultimas_coordenadas"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          if (parametros.containsKey("idinicioruta")) "id_inicio_ruta": parametros["idinicioruta"].toString(),
        },
        encoding: Encoding.getByName("utf-8"),
      ).timeout(const Duration(seconds: 120));

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if (uservidor.validar.value) {
        uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body);

        // 🔹 Extraer coordenadas correctamente
        var data = uservidor.jsondecode.value["coordenadas"];
        if (data != null) {
          double lat = double.parse(data["ruta_camion_coordenada_x"]);
          double lng = double.parse(data["ruta_camion_coordenada_y"]);
          return [lng, lat]; // Mapbox usa [longitud, latitud]
        }
      }
    } catch (ex) {
      uservidor.servidorExpecion(ex);
      print("❌ Error obteniendo la ubicación del vehículo: $ex");
    }
    return null; // ⛔ En caso de error, retorna null
  }

  Future<List<Map<String, dynamic>>> listarRutasInicioCiudadano({required Map<String, dynamic> parametros}) async {
    try {
      // await Future.microtask((){ 
      //   uservidor.cargaprogreso.value = true;
      // });
      await Future.delayed(Duration.zero, () {});
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}listar_rutas_por_ciudadano_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            if(parametros.containsKey("idusuario")) "id_users": parametros["idusuario"].toString(),
          },
          encoding: Encoding.getByName("utf-8"),
        );
      }).timeout(const Duration(seconds: 120));

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if (uservidor.validar.value) {
        uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body);
        if (!uservidor.jsondecode.value.containsKey('rutas')) {
          uservidor.mensajesubTituloServidor.value = "El servidor devolvió una respuesta vacía.";
        }
      }
    } catch (ex) {
      uservidor.servidorExpecion(ex);
    } finally {
      uservidor.cargaprogreso.value = false;
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['rutas'] ?? []) ;
    // return [];
  }

  Future<Map<String, dynamic>> registrarCiudadano({required Map<String, dynamic> datosJson}) async {
    try {
      var uri = Uri.parse("${Webservice().api()}guardar_ciudadano_api");
      var request = http.MultipartRequest("POST", uri);

      // Agregar los datos como campos normales
      request.fields.addAll({
        if (datosJson.containsKey("nombre")) "name": datosJson["nombre"].toString(),
        if (datosJson.containsKey("apellido")) "last_name": datosJson["apellido"].toString(),
        if (datosJson.containsKey("apellido2")) "maternal_surname": datosJson["apellido2"].toString(),
        if (datosJson.containsKey("correo")) "email": datosJson["correo"].toString(),
        if (datosJson.containsKey("celular")) "users_phone": datosJson["celular"].toString(),
        if (datosJson.containsKey("usuario")) "username": datosJson["usuario"].toString(),
        if (datosJson.containsKey("clave")) "password": datosJson["clave"].toString(),
        if (datosJson.containsKey("sexo")) "user_sexo": (datosJson["sexo"].toString() == "Masculino" ? "M" : "F"),
        if (datosJson.containsKey("tokendispositivo")) "fcm_token": datosJson["tokendispositivo"].toString(),
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

      // if (response.statusCode == 200) {
      //   return jsonDecode(responseData.body);
      // } else {
      //   throw Exception("Error en la petición: ${response.reasonPhrase}");
      // }
    } catch (ex) {
      uservidor.servidorExpecion(ex, modal: true);
      print("❌ Error al enviar datos: $ex");
      return {};
    }
  }

  Future<Map<String, dynamic>> registrarCoordenadasCiudadano({required Map<String, dynamic> datosJson}) async{
    try{
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}guardar_ciudadano_coordenadas_domicilio_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            if(datosJson.containsKey("idusuario")) "id_users" : datosJson["idusuario"].toString(),
            if(datosJson.containsKey("idruta")) "id_ruta" : datosJson["idruta"].toString(),            
            if(datosJson.containsKey("rutax")) "user_ruta_domi_x" : datosJson["rutax"].toString(),
            if(datosJson.containsKey("rutay")) "user_ruta_domi_y" : datosJson["rutay"].toString()
          },
          encoding: Encoding.getByName("utf-8"),
        );
      }).timeout(const Duration(seconds: 120));

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if(!uservidor.validar.value){
        throw Exception("Error en la peticion");
      }

      uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body);
      if (!uservidor.jsondecode.value.containsKey('success')) {
        uservidor.mensajesubTituloServidor.value = "El servidor no devolvió la respuesta 'registrarCoordenadasCiudadano'";
      }      
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "registrarCoordenadasCiudadano");
    }

    return uservidor.jsondecode.value ?? {};
  }
}