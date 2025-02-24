import 'dart:io';

import '../../../config/library/import.dart';

class Registrociudadanopage extends StatefulWidget {
  const Registrociudadanopage({super.key});

  @override
  State<Registrociudadanopage> createState() => _RegistrociudadanopageState();
}

class _RegistrociudadanopageState extends State<Registrociudadanopage> {
  final Uciudadano uciudadano = Get.put(Uciudadano());
  final Ciudadanocontroller ciudadanocontroller = Get.put(Ciudadanocontroller());	
  final List<String> items = [
    'Masculino',
    'Femenino',
  ];

  @override
  void initState() {
    super.initState();
    ciudadanocontroller.initStateRegistroCiudadano();
  }

  @override
  void dispose() {
    print("🗑️ Eliminando controladores...");
    Get.delete<Uciudadano>();	
    Get.delete<Ciudadanocontroller>();
    super.dispose();
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

              Obx(() => TextButton(
                onPressed: () async {
                  final resultado = await Global().obtenerImagen(tieneFoto: uciudadano.fotoCiudadano.value != null);

                  if (resultado.containsKey("foto") && resultado["foto"] != null) {
                    uciudadano.fotoCiudadano.value = File(resultado["foto"].path);
                  } else if (resultado.containsKey("eliminar") && resultado["eliminar"] == true) {
                    uciudadano.fotoCiudadano.value = null; // ✅ Borra la foto
                  }
                }, 
                child: uciudadano.fotoCiudadano.value == null 
                ? Column(
                    children: [
                      Style.estiloIcon(icon: Icons.camera_alt, size: 100),
                      Style.textTitulo(mensaje: "Foto"),
                    ],
                  ) 
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(uciudadano.fotoCiudadano.value!, width: 150, height: 150, fit: BoxFit.cover),
                  )
              )),   
            
              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Nombre Completo",
                controller: uciudadano.txtNombre,
                rxboolText: uciudadano.boolpintartxtNombre,
                focusNode: uciudadano.focotxtxtNombre,
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Style.texFormField(
                      labelText: "Apellido Paterno",
                      controller: uciudadano.txtApellidoPat,
                      rxboolText: uciudadano.boolpintartxtApellidoPat,
                      focusNode: uciudadano.focotxtApellidoPat,
                      validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 10), // Espaciado entre los elementos

                  Expanded(
                    child: Style.texFormField(
                      labelText: "Apellido Materno",
                      controller: uciudadano.txtApellidoMat,
                      rxboolText: uciudadano.boolpintartxtApellidoMat,
                      focusNode: uciudadano.focotxtApellidoMat,
                      validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
                    ),
                  ),
                ],
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
              Row(
                children: [
                  Expanded(
                    child: Style.texFormField(
                      labelText: "Celular",
                      controller: uciudadano.txtCelular,
                      rxboolText: uciudadano.boolpintartxtCelular,
                      focusNode: uciudadano.focotxtCelular,
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
                        value: uciudadano.txtSexo.value == "" ? null : uciudadano.txtSexo.value,
                        onChanged: (String? value) {
                          uciudadano.txtSexo.value = value!;
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
                obscureText: uciudadano.verClave,
                suffixIcon: Rx<Widget>(IconButton(
                  icon: Obx(() => Icon(uciudadano.verClave.value ? Icons.visibility : Icons.visibility_off)),
                  onPressed: () => uciudadano.verClave.value = !uciudadano.verClave.value
                )),
                validator: (p0) => p0.isEmpty ? 'Parametro Requerido' : null,
              ),

              const SizedBox(height: 20),
              Style.texFormField(
                labelText: "Confirmar Clave",
                controller: uciudadano.txtClave2,
                rxboolText: uciudadano.boolpintartxtClave2,
                focusNode: uciudadano.focotxtClave2,
                keyboard: TextInputType.visiblePassword,
                obscureText: uciudadano.verClave2,
                suffixIcon: Rx<Widget>(IconButton(
                  icon: Obx(() => Icon(uciudadano.verClave2.value ? Icons.visibility : Icons.visibility_off)),
                  onPressed: () => uciudadano.verClave2.value = !uciudadano.verClave2.value
                )),
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
                    Get.toNamed("/registrociudadanopage2");




                    // Get.toNamed("/registrociudadanopage2", preventDuplicates: false);
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