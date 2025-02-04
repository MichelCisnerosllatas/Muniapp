import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Ciudadanomodel extends GetxController {
  final UServidor uservidor = Get.find<UServidor>();

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

  Future<Map<String, dynamic>> registrarCiudadano({required Map<String, dynamic> datosJson}) async{
    try{
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}guardar_ciudadano_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            if(datosJson.containsKey("nombre")) "name" : datosJson["nombre"].toString(),
            if(datosJson.containsKey("apellido")) "last_name" : datosJson["apellido"].toString(),    
            if(datosJson.containsKey("apellido2")) "maternal_surname" : datosJson["apellido2"].toString(),         
            if(datosJson.containsKey("correo")) "email" : datosJson["correo"].toString(),
            if(datosJson.containsKey("celular")) "users_phone" : datosJson["celular"].toString(),
            if(datosJson.containsKey("usuario")) "username" : datosJson["usuario"].toString(),
            if(datosJson.containsKey("clave")) "password" : datosJson["clave"].toString(),
            if(datosJson.containsKey("sexo")) "user_sexo" : (datosJson["sexo"].toString() == "Masculino" ? "M" : "F"),
            if(datosJson.containsKey("foto")) "profile_picture" : datosJson["foto"].toString(),
            if(datosJson.containsKey("tokendispositivo")) "fcm_token" : datosJson["tokendispositivo"].toString()
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
        uservidor.mensajesubTituloServidor.value = "El servidor no devolvió la respuesta 'id_inicio_ruta'";
      }      
    }catch(ex){
      uservidor.servidorExpecion(ex);
    }

    return uservidor.jsondecode.value ?? {};
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