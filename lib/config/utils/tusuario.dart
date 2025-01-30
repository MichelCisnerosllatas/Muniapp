import '../library/import.dart';

class UUsuario extends GetxController {
  final formKeyLogin = GlobalKey<FormState>();
  RxMap<String, dynamic> usuariologin = <String, dynamic>{}.obs;


  TextEditingController txtlogin = TextEditingController();
  TextEditingController txtclave = TextEditingController();

  RxBool boolEnabletxtlogin= true.obs;
  RxBool boolpintartextlogin = false.obs;
  RxBool boolpintartextclave = false.obs;

  late FocusNode focotxtlogin;
  late FocusNode focotxtclave;

  RxBool cargarLogin = false.obs;
}