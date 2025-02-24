import 'dart:io';
import '../../../config/library/import.dart';

class PerfilUsuariomantpage extends StatefulWidget {
  const PerfilUsuariomantpage({super.key});

  @override
  State<PerfilUsuariomantpage> createState() => _PerfilUsuariomantpageState();
}

class _PerfilUsuariomantpageState extends State<PerfilUsuariomantpage> {
  late UUsuario uusuario;
  late Usuariocontroller usuariocontroller;

  final List<String> items = [
    'Masculino',
    'Femenino'
  ];

  @override
  void initState(){
    super.initState();
    if(!Get.isRegistered<UUsuario>()){
      uusuario = Get.put(UUsuario());
    }else{
      uusuario = Get.find<UUsuario>();
    }

    if(!Get.isRegistered<Usuariocontroller>()){
      usuariocontroller = Get.put(Usuariocontroller());
    }else{
      usuariocontroller = Get.find<Usuariocontroller>();
    }
    usuariocontroller.initStateLogin();
    obtenerInformacionUsuario();
  }
  
  void obtenerInformacionUsuario(){
    try{
      // uusuario.fotoUsuario.value = uusuario.usuariologin['profile_picture'] == null || uusuario.usuariologin['profile_picture'].isEmpty ? null : File(uusuario.usuariologin['profile_picture']);
      uusuario.txtNombre.text = uusuario.usuariologin['name'].toString();
      uusuario.txtApellidoPat.text = uusuario.usuariologin['last_name'].toString();
      uusuario.txtApellidoMat.text = uusuario.usuariologin['maternal_surname'].toString();
      uusuario.txtcorreo.text = uusuario.usuariologin['email'].toString();
      uusuario.txtlogin.text = uusuario.usuariologin['username'].toString();
      uusuario.txtCelular.text = uusuario.usuariologin['users_phone'].toString();
      uusuario.txtSexo.value = uusuario.usuariologin['user_sexo'] == "M" ? "Masculino" : "Femenino";
      if(uusuario.usuariologin["profile_picture"] != null){
        uusuario.fotoUrl.value = uusuario.usuariologin["profile_picture"];
        uusuario.fotoUsuario.value = null;
      }
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "obtenerInformacionUsuario $ex");	
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        title: Style.textTitulo(mensaje: "Editar Perfil", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: uusuario.formKeyLogin,
          child: Column(
            children: [
              Obx(() => TextButton(
                  onPressed: () async {
                    final resultado = await Global().obtenerImagen(tieneFoto: uusuario.fotoUsuario.value != null);
          
                    if (resultado.containsKey("foto") && resultado["foto"] != null) {
                      uusuario.fotoUrl.value = "";
                      uusuario.fotoUsuario.value = File(resultado["foto"].path);
                    } else if (resultado.containsKey("eliminar") && resultado["eliminar"] == true) {
                      uusuario.fotoUsuario.value = null; // ✅ Borra la foto
                    }
                  }, 
                  child: uusuario.fotoUsuario.value == null 
                  ? (uusuario.fotoUrl.value == "" ? Column(
                      children: [
                        Style.estiloIcon(icon: Icons.camera_alt, size: 100),
                        Style.textTitulo(mensaje: "Foto"),
                      ],
                    ) : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(uusuario.fotoUrl.value, width: 150, height: 150, fit: BoxFit.cover)
                    ))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(uusuario.fotoUsuario.value!, width: 150, height: 150, fit: BoxFit.cover)
                    )
                )),   
              
                const SizedBox(height: 20),
                Style.texFormField(
                  labelText: "Nombre Completo",
                  controller: uusuario.txtNombre,
                  rxboolText: uusuario.boolpintartxtNombre,
                  focusNode: uusuario.focotxtxtNombre,
                  validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                ),
                const SizedBox(height: 20),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Style.texFormField(
                        labelText: "Apellido Paterno",
                        controller: uusuario.txtApellidoPat,
                        rxboolText: uusuario.boolpintartxtApellidoPat,
                        focusNode: uusuario.focotxtApellidoPat,
                        validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 10), // Espaciado entre los elementos
          
                    Expanded(
                      child: Style.texFormField(
                        labelText: "Apellido Materno",
                        controller: uusuario.txtApellidoMat,
                        rxboolText: uusuario.boolpintartxtApellidoMat,
                        focusNode: uusuario.focotxtApellidoMat,
                        validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 20),
                Style.texFormField(
                  labelText: "Email",
                  controller: uusuario.txtcorreo,
                  rxboolText: uusuario.boolpintartxtcorreo,
                  focusNode: uusuario.focotxtcorreo,
                  keyboard: TextInputType.emailAddress,
                  validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                ),
          
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Style.texFormField(
                        labelText: "Celular",
                        controller: uusuario.txtCelular,
                        rxboolText: uusuario.boolpintartxtCelular,
                        focusNode: uusuario.focotxtCelular,
                        keyboard: TextInputType.phone,
                        validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                        maxLength: 9,
                        buildCounter: (_, {required int currentLength, required int? maxLength, required bool isFocused}) => null, // 🔥 Pasar null para ocultar el contador
                      ),
                    ),
          
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: Obx(() => DropdownButtonFormField2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Style.textSubTitulo(mensaje: "Sexo"),
                              ),
                            ],
                          ),
                          items: items.map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Style.textSubTitulo(mensaje: item)
                          )).toList(),
                          value: uusuario.txtSexo.value == "" ? null : uusuario.txtSexo.value,
                          onChanged: (String? value) {
                            uusuario.txtSexo.value = value!;
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Theme.of(context).appBarTheme.backgroundColor!,
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            elevation: 2,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Theme.of(context).appBarTheme.backgroundColor!,
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility: MaterialStateProperty.all<bool>(true),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 50, // Ajusta la altura de cada ítem
                            padding: EdgeInsets.symmetric(horizontal: 10), // Ajusta el padding interno
                          ),
                          validator: (value) => value == null ? 'Campo Requerido' : null,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Style.texFormField(
                  labelText: "Usuario",
                  controller: uusuario.txtlogin,
                  rxboolText: uusuario.boolpintartextlogin,
                  focusNode: uusuario.focotxtlogin,
                  validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                ),
                
                const SizedBox(height: 20),
                // Style.texFormField(
                //   labelText: "Clave",
                //   controller: uusuario.txtclave,
                //   rxboolText: uusuario.boolpintartextclave,
                //   focusNode: uusuario.focotxtclave,
                //   keyboard: TextInputType.visiblePassword,
                //   obscureText: uusuario.verclaveLogin,
                //   suffixIcon: Rx<Widget>(IconButton(
                //     icon: Obx(() => Icon(uusuario.verclaveLogin.value ? Icons.visibility : Icons.visibility_off)),
                //     onPressed: () => uusuario.verclaveLogin.value = !uusuario.verclaveLogin.value
                //   )),
                //   validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                // ),
          
                const SizedBox(height: 20),
                Style.btnElevatedButton(
                  minimumSize: Size(150, 40),
                  icon: Style.estiloIcon(icon: Icons.app_registration_rounded, size: 25, color: Style.colorBlanco),
                  label: "Guardar Usuario",
                  onPressed: () async {
                    if(uusuario.formKeyLogin.currentState!.validate()){
                      await usuariocontroller.editarusurio();
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