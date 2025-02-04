import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../library/import.dart';

class Uchofer extends GetxController{
  Rx<Widget> widgetHistorialRutasChofer = Rx<Widget>(const SizedBox.shrink());
  RxBool pantallaCargadaHistorialRutasChofer = false.obs;
  RxList<Map<String, dynamic>> listaHistorialRutasChofer = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listaHistorialRutasChoferBusqueda = <Map<String, dynamic>>[].obs;

  Rx<RefreshController> refreshControllerHistorialRutasChofer = RefreshController().obs;
  Rx<ScrollController> scrollControllerHistorialRutasChofer = ScrollController().obs;    

  RxBool saberAppCerrado = false.obs; //Variable para rastrear si realmente salió
  RxInt saberNaveMapEligida = 1.obs; //si es 1 eligio google Maps y 2 MuniappMaps
}