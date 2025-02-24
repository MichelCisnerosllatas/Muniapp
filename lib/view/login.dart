import '../config/library/import.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginhState();
}

class _LoginhState extends State<Login> {
  final UUsuario tusuario = Get.find();

  @override
  void initState() {
    super.initState();
    Usuariocontroller().initStateLogin();
    
  }  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Cierra el teclado al tocar fuera
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 23, 47, 226), // Azul
                Color(0xFF6dd5ed), // Celeste
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: tusuario.formKeyLogin,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Circular
                    ClipOval(
                      child: Image.asset('assets/img/logo.png',  width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 20),
                    // Título
                    Style.textTitulo(
                      mensaje: "MUNI",
                      colorTexto: Colors.white,
                      fontSize: 24,
                    ),
                    const SizedBox(height: 20),
                    // Campo Usuario
                    Style.texFormField(
                      labelText: "Usuario",
                      controller: tusuario.txtlogin,
                      rxboolText: tusuario.boolpintartextlogin,
                      focusNode: tusuario.focotxtlogin,
                      validator: (p0) => p0.isEmpty ? 'Ingrese el Usuario' : null,
                    ),
                    const SizedBox(height: 20),
                    // Campo Contraseña
                    Style.texFormField(
                      labelText: "Contraseña:",
                      controller: tusuario.txtclave,
                      rxboolText: tusuario.boolpintartextclave,
                      focusNode: tusuario.focotxtclave,
                      obscureText: tusuario.verclaveLogin,
                      validator: (p0) => p0.isEmpty ? 'Ingrese una contraseña' : null,
                      suffixIcon: Rx<Widget>(IconButton(
                        icon: Obx(() => Icon(tusuario.verclaveLogin.value ? Icons.visibility : Icons.visibility_off)),
                        onPressed: () => tusuario.verclaveLogin.value = !tusuario.verclaveLogin.value
                      ))
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Style.textSubTitulo(mensaje: "Notienes Cuenta?"),
                        TextButton(
                          onPressed: () => Get.toNamed('/registrociudadanopage'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: Style.textTitulo(mensaje: "Registrate"),
                        )
                      ],
                    ),
                    
                    // Botón de Ingreso
                    ElevatedButton(
                      onPressed: () async{
                        FocusScope.of(context).unfocus();
                        if(tusuario.formKeyLogin.currentState!.validate()){
                          await Usuariocontroller().validarLogin(username: tusuario.txtlogin.text.trim(), password: tusuario.txtclave.text.trim());
                        } 
                        
                      },
                      child: Obx((){
                        if(tusuario.cargarLogin.value){
                          return SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Style.textTitulo(mensaje: "Cargando"),
                                SizedBox(width: 10),
                                LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 20)
                              ],
                            ),
                          );
                        }else{
                          return Style.textTitulo(mensaje: "Iniciar Sesion");
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
