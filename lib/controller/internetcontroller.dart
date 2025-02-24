import '../config/library/import.dart';

class Internetcontroller extends GetxController {
  var estaConectdo = false.obs;
  StreamSubscription<List<ConnectivityResult>>? subscription;

  @override
  void onInit() {
    super.onInit();
    listenToConnectivityChanges();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }

  void listenToConnectivityChanges() {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
      if (resultList.contains(ConnectivityResult.mobile) || resultList.contains(ConnectivityResult.wifi) || resultList.contains(ConnectivityResult.ethernet) || resultList.contains(ConnectivityResult.vpn) || resultList.contains(ConnectivityResult.bluetooth) || resultList.contains(ConnectivityResult.other) || resultList.contains(ConnectivityResult.none)) {
        if (!estaConectdo.value) {
          // Si antes no había conexión y ahora sí, volvemos a la pantalla anterior
          estaConectdo.value = true;
          if (Get.currentRoute == '/FalloInternet') {
            Get.back(); // Regresa a la pantalla anterior cuando hay conexión
          }
        }
      } else {
        if (estaConectdo.value) {
          // Si se pierde la conexión, navega a la pantalla de "sin conexión"
          estaConectdo.value = false;
          Get.toNamed('/FalloInternet'); // Navegar a la pantalla de sin conexión
        }
      }
    });
  }
}
