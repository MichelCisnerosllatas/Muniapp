import '../config/library/import.dart';

class Usuariocontroller extends GetxController {
  final UUsuario uusuario = Get.find();
  GetStorage getstorage =  GetStorage();


  void initStateLogin(){
    uusuario.focotxtclave = FocusNode();
    uusuario.focotxtlogin = FocusNode();
  }

  Future<void> validarLogin({required String username, required String password}) async {
    await Future.delayed(Duration.zero, () {});
    uusuario.cargarLogin.value = true;
    uusuario.usuariologin.value = await Usuariomodel().login(parametros: {
      "username": username,
      "password": password
    });   
    
    uusuario.cargarLogin.value = false;  
    if(uusuario.usuariologin.isNotEmpty && uusuario.usuariologin.containsKey("data")){
      uusuario.usuariologin.value = uusuario.usuariologin["data"];
      await getstorage.write("loginData", uusuario.usuariologin);
      limpiartodoprimeravez();
      await Get.offAllNamed("/principal");
    }else{
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Usuario o contraseña incorrecta.");
    }            
  }

  void limpiartodoprimeravez(){
    uusuario.txtclave.clear();
    uusuario.txtclave.clear();

    Admincontroller().limpiarAdmin();
  }
}