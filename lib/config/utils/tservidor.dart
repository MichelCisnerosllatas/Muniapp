import 'dart:io';
import 'package:http/http.dart' as http;
import '../library/import.dart';

class UServidor extends GetxController {
  RxString mensajeTituloServidor = "".obs;
  RxString mensajesubTituloServidor = "".obs;
  RxString mensajesubTituloServidor2 = "".obs;
  RxInt tipoError = 0.obs; //1 = Error General, 2 = Error Servidor, 3 = error de Red
  RxBool cargaprogreso = false.obs;
  RxBool botonScrollTop = false.obs; //esto es para las Listas
  RxBool validar = false.obs;

  
  dynamic respuestaservidor;
  Rx<dynamic> jsondecode = Rx<dynamic>(null);
  RxList<Map<String, dynamic>> datalist = <Map<String, dynamic>>[].obs;


  RxBool seleccionado = false.obs;
  RxBool selecTodo = false.obs;
  RxList<int> idSeleccionados = <int>[].obs;

  void limpiarSeleccion() async{
    await Future.microtask((){
      idSeleccionados.clear();
      seleccionado.value = false;
      selecTodo.value = false;
    });    
  }

  Future<void> limpiarServidor() async {
    await Future.microtask(() {        
      mensajeTituloServidor.value = "";
      mensajesubTituloServidor.value = "";
      tipoError.value = 0;
      //botonScrollTop = false.obs;      
      datalist.value = <Map<String, dynamic>>[].obs;
      jsondecode.value = null;
    });    
  }

  Future<bool> validarRespuestaServidor({required dynamic response}) async {
    bool validar = false; 
    await limpiarServidor();

    if (response.statusCode == 401) {
      mensajeTituloServidor.value = "Error: No autorizado ${response.statusCode}";
      mensajesubTituloServidor.value = "La solicitud no tiene las credenciales correctas.";
    } else if (response.statusCode == 500) {
      mensajeTituloServidor.value = "Error interno del servidor ${response.statusCode}";
      mensajesubTituloServidor.value = "El servidor encontró una condición inesperada.";
    } else if (response.body.trim().isEmpty) {
      mensajeTituloServidor.value = "Error: Respuesta vacía";
      mensajesubTituloServidor.value = "El servidor devolvió una respuesta vacía.";
    } else if(response.body.contains("<br />") || response.body.contains("<br/>") || !Global().validarJson(response.body)) {
      mensajeTituloServidor.value = "Error al Obtener Datos";
      mensajesubTituloServidor.value = "Mensaje: ${response.body.toString()}";
      //mensajesubTituloServidor.value = response.body.toString();
    } else { 
      jsondecode.value = jsonDecode(response.body);
      if (jsondecode.value == null) {
        mensajeTituloServidor.value = "Error: Cuerpo del Servidor";
        mensajesubTituloServidor.value = "El cuerpo de la respuesta es nulo. ${response.body}";
      } else{
        validar = true;
      }
      
      // else if (!jsondecode.value.containsKey('result')) {
      //   mensajeTituloServidor.value = "Error: Campo faltante";
      //   mensajesubTituloServidor.value = "El campo 'result' no está presente en la respuesta. ${response.body}";
      // } else if (!jsondecode.value['result'].containsKey('success')) {
      //   mensajeTituloServidor.value = "Error: Campo faltante";
      //   mensajesubTituloServidor.value = "El campo 'success' no está presente en la respuesta. ${response.body}";
      // } else if (jsondecode.value['result']['success'] is! bool) {
      //   mensajeTituloServidor.value = "Error: Formato incorrecto";
      //   mensajesubTituloServidor.value = "El campo 'success' no tiene el tipo booleano esperado. Valor actual: ${jsondecode.value['result']['success']}";
      // } else if (!jsondecode.value['result'].containsKey('message')) {
      //   mensajeTituloServidor.value = "Error: Campo faltante";
      //   mensajesubTituloServidor.value = "El campo 'message' no está presente en la respuesta. ${response.body}";
      // } else if (jsondecode.value['result']['message'] is! String) {
      //   mensajeTituloServidor.value = "Error: Formato incorrecto";
      //   mensajesubTituloServidor.value = "El campo 'message' no tiene el tipo esperado, es necesario que sea tipo Cadena. Valor actual: ${jsondecode.value['result']['message']}";
      // } else {
      //   validar = true;
      // }
    }
    return validar;
  }

  void servidorExpecion(dynamic ex, {bool? modal, String? localizar}) {
    modal ??= false; localizar ??= "";

    if (ex is SocketException || ex is HttpException) {
      mensajeTituloServidor.value = "Conexión Fallida";
      mensajesubTituloServidor.value = "Por favor, Verifica el Internet. \nNo se pudo establecer una conexión con el servidor.";
      tipoError.value = 3;
    } else if (ex is FormatException) {
      tipoError.value = 2;
      mensajeTituloServidor.value = "Error: Formato no Válido";
      mensajesubTituloServidor.value = "'FormatException': La respuesta del servidor no tiene el formato esperado. Por favor, verifica tu conexión a Internet o la configuración del servidor.";
    } else if (ex is TimeoutException) {
      tipoError.value = 3;
      mensajeTituloServidor.value = "Conexión Fallida\nTiempo de espera agotado";
      mensajesubTituloServidor.value = "La solicitud tardó demasiado en responder. Por favor, verifica tu conexión a Internet.";
    } else if (ex is HandshakeException) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error en el handshake SSL/TLS";
      mensajesubTituloServidor.value = "Hubo un problema durante la negociación de la conexión segura (SSL/TLS) con el servidor.";
    } else if (ex is TlsException) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error en la capa de seguridad SSL/TLS";
      mensajesubTituloServidor.value = "Se produjo un error en la capa de seguridad SSL/TLS, lo que impidió una conexión segura con el servidor.";
    } else if (ex is http.ClientException) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error general en el cliente";
      mensajesubTituloServidor.value = "Hubo un problema con la configuración del cliente HTTP o la solicitud realizada.";
    } else if (ex is PlatformException) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error específico de la plataforma";
      mensajesubTituloServidor.value = "Ocurrió un error específico de la plataforma. Revisa la implementación de la plataforma para más detalles.";
    } else if (ex is StateError) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error relacionado con el estado interno del cliente HTTP";
      mensajesubTituloServidor.value = "El cliente HTTP encontró un estado inesperado que impidió completar la solicitud.";
    } else if (ex is UnsupportedError) {
      tipoError.value = 1;
      mensajeTituloServidor.value = "Error por el cliente HTTP";
      mensajesubTituloServidor.value = "El cliente HTTP intentó realizar una operación que no es compatible.";
    } else {
      
      //mensajeTituloServidor.value == "" ? "" : ex.toString();
      //mensajesubTituloServidor.value == "" ? "" : mensajesubTituloServidor.value.toString();
    }

    if (modal) {
      Global().mensajeGetSnackBar(
        titulo: mensajeTituloServidor.value.toString(),
        mensaje: "${localizar == "" ? "" : "Localizado en: $localizar, "}${mensajesubTituloServidor.value.toString()}",
        colorFondo: Style.colorRojo,
        colorTexto: Style.colorBlanco
      );
      //Informacion().mensajeGetSnackBar(mensajeTituloServidor.value.toString(), "${localizar == "" ? "" : "Localizado en: $localizar, "}${mensajesubTituloServidor.value.toString()}", Predeterminado.ColorRojo, Predeterminado.ColorBlanco, null);
    }
  }
}