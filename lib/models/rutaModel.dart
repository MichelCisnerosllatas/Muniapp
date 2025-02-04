import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Rutamodel extends GetConnect{
  final uservidor = Get.find<UServidor>();
  final uusuario = Get.find<UUsuario>();
  
  Future<List<Map<String, dynamic>>> mostrarHistorialRutasChofer({Map<String, dynamic>? parametros}) async{
    try {
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}historial_ruta_chofer_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            "id_users" : uusuario.usuariologin["id_users"].toString()
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
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['rutas'] ?? []);
  }

  Future<List<Map<String, dynamic>>> mostrarRutasChofer({Map<String, dynamic>? parametros}) async{
    try {
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}listar_rutas_vehiculos_personales_detalle_ruta"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            "id_users" : uusuario.usuariologin["id_users"].toString()
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
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['rutas'] ?? []);
  }

  Future<List<Map<String, dynamic>>> mostrarRutasRegistroCiudadano({Map<String, dynamic>? parametros}) async{
    try {
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}listar_rutas_login_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
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
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['rutas'] ?? []);
  }

  Future<List<Map<String, dynamic>>> mostrarRutasCiudadnoInicio({Map<String, dynamic>? parametros}) async{
    try {
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}listar_rutas_por_ciudadano_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            "id_users" : uusuario.usuariologin["id_users"].toString()
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
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['rutas'] ?? []);
  }

  Future<Map<String, dynamic>> guardaInicioRuta({required Map<String, dynamic> datosJson}) async {
    try{
      await Future.microtask((){}); 
      var body = {};
      
      if(datosJson.containsKey("idinicioruta")){
        body = {
          if(datosJson.containsKey("idinicioruta")) "id_inicio_ruta" : datosJson["idinicioruta"].toString(),
          if(datosJson.containsKey("iduser")) "id_users" : datosJson["iduser"].toString(),
          if(datosJson.containsKey("idruta")) "id_ruta" : datosJson["idruta"].toString(),
          if(datosJson.containsKey("observacion")) "inicio_ruta_observacion" : datosJson["observacion"].toString(),
          "inicio_ruta_fecha_fin" : DateTime.now().toString()
        };
      }else{
        body = {
          if(datosJson.containsKey("iduser")) "id_users" : datosJson["iduser"].toString(),
          if(datosJson.containsKey("idruta")) "id_ruta" : datosJson["idruta"].toString(),
          "inicio_ruta_fecha_inicio" : DateTime.now().toString()
        };
      }  


      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}guardar_inicio_ruta_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: body,
          encoding: Encoding.getByName("utf-8"),
        );
      }).timeout(const Duration(seconds: 120));

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if(!uservidor.validar.value){
        throw Exception("Error en la peticion");
      }

      uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body);
      if (!uservidor.jsondecode.value.containsKey('id_inicio_ruta')) {
        uservidor.mensajesubTituloServidor.value = "El servidor no devolvió la respuesta 'id_inicio_ruta'";
      }      
    }catch(ex){
      uservidor.servidorExpecion(ex);
    }

    return uservidor.jsondecode.value ?? {};
  }

  Future<Map<String, dynamic>> guardarRutaCamionApi({required Map<String, dynamic> datosJson}) async {
    try{
      await Future.microtask((){});      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}guardar_ruta_camion_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            if(datosJson.containsKey("idinicioruta")) "id_inicio_ruta" : datosJson["idinicioruta"].toString(),
            if(datosJson.containsKey("coordenaday")) "ruta_camion_coordenada_x" : datosJson["coordenaday"].toString(),
            if(datosJson.containsKey("coordenadax")) "ruta_camion_coordenada_y" : datosJson["coordenadax"].toString()
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

  Future<Map<String, dynamic>> directionsMapBoxAPI({required double startLng, required double startLat, required double endLng, required double endLat,
    String profile = "driving", String geometries = "geojson"}) async {
    try {
      // Construcción de la URL con parámetros dinámicos
      final String baseUrl = "https://api.mapbox.com/directions/v5/mapbox";
      final String accessToken = "pk.eyJ1IjoibWljaGVsYW5nZWwiLCJhIjoiY201bGpiY2I5MGpveTJrcTFveW5uOTYzeSJ9.EYCxwW0fpalaKMA1ehHhbA";

      final Uri uri = Uri.parse(
        "$baseUrl/$profile/$startLng,$startLat;$endLng,$endLat"
        "?geometries=$geometries&access_token=$accessToken",
      );

      // Realizar la petición GET
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener la ruta: ${response.statusCode}");
      }
    } catch (ex) {
      throw Exception("Error en la solicitud de navegación: $ex");
    }
  }
}