import '../../../config/library/import.dart';

class Registrociudadanopage extends StatefulWidget {
  const Registrociudadanopage({super.key});

  @override
  State<Registrociudadanopage> createState() => _RegistrociudadanopageState();
}

class _RegistrociudadanopageState extends State<Registrociudadanopage> {
  final Uciudadano uciudadano = Get.find<Uciudadano>();

  @override
  void initState() {
    super.initState();
    Ciudadanocontroller().initStateRegistroCiudadano();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: true,
        title: Style.textTitulo(mensaje: "Registro Ciudadano", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: uciudadano.formKeyRegistroCiudadano,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Nombre Completo",
                controller: uciudadano.txtNombre,
                rxboolText: uciudadano.boolpintartxtNombre,
                focusNode: uciudadano.focotxtxtNombre,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),
              const SizedBox(height: 20),
              
              Style.texFormField(
                labelText: "Apellido Completo",
                controller: uciudadano.txtApellido,
                rxboolText: uciudadano.boolpintartxtApellido,
                focusNode: uciudadano.focotxtApellido,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),

              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Email",
                controller: uciudadano.txtcorreo,
                rxboolText: uciudadano.boolpintartxtcorreo,
                focusNode: uciudadano.focotxtcorreo,
                keyboard: TextInputType.emailAddress,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),

              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Celular",
                controller: uciudadano.txtCelular,
                rxboolText: uciudadano.boolpintartxtCelular,
                focusNode: uciudadano.focotxtCelular,
                keyboard: TextInputType.phone,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),

              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Usuario",
                controller: uciudadano.txtusuario,
                rxboolText: uciudadano.boolpintartxtusuario,
                focusNode: uciudadano.focotxtusuario,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),
              
              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Clave",
                controller: uciudadano.txtClave,
                rxboolText: uciudadano.boolpintartxtClave,
                focusNode: uciudadano.focotxtClave,
                keyboard: TextInputType.visiblePassword,
                obscureText: true,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),

              const SizedBox(height: 20),
              Style.btnElevatedButton(
                minimumSize: Size(150, 40),
                icon: Style.estiloIcon(icon: Icons.app_registration_rounded, size: 25, color: Style.colorBlanco),
                label: "Guardar",
                onPressed: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(uciudadano.formKeyRegistroCiudadano.currentState!.validate()){
                    Get.toNamed("registrociudadanopage2");
                    // Ciudadanocontroller().registroCiudadano();
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}