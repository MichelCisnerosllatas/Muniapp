import 'package:muniapp/view/widgets/ciudadanoWidget.dart';

import '../../../config/library/import.dart';

class Registrociudadano2page extends StatefulWidget {
  const Registrociudadano2page({super.key});

  @override
  State<Registrociudadano2page> createState() => _Registrociudadano2pageState();
}

class _Registrociudadano2pageState extends State<Registrociudadano2page> {
  final Uciudadano uciudadano = Get.find<Uciudadano>();
  final Ciudadanocontroller ciudadanocontroller = Get.find<Ciudadanocontroller>();

  @override
  void initState() {
    super.initState();    
    // ciudadanocontroller.limpiarAnotaciones();
    // uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        title: Style.textTitulo(mensaje: "Seleccione su Casa")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Style.textTitulo(mensaje: "Hola, ${uciudadano.txtNombre.text} ${uciudadano.txtApellidoPat.text}", fontSize: 18),
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Style.textSubTitulo(mensaje: "MuniApp necesita encontrar tu casa, Selecciona la que mejor se ajuste a tu ubicación.", fontSize: 14, maxlines: 5),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1, // La segunda columna ocupa una parte proporcional
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido
                  children: [
                    Style.textTitulo(mensaje: "Todas las Rutas"),
                    FutureBuilder(
                      future: Ciudadanocontroller().listarrutasCiudadano(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25));
                        } else if (snapshot.hasError) {
                          return Text('Error al obtener la lista de rutas: ${snapshot.error}');
                        } else {
                          return Container(
                            padding: EdgeInsets.all(5),
                            child: DropdownButtonHideUnderline(
                              child: Obx(() => DropdownButton2<String>(
                                isExpanded: true,
                                hint: Style.textSubTitulo(mensaje: "Selecciona la Ruta", colorTexto: Theme.of(context).colorScheme.onBackground),
                                items: uciudadano.listarutasCiudadanoDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
                                  value: ruta['id_ruta'].toString(),
                                  child: Style.textSubTitulo(mensaje: ruta['ruta_nombre']),
                                )).toSet().toList(),
                                value: uciudadano.idRutaCiudadanoSeleccionadaValue.value == '' ? null : uciudadano.idRutaCiudadanoSeleccionadaValue.value,
                                onChanged: (value) async {
                                  uciudadano.idRutaCiudadanoSeleccionadaValue.value = value!;
                                  uciudadano.cargarMapaLocalizarCiudadano.value = true;
                                  uciudadano.saberDropDowButtonSeleccionado.value = true;

                                  await ciudadanocontroller.listarrutasGuardadasCiudadano(idRuta: int.parse(value));

                                  await ciudadanocontroller.limpiarAnotaciones();
                                  await ciudadanocontroller.detalleRutaCamionCiudadano(idruta: int.parse(value), pantallaOrigen: 1);
                                  if (!uciudadano.mapaCaragadaCiudadano.value) {
                                    uciudadano.mapaCaragadaCiudadano.value = true;
                                  }
                                  await ciudadanocontroller.agregarRutaAlMapaCiudadano();
                                  await ciudadanocontroller.agregarIconosInicioFinCiudadano();
                                  await ciudadanocontroller.centrarMapaEnRutaCiudadano();

                                  uciudadano.cargarMapaLocalizarCiudadano.value = false;
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
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Espaciado entre columnas
              
              Expanded(
                flex: 1, // La primera columna ocupa una parte proporcional
                child: Obx(() {
                  if (uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido
                      children: [
                        Style.textTitulo(mensaje: "Rutas Guardadas:"),
                        DropdownButtonHideUnderline(
                          child: Obx(() => DropdownButton2<String>(
                            isExpanded: true,
                            hint: Style.textSubTitulo(mensaje: "Seleccione", colorTexto: Theme.of(context).colorScheme.onBackground ),
                            items: uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
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
                                      uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.removeWhere((item) {
                                        return item["id_ruta"].toString() == idRuta;
                                      });

                                      // Validar si el valor seleccionado aún existe en la lista
                                      final existe = uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.any((item) {
                                        return item["id_ruta"].toString() == uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value;
                                      });

                                      // Si no existe, restablecer el valor seleccionado a null
                                      if (!existe) {
                                        uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value = '';
                                      }
                                      
                                      uciudadano.coordenadaCasaGuardadalista.clear();
                                      uciudadano.coordenadaCasaGuardadaMap.removeWhere((entry) => entry.containsKey(idRuta));                                      

                                      // Confirmación de eliminación
                                      uciudadano.saberDropDowButtonSeleccionado.value = false;
                                      print("Ruta eliminada: ${ruta['ruta_nombre']} con ID: $idRuta");
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                                ],
                              ),
                            )).toSet().toList(),
                            value: uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value == '' ? null : uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value,
                            onChanged: (value) async {
                              uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value = value!;
                              uciudadano.idRutaCiudadanoSeleccionadaValue.value = "";

                              uciudadano.saberDropDowButtonSeleccionado.value = false;
                              uciudadano.cargarMapaLocalizarCiudadano.value = true;

                              // 🔹 Actualizar la ruta seleccionada
                              await ciudadanocontroller.limpiarAnotaciones();
                              await ciudadanocontroller.detalleRutaCamionCiudadano(idruta: int.parse(value), pantallaOrigen: 1); 
                              await ciudadanocontroller.agregarRutaAlMapaCiudadano();
                              await ciudadanocontroller.agregarIconosInicioFinCiudadano();                              
                              await ciudadanocontroller.centrarMapaEnRutaCiudadano(); 
                              await ciudadanocontroller.mostrarAnotacionesRutaCoordenadaGuardada(value);                             

                              uciudadano.cargarMapaLocalizarCiudadano.value = false;
                            },
                            selectedItemBuilder: (context) {
                              return uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.map((ruta) {
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
                }),
              ),              
            ],
          ),

          Expanded(
            child: Obx(() {
              if (uciudadano.cargarMapaLocalizarCiudadano.value) {
                return Center(
                  child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25 ),
                );
              } else if(!uciudadano.mapaCaragadaCiudadano.value){ 
                return SizedBox.shrink();
              }else{                
                return Ciudadanowidget().mostrarMapaCiudadanoRegistro();
              }
            }),
          )
      
          
          // FutureBuilder(
          //   future: Ciudadanocontroller().listarrutasCiudadano(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25));
          //     } else if (snapshot.hasError) {
          //       return Text('Error al obtener la lista de rutas: ${snapshot.error}');
          //     } else {
          //       return Container(
          //         padding: EdgeInsets.all(5),
          //         child: DropdownButtonHideUnderline(
          //           child: Obx(() => DropdownButton2<String>(
          //             isExpanded: true,
          //             hint: Style.textTitulo(mensaje: "Selecciona la RUta", colorTexto: Theme.of(context).colorScheme.onBackground),
          //             items: uciudadano.listarutasCiudadanoDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
          //               value: ruta['id_ruta'].toString(),
          //               child: Style.textTitulo(mensaje: ruta['ruta_nombre'])
          //             )).toSet().toList(),
          //             value: uciudadano.idRutaCiudadanoSeleccionadaValue.value == '' ? null : uciudadano.idRutaCiudadanoSeleccionadaValue.value,
          //             onChanged: (value) async{
          //               uciudadano.idRutaCiudadanoSeleccionadaValue.value = value!;
          //               uciudadano.cargarMapaLocalizarCiudadano.value = true;

          //               // Limpia el estado anterior
          //               await ciudadanocontroller.limpiarAnotaciones();

          //               // Cargar los detalles de la nueva ruta
          //               await ciudadanocontroller.detalleRutaCamionCiudadano(idruta: int.parse(value));
          //               if (!uciudadano.mapaCaragadaCiudadano.value) {
          //                 uciudadano.mapaCaragadaCiudadano.value = true;
          //               }

          //               // Agregar la nueva ruta al mapa
          //               await ciudadanocontroller.agregarRutaAlMapaCiudadano();
          //               await ciudadanocontroller.agregarIconosInicioFinCiudadano();
          //               await ciudadanocontroller.centrarMapaEnRutaCiudadano();

          //               uciudadano.cargarMapaLocalizarCiudadano.value = false;
          //               print("Nueva ruta cargada: $value");
          //             },
          //             buttonStyleData: ButtonStyleData(
          //               height: 50,
          //               padding: const EdgeInsets.only(left: 14, right: 14),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(14),
          //                 border: Border.all(
          //                   color: Theme.of(context).colorScheme.onBackground,
          //                 ),
          //                 color: Theme.of(context).colorScheme.background,
          //               ),
          //               elevation: 2,
          //             ),
          //             iconStyleData: IconStyleData(
          //               iconSize: 30,
          //               iconEnabledColor: Theme.of(context).colorScheme.onBackground,
          //               iconDisabledColor: Colors.grey,
          //             ),
          //             dropdownStyleData: DropdownStyleData(
          //               maxHeight: 200,
          //               padding: EdgeInsets.only(left: 14, right: 14),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(14),
          //                 border: Border.all(
          //                   color: Theme.of(context).appBarTheme.backgroundColor!,
          //                 ),
          //                 color: Theme.of(context).colorScheme.background,
          //               ),
          //               // offset: const Offset(-20, 0),
          //               scrollbarTheme: ScrollbarThemeData(
          //                 radius: const Radius.circular(40),
          //                 thickness: MaterialStateProperty.all<double>(6),
          //                 thumbVisibility: MaterialStateProperty.all<bool>(true),
          //               ),
          //             ),
          //             menuItemStyleData: const MenuItemStyleData(
          //               height: 40,
          //               padding: EdgeInsets.only(left: 14, right: 14),
          //             ),
          //           ))
          //         ),
          //       );
          //     }
          //   }
          // ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.white.withOpacity(0.5),
        child: Icon(Icons.add_location, color: Theme.of(context).colorScheme.onBackground, size: 40),
        onPressed: () => ciudadanocontroller.registrarCiudadanoyCoordenadasCasa()     	
      ),
    );
  }
}