import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../library/import.dart';

class UPersonal extends GetxController {
  Rx<Widget> widgetPersonal = Rx<Widget>(const SizedBox.shrink());
  RxBool pantallaCargadaPersonal = false.obs;
  RxList<Map<String, dynamic>> listaPersonal = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listaPersonalBusqueda = <Map<String, dynamic>>[].obs;

  Rx<RefreshController> refreshControllerPersonal = RefreshController().obs;
  Rx<ScrollController> scrollControllerPersonal = ScrollController().obs;

  RxBool mostrarDetalle = false.obs;
  RxBool mostrarScroolTOPDetalle = false.obs;
  RxDouble offsetScrollDetalle = 0.0.obs;
}