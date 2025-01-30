import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../config/library/import.dart';

class Personalcontroller extends GetxController{
  final UServidor tservidor = Get.find<UServidor>();
  final UPersonal tpersonal = Get.find<UPersonal>();

  void initStatePersonal(){
    if (tpersonal.scrollControllerPersonal.value.hasClients == false) {
      tpersonal.scrollControllerPersonal.value = ScrollController();
    }
    if (tpersonal.refreshControllerPersonal.value.headerStatus == null) {
      tpersonal.refreshControllerPersonal.value = RefreshController();
    }

    tpersonal.scrollControllerPersonal.value.addListener(() {
      if (tpersonal.scrollControllerPersonal.value.offset > 50) {
        tservidor.botonScrollTop.value = true;
      } else {
        tservidor.botonScrollTop.value = false;
      }
    });
  }

  Future<void> listarPersonal({required Map<String, dynamic> datos}) async{
    // Posponer el cambio de estado a después del build
    await Future.delayed(Duration.zero, () { });

    tservidor.cargaprogreso.value = true;
    tpersonal.listaPersonal.value = await Personalmodel().mostrarPersonal(parametros: datos);
    tpersonal.pantallaCargadaPersonal.value = true;
    tservidor.cargaprogreso.value = false;
  }
}