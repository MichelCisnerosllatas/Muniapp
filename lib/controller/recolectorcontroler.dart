import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../config/library/import.dart';

class Recolectorcontroler extends GetxController{
  final UServidor tservidor = Get.find<UServidor>();
  final Trecolector trecolector = Get.find<Trecolector>();

  void initStateRecolector(){
    if (trecolector.scrollControllerRecolector.value.hasClients == false) {
      trecolector.scrollControllerRecolector.value = ScrollController();
    }
    if (trecolector.refreshControllerRecolector.value.headerStatus == null) {
      trecolector.refreshControllerRecolector.value = RefreshController();
    }

    trecolector.scrollControllerRecolector.value.addListener(() {
      if (trecolector.scrollControllerRecolector.value.offset > 50) {
        tservidor.botonScrollTop.value = true;
      } else {
        tservidor.botonScrollTop.value = false;
      }
    });
  }

  Future<void> listarRecolector({required Map<String, dynamic> datos}) async{
    // Posponer el cambio de estado a después del build
    await Future.delayed(Duration.zero, () { });

    tservidor.cargaprogreso.value = true;
    trecolector.listaRecolector.value = await Recolectormodel().mostrarRecolector(parametros: datos);
    trecolector.pantallaCargadaRecolector.value = true;
    tservidor.cargaprogreso.value = false;
  }

  Future<void> showbuttonshetOpcionesRecolector({Map<String, dynamic>? datos}) async {
    try{
      showModalBottomSheet(
        context: Get.context!, 
        isScrollControlled: true,
        showDragHandle: true,
        builder:(context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Style.estiloIcon(icon: Icons.car_crash_outlined),
                title: Style.textTitulo(mensaje: "Detalle Recolector"),
              ),
              ListTile(
                leading: Style.estiloIcon(icon: Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Style.textTitulo(mensaje: "Eliminar"),
              ),
              ListTile(
                leading: Style.estiloIcon(icon: Icons.edit),
                title: Style.textTitulo(mensaje: "Editar"),
              ),
            ],
          );
        },
      );
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: ex.toString());
      return;
    }
  }
}