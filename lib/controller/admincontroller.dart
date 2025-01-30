import '../config/library/import.dart';

class Admincontroller extends GetxController {
  final UServidor uservidor = Get.find();
  final Uadmin uadmin = Get.find();
  final UUsuario uusuario = Get.find();

  Future<void> getAdmin() async {
    uservidor.cargaprogreso.value = true;
    uadmin.datosetiqueta.value = await Adminmodel().datosgenerales(parametros: {"idusuario" : uusuario.usuariologin["id_users"].toString()});
    if(!uadmin.pantallaCargadaAdmin.value) uadmin.pantallaCargadaAdmin.value = true;
    uservidor.cargaprogreso.value = false;
  }

  void limpiarAdmin(){
    uadmin.pantallaCargadaAdmin.value = false;
    uadmin.datosetiqueta.value = {};
  }
}