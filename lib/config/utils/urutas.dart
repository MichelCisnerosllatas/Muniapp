import '../library/import.dart';

class Urutas extends GetxController{
  RxInt idinicioruta = 0.obs; 

  RxList<Map<String, dynamic>> listarutas = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> listarutasDropdowsbutton = RxList<Map<String, dynamic>>([]);
  RxString idRutaSeleccionadaValue = ''.obs;
}