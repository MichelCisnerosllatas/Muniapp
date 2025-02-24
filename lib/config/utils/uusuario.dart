import 'dart:io';
import '../library/import.dart';

class UUsuario extends GetxController {
  final formKeyLogin = GlobalKey<FormState>();
  Rx<File?> fotoUsuario = Rx<File?>(null);
  RxString fotoUrl = RxString('');
  RxMap<String, dynamic> usuariologin = <String, dynamic>{}.obs;

  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtApellidoPat = TextEditingController();
  TextEditingController txtApellidoMat = TextEditingController();
  TextEditingController txtcorreo = TextEditingController();
  TextEditingController txtCelular = TextEditingController();
  RxString txtSexo = RxString('');
  TextEditingController txtlogin = TextEditingController();
  TextEditingController txtclave = TextEditingController();

  RxBool boolEnabletxtlogin= true.obs;
  RxBool boolpintartextlogin = false.obs;
  RxBool boolpintartextclave = false.obs;
  RxBool boolEnabletxtNombre = true.obs;
  RxBool boolpintartxtApellidoPat = false.obs;
  RxBool boolpintartxtApellidoMat = false.obs;
  RxBool boolpintartxtNombre = false.obs;
  RxBool boolpintartxtcorreo = false.obs;
  RxBool boolpintartxtCelular = false.obs;
  RxBool boolpintartxtSexo = false.obs;

  RxBool cargarLogin = false.obs;
  RxBool verclaveLogin = false.obs;  

  late FocusNode focotxtxtNombre;
  late FocusNode focotxtApellidoPat;
  late FocusNode focotxtApellidoMat;
  late FocusNode focotxtcorreo;
  late FocusNode focotxtCelular;
  late FocusNode focotxtSexo;
  late FocusNode focotxtlogin;
  late FocusNode focotxtclave;

  // RxBool verClave2 = false.obs;
}