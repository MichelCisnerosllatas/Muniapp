import '../config/library/import.dart';

class Chofercontroller extends GetxController{
  final Urutas urutas = Get.find();
  final Uchofer uchofer = Get.find();
  final UServidor uservidor = Get.find();
  final UUsuario uusuario = Get.find();
  final tubicacion = Get.find<Tubicacion>();

  void initStateChofer(){
    listarrutas();
  }

  Future<void> listarHistorialRutasChofers() async {
    try{
      await Future.delayed(Duration.zero);
      uservidor.cargaprogreso.value = true;
      uchofer.listaHistorialRutasChofer.value = await Rutamodel().mostrarHistorialRutasChofer();
      uchofer.pantallaCargadaHistorialRutasChofer.value = true;
      uservidor.cargaprogreso.value = false;
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: ex.toString());
    }
  }

  Future<void> iniciarRuta({required int idruta}) async {
    try{
      dynamic mapruta = await Rutamodel().guardaInicioRuta(datosJson: {
        "idruta" : idruta.toString(),
        "iduser" : uusuario.usuariologin["id_users"]
      });

      if(mapruta["success"]){
        urutas.idinicioruta.value = mapruta["id_inicio_ruta"];
      }    

      mapruta = await Rutamodel().guardarRutaCamionApi(datosJson: {
        "idinicioruta" : urutas.idinicioruta.value.toString(),
        "coordenadax" : tubicacion.longitude.value.toString(),
        "coordenaday" : tubicacion.latidude.value.toString(),
      });

      if(!mapruta["success"]){
        Global().mensajeShowToast(mensaje: mapruta["message"]);
      }
    }catch(ex){
      uservidor.servidorExpecion(ex);
    }
  }

  Future<void> listarrutas() async{
    try{
      uservidor.cargaprogreso.value = true;
      urutas.listarutas.value = await Rutamodel().mostrarRutasChofer();
      urutas.listarutasDropdowsbutton.value = urutas.listarutas.isEmpty ? [] : urutas.listarutas.map((e) {
        return {
          "id_ruta": e["id_ruta"].toString(),
          "ruta_nombre": e["ruta_nombre"].toString()
        };
      }).toList();
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "Chofercontroller, listarrutas");
    }
    uservidor.cargaprogreso.value = false;
  }

  void limpiarChofer(){    
    urutas.idinicioruta.value = 0;
  }
}