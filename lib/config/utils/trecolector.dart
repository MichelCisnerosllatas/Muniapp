import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../library/import.dart';

class Trecolector extends GetxController{
  Rx<Widget> widgetRecolector = Rx<Widget>(const SizedBox.shrink());
  RxBool pantallaCargadaRecolector = false.obs;
  RxList<Map<String, dynamic>> listaRecolector = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listaRecolectorBusqueda = <Map<String, dynamic>>[].obs;

  Rx<RefreshController> refreshControllerRecolector = RefreshController().obs;
  Rx<ScrollController> scrollControllerRecolector = ScrollController().obs;

  RxBool mostrarDetalle = false.obs;
  RxBool mostrarScroolTOPDetalle = false.obs;
  RxDouble offsetScrollDetalle = 0.0.obs;
}