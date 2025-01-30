import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Recolectormodel extends GetConnect {
  final uservidor = Get.find<UServidor>();

  Future<List<Map<String, dynamic>>> mostrarRecolector({required Map<String, dynamic> parametros}) async {
    try {
      await Future.microtask((){ 
        uservidor.cargaprogreso.value = true;
      });
      
      uservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}unidad_recolectoras_api"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: {
            // "Accion": "2",
            // if(parametros.containsKey("idcliente")) "IdCliente": parametros["idcliente"].toString(),
            // if(parametros.containsKey("idusuario")) "IdUsuario": parametros["idusuario"].toString(),
            // if(parametros.containsKey("idempresa")) "IdEmpresa": parametros["idempresa"].toString(),
            // if(parametros.containsKey("pagina")) "Pagina": parametros["pagina"].toString(),
            // if(parametros.containsKey("fila")) "Fila": parametros["fila"].toString(),
            // if(parametros.containsKey("estado")) "Estado": parametros["estado"].toString()
          },
          encoding: Encoding.getByName("utf-8"),
        );
      }).timeout(const Duration(seconds: 120));

      uservidor.validar.value = await uservidor.validarRespuestaServidor(response: uservidor.respuestaservidor);
      if (uservidor.validar.value) {
        uservidor.jsondecode.value = jsonDecode(uservidor.respuestaservidor.body);
        if (!uservidor.jsondecode.value.containsKey('listar_vehiculos')) {
          uservidor.mensajesubTituloServidor.value = "El servidor devolvió una respuesta vacía.";
        }
      }
    } catch (ex) {
      uservidor.servidorExpecion(ex);
    } finally {
      uservidor.cargaprogreso.value = false;
    }
    return List<Map<String, dynamic>>.from(uservidor.jsondecode.value['listar_vehiculos'] ?? []) ;
    // return [];
  }
}