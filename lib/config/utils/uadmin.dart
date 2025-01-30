import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../library/import.dart';

class Uadmin extends GetxController {
  Rx<Widget> widgetAdmin = Rx<Widget>(const SizedBox.shrink());
  RxBool pantallaCargadaAdmin= false.obs;
  RxMap<String, dynamic> datosetiqueta = RxMap<String, dynamic>();

  Rx<RefreshController> refreshControllerAdmin = RefreshController().obs;
  Rx<ScrollController> scrollControllerAdmin = ScrollController().obs;
}