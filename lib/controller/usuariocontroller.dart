import '../config/library/import.dart';

class Usuariocontroller extends GetxController {
  final UUsuario uusuario = Get.find();
  GetStorage getstorage =  GetStorage();


  void initStateLogin(){
    uusuario.focotxtxtNombre = FocusNode();
    uusuario.focotxtApellidoPat = FocusNode();
    uusuario.focotxtApellidoMat = FocusNode();
    uusuario.focotxtCelular = FocusNode();
    uusuario.focotxtcorreo = FocusNode();
    uusuario.focotxtSexo = FocusNode();
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
      uusuario.usuariologin["password"] = password;
      await getstorage.write("loginData", uusuario.usuariologin);
      limpiartodoprimeravez();
      await Get.offAllNamed("/principal");
    }else{
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Usuario o contraseña incorrecta.");
      return;
    }        
  }

  Future<void> editarusurio() async {
    try{ 
      await Future.delayed(Duration.zero, () {});
      final m = await Usuariomodel().editarUsuario(datosJson: {
        "idusuario": uusuario.usuariologin["id_users"].toString(),
        "nombre": uusuario.txtNombre.text,
        "apellido": uusuario.txtApellidoPat.text,
        "apellido2": uusuario.txtApellidoMat.text,
        "correo": uusuario.txtcorreo.text,
        "celular": uusuario.txtCelular.text,
        "sexo": uusuario.txtSexo.value,
        if(uusuario.fotoUsuario.value != null) "foto": uusuario.fotoUsuario.value
      });
      
      final data = await Usuariomodel().login(parametros: {
        "username": uusuario.usuariologin["username"],
        "password": uusuario.usuariologin["password"]
      });

      await getstorage.remove('loginData');
      await getstorage.write("loginData", data["data"]);
      uusuario.usuariologin.value = data["data"];
      
      
      limpiartodoprimeravez();
      Global().mensajeShowToast(mensaje: "Usuario editado con exito.", colorFondo: Colors.greenAccent, colortexto: Style.colorBlanco);
      Get.back();
      // await Get.offAllNamed("/principal");
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al editar el usuario. $ex");
    }
  }
  
  void limpiartodoprimeravez(){
    uusuario.txtclave.clear();
    uusuario.txtclave.clear();

    Admincontroller().limpiarAdmin();
  }
}