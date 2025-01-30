import '../config/library/import.dart';
import 'package:http/http.dart' as http;

class Personalmodel extends GetConnect {
  final tservidor = Get.find<UServidor>();

  Future<List<Map<String, dynamic>>> mostrarPersonal({required Map<String, dynamic> parametros}) async {
    try {
      await Future.microtask((){ 
        tservidor.cargaprogreso.value = true;
      });
      
      tservidor.respuestaservidor = await Future.delayed(const Duration(seconds: 0, milliseconds: 0), () {
        return http.post(
          Uri.parse("${Webservice().api()}listar_personales_api"),
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

      tservidor.validar.value = await tservidor.validarRespuestaServidor(response: tservidor.respuestaservidor);
      if (tservidor.validar.value) {
        tservidor.jsondecode.value = jsonDecode(tservidor.respuestaservidor.body);
        if (!tservidor.jsondecode.value.containsKey('listar_personales')) {
          tservidor.mensajesubTituloServidor.value = "El servidor devolvió una respuesta vacía.";
        }
      }
    } catch (ex) {
      tservidor.servidorExpecion(ex);
    } finally {
      tservidor.cargaprogreso.value = false;      
    }

    return List<Map<String, dynamic>>.from(tservidor.jsondecode.value['listar_personales'] ?? []) ;
  }
}