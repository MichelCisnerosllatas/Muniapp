import '../../../config/library/import.dart';

class Registrociudadano2page extends StatefulWidget {
  const Registrociudadano2page({super.key});

  @override
  State<Registrociudadano2page> createState() => _Registrociudadano2pageState();
}

class _Registrociudadano2pageState extends State<Registrociudadano2page> {
  final UciudadanoMapRegistrociudadano2 uciudadanoMapRegistrociudadano2page = Get.put(UciudadanoMapRegistrociudadano2());
  final MapBoxCiudadanoRegistroController mapBoxCiudadanoRegistroController = Get.find<MapBoxCiudadanoRegistroController>();
  
  final Uciudadano uciudadano = Get.find(); 
  final Ciudadanocontroller ciudadanocontroller = Get.find();

  @override
  void dispose() {
    print("🗑️ Eliminando controladores...");
    Get.delete<Ciudadanocontroller>();
    Get.delete<UciudadanoMapRegistrociudadano2>();
    Get.delete<MapBoxCiudadanoRegistroController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio y profesional
      appBar: AppBar(
        title: Text("Seleccione su Casa",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 3,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de bienvenida
            Style.estiloCard(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      radius: 30,
                      child: Icon(Icons.person, size: 30, color: Colors.blue),
                    ),
                    const SizedBox(width: 15),
                    Expanded( // <-- Solución: Esto permite que la columna use solo el espacio disponible
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Style.textTitulo(mensaje: "Hola, ${uciudadano.txtNombre.text} ${uciudadano.txtApellidoPat.text}", fontSize: 18, colorTexto: Colors.black),
                          Style.textSubTitulo(mensaje: "Por favor, selecciona tu ubicación."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 10),

            // Mensaje explicativo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "MuniApp necesita encontrar tu casa. Selecciona la que mejor se ajuste a tu ubicación.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 15),

            // Sección de Dropdowns
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Todas las Rutas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      selectRutasWidget()
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: selectRutasGuardadasWidget(),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Sección del mapa
            Expanded(
              child: Obx(() {
                if (uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value) {
                  return Center(child: LoadingAnimationWidget.hexagonDots(color: Colors.blueAccent, size: 25));
                } else if (!uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value) {
                  return const SizedBox.shrink();
                } else {
                  return Ciudadanowidget().mostrarMapaCiudadanoRegistro(data: {"id_ruta" : uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value == '' ? uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value : uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value});
                }
              }),
            ),
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        child: Icon(Icons.add_location, color: Colors.white, size: 40),
        onPressed: () => ciudadanocontroller.registrarCiudadanoyCoordenadasCasa(),
      ),
    );
  }

  Widget selectRutasGuardadasWidget() {
    return Obx(() {
      if (uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido
          children: [
            Style.textTitulo(mensaje: "Rutas Guardadas:"),
            DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton2<String>(
                isExpanded: true,
                hint: Style.textSubTitulo(mensaje: "Seleccione", colorTexto: Theme.of(context).colorScheme.onBackground ),
                items: uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
                  value: ruta['id_ruta'].toString(),
                  alignment: Alignment.centerLeft, // Asegura la alineación horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los elementos del Row
                    crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente el contenido
                    children: [
                      Expanded(
                        child: Style.textSubTitulo(mensaje: ruta['ruta_nombre']),
                      ),
                      IconButton(
                        onPressed: () async{
                          // Obtener el id_ruta actual
                          final idRuta = ruta['id_ruta'].toString();

                          // Eliminar el ítem de la lista
                          uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.removeWhere((item) {
                            return item["id_ruta"].toString() == idRuta;
                          });

                          // Validar si el valor seleccionado aún existe en la lista
                          final existe = uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.any((item) {
                            return item["id_ruta"].toString() == uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value;
                          });

                          // Si no existe, restablecer el valor seleccionado a null
                          if (!existe) {
                            uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value = '';
                          }
                          
                          uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadalista.clear();
                          uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.removeWhere((entry) => entry.containsKey(idRuta));                                      

                          // Confirmación de eliminación
                          uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value = false;
                          print("Ruta eliminada: ${ruta['ruta_nombre']} con ID: $idRuta");
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                )).toSet().toList(),
                value: uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value == '' ? null : uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value,
                onChanged: (value) async {
                  // uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value = value!;
                  // uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value = "";
                  // uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value = false;
                  // uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = true;

                  // await mapBoxCiudadanoRegistroController.listarrutasGuardadasCiudadano(idRuta: int.parse(value));

                  // await mapBoxCiudadanoRegistroController.limpiarAnotaciones();
                  // await mapBoxCiudadanoRegistroController.obtenerDetalleRutaMapBoxCiudadanoRegistro(idruta: int.parse(value), pantallaOrigen: 1);
                  
                  

                  // // // 🔹 Asegurar que la ruta se actualiza correctamente
                  // await mapBoxCiudadanoRegistroController.mostrarRutaCamionMapaCiudadano();
                  // await mapBoxCiudadanoRegistroController.mostrarAnotacionesRutaCoordenadaGuardada(value);


                  uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value = value!;
                  uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value = "";

                  uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value = false;
                  uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = true;
                  uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value = false;

                  // 🔹 Actualizar la ruta seleccionada
                  await mapBoxCiudadanoRegistroController.limpiarAnotaciones();
                  await mapBoxCiudadanoRegistroController.obtenerDetalleRutaMapBoxCiudadanoRegistro(idruta: int.parse(value), pantallaOrigen: 1); 
                  await mapBoxCiudadanoRegistroController.mostrarRutaCamionMapaCiudadano();
                  // await mapBoxCiudadanoRegistroController.mostrarIconosInicioFin();                              
                  // await mapBoxCiudadanoRegistroController.centrarMapaEnRutaCiudadano(); 
                  await mapBoxCiudadanoRegistroController.mostrarAnotacionesRutaCoordenadaGuardada(value);                             

                  uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = false;
                  uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value = true;
                },
                selectedItemBuilder: (context) {
                  return uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.map((ruta) {
                    return Align(
                      alignment: Alignment.centerLeft, // Alinea el texto horizontalmente en el padre
                      child: Style.textSubTitulo(mensaje: ruta['ruta_nombre']),
                    );
                  }).toList();
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
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
              )),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget selectRutasWidget(){
    return FutureBuilder(
      future: mapBoxCiudadanoRegistroController.listarutasCiudadanoDropdowsbutton(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25));
        } else if (snapshot.hasError) {
          return Text('Error al obtener la lista de rutas: ${snapshot.error}');
        } else {
          return DropdownButtonHideUnderline(
            child: Obx(() => DropdownButton2<String>(
              isExpanded: true,
              hint: Style.textSubTitulo(mensaje: "Selecciona la Ruta", colorTexto: Theme.of(context).colorScheme.onBackground),
              items: uciudadanoMapRegistrociudadano2page.listarutasCiudadanoDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
                value: ruta['id_ruta'].toString(),
                child: Style.textSubTitulo(mensaje: ruta['ruta_nombre']),
              )).toSet().toList(),
              value: uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value == '' ? null : uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value,
              onChanged: (value) async {
                uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value = value!;
                uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value = '';
                
                uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = true;
                uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value = false;
                uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value = true;
                

                await mapBoxCiudadanoRegistroController.listarrutasGuardadasCiudadano(idRuta: int.parse(value));

                await mapBoxCiudadanoRegistroController.limpiarAnotaciones();
                await mapBoxCiudadanoRegistroController.obtenerDetalleRutaMapBoxCiudadanoRegistro(idruta: int.parse(value), pantallaOrigen: 1);
                
                

                // // 🔹 Asegurar que la ruta se actualiza correctamente
                await mapBoxCiudadanoRegistroController.mostrarRutaCamionMapaCiudadano();
                // // await mapBoxCiudadanoRegistroController.cargarImagenIconosInicioFin();
                // await mapBoxCiudadanoRegistroController.mostrarIconosInicioFin();

                // // 🔹 Esperar un momento antes de centrar la cámara
                // await Future.delayed(Duration(milliseconds: 500));

                // await mapBoxCiudadanoRegistroController.centrarMapaEnRutaCiudadano();

                uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = false;
                if (!uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value) {
                  uciudadanoMapRegistrociudadano2page.mapaCaragadaCiudadano.value = true;
                }
              },

              buttonStyleData: ButtonStyleData(
                height: 50,
                // padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                elevation: 2,
              ),
              iconStyleData: IconStyleData(
                iconSize: 30,
                iconEnabledColor: Theme.of(context).colorScheme.onBackground,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                // padding: EdgeInsets.only(left: 14, right: 14),
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
              // menuItemStyleData: const MenuItemStyleData(
              //   height: 40,
              //   padding: EdgeInsets.only(left: 14, right: 14),
              // ),
            )),
          );
        }
      },
    );
  }
}

class RegistroCiudadano2Binding extends Bindings {
  @override
  void dependencies() {
    // Mantener Uciudadano en memoria porque es compartido entre ambas pantallas
    if (!Get.isRegistered<Uciudadano>()) {
      Get.put(Uciudadano(), permanent: true);
    }

    // Eliminar Ciudadanocontroller cuando salgas de registrociudadanopage2    
    Get.lazyPut(() => UciudadanoMapRegistrociudadano2(), fenix: true);
    Get.lazyPut(() => MapBoxCiudadanoRegistroController(), fenix: true);
    Get.lazyPut(() => Ciudadanocontroller(), fenix: true);
  }
}