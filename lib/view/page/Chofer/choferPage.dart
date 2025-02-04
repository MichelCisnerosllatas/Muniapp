import '../../../config/library/import.dart';

class Choferpage extends StatefulWidget {
  const Choferpage({super.key});

  @override
  State<Choferpage> createState() => _ChoferpageState();
}

class _ChoferpageState extends State<Choferpage> with WidgetsBindingObserver{
  final Urutas urutas = Get.find<Urutas>();
  final UServidor uservidor = Get.find<UServidor>();
  final UUsuario uusuario = Get.find<UUsuario>();
  final Uchofer uchofer = Get.find();
  final tubicacion = Get.find<Tubicacion>();

  @override
  void initState() {
    super.initState();
    Chofercontroller().initStateChofer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("Estado de la app: $state");

    if (state == AppLifecycleState.paused) {
      print("🔴 La app se fue al fondo o se minimizó.");
      uchofer.saberAppCerrado.value = true; //✅ Se fue al fondo realmente
    }

    if (state == AppLifecycleState.inactive) {
      Future.delayed(Duration(milliseconds: 500), () { 
        // Si después de 500ms no entró en "paused", significa que solo abrió notificaciones
        if (!uchofer.saberAppCerrado.value ) {
          print("📩 El usuario solo abrió la barra de notificaciones.");
        }
      });
    }

    if (state == AppLifecycleState.resumed) {
      print("🔄 El usuario ha vuelto a la aplicación.");
      if (uchofer.saberAppCerrado.value){
        
        // Solo ejecutar si realmente la app se fue al fondo
        if(uchofer.saberNaveMapEligida.value == 1){
          //se ejecuta solo si el suuario elegio Google Maps
          await Navegcioncontroller().detenerSeguimientoNavegacion(para: {
            "idruta": int.parse(urutas.idRutaSeleccionadaValue.value == '' ? '0' : urutas.idRutaSeleccionadaValue.value),
            "idinicioruta" : urutas.idinicioruta.value,
            "iduser": uusuario.usuariologin["id_users"]
          });
        }
        
        // Detener el rastreo al volver a la app
        uchofer.saberAppCerrado.value  = false; // Resetear la variable
      }      
    }
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: false, 
        title: Style.textTitulo(mensaje: "MUNI", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        actions: [
          Obx((){
            if (tubicacion.latidude.value == 0 && tubicacion.longitude.value == 0){
              return SizedBox.shrink();
            }else{
              return Ubicacionwidget().seleccionarEstiloComoPopupMenu();
            }
          }),
        ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 10),
            child: Style.textTitulo(mensaje: Global().obtenerSaludo()),
          ),

          Style.estiloCard(
            elevation: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 25,
                    child: Builder(
                      builder: (context) {
                        List<String> palabras = uusuario.usuariologin['name'].split(' ');
                        String iniciales;
            
                        if (palabras.length > 1 && palabras[1].isNotEmpty) { 
                          iniciales = palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
                        } else {
                          iniciales = palabras[0].substring(0, 1);
                        }
            
                        return Style.textTitulo(mensaje: iniciales.toUpperCase().toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Style.textTitulo(mensaje: "Hola, ${uusuario.usuariologin['name']}"),
                        Style.textSubTitulo(mensaje: "su rol es chofer."),
                        // Style.textSubTitulo(mensaje: uusuario.usuariologin['email']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child:  Style.textSubTitulo(mensaje: "Para iniciar la navegacion, primero selecciona una ruta, despues en 'Iniciar Ruta'", maxlines: 3),
          ),
          
          FutureBuilder(
            future: Chofercontroller().listarrutas(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25));
              } else if (snapshot.hasError) {
                return Text('Error al obtener la lista de rutas: ${snapshot.error}');
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButtonHideUnderline(
                      child: Obx(() => DropdownButton2<String>(
                        isExpanded: true,
                        hint: Style.textTitulo(mensaje: "Seleccione una Ruta"),
                        items: urutas.listarutasDropdowsbutton.map((ruta) => DropdownMenuItem<String>(
                          value: ruta['id_ruta'].toString(),
                          child: Style.textSubTitulo(mensaje: ruta['ruta_nombre'])
                        )).toSet().toList(),
                        value: urutas.idRutaSeleccionadaValue.value == '' ? null : urutas.idRutaSeleccionadaValue.value,
                        onChanged: (value) async{
                          urutas.idRutaSeleccionadaValue.value = value!; 
                          tubicacion.cargarLocalizar.value = true; 
                          // await Ubicacioncontroller().obtenerUbicacionActual(); 
                          if(!tubicacion.mapaCargada.value) tubicacion.mapaCargada.value = true;                      
                          await Ubicacioncontroller().obtenerCoordenasdetalleRutaChofer(idruta: int.parse(value));
                          tubicacion.cargarLocalizar.value = false;
                          // await Ubicacioncontroller().agregarRutaAlMapa();
                          // await Ubicacioncontroller().agregarIconosInicioFin();
                          // await Ubicacioncontroller().centrarMapaEnRuta();
                          // await Chofercontroller().seleccionarRuta(idruta: int.parse(value));
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.only(left: 14, right: 14),
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
                          iconSize: 20,
                          iconEnabledColor: Colors.yellow,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Theme.of(context).appBarTheme.backgroundColor!,
                            ),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ))
                    ),
                    
                    Obx((){
                      if(tubicacion.mapaCargada.value){
                        return ElevatedButton.icon(
                          onPressed: () {
                            uservidor.mensajesubTituloServidor2.value = "Obteniendo ubicacion...";
                            bool res = false;
                            Navegcioncontroller().showModalBottomSheetPreguntarAplicacion(
                              btnGoogleMaps: () async {
                                Navigator.pop(context);
                                Global().modalCircularProgress(context: context, mensaje: uservidor.mensajesubTituloServidor2);
                                res = await Ubicacioncontroller().obtenerUbicacionActual();
                                if(res){
                                  uservidor.mensajesubTituloServidor2.value = "iniciando ruta...";
                                  uchofer.saberNaveMapEligida.value = 1;
                                  await Chofercontroller().iniciarRuta(idruta: int.parse(urutas.idRutaSeleccionadaValue.value));
                                  await Notifacionmodel().enviaarNotificacionChofer(idruta: int.parse(urutas.idRutaSeleccionadaValue.value), tiponotificacion: "inicio");
                                  
                                  //Obtengo las Coordenas Final del Detlle ruta.
                                  final mapRuta = urutas.listarutas.firstWhere((e) => e["id_ruta"] == int.parse(urutas.idRutaSeleccionadaValue.value), orElse: () => {});
                                  List<dynamic> coords = mapRuta['detalleruta'];
                                  final mapRuta2 = coords.map((coord) {
                                    double? lat = double.tryParse(coord['detalle_ruta_coordenada_y'] ?? '');
                                    double? lng = double.tryParse(coord['detalle_ruta_coordenada_x'] ?? '');

                                    // Asegurarse de que los valores no sean nulos antes de agregarlos a la lista
                                    if (lat != null && lng != null) {
                                      return [lat, lng];
                                    } else {
                                      throw Exception("Coordenada inválida en la ruta.");
                                    }
                                  }).toList();

                                  var ubifinal = mapRuta2.last;
                                  
                                  Navigator.pop(context);
                                  await Navegcioncontroller().abrirGoogleMapsConCoordenadas(
                                    lonInicio: tubicacion.longitude.value,
                                    latInicio: tubicacion.latidude.value,
                                    lonDestino: ubifinal[0],
                                    latDestino: ubifinal[1],
                                    // lonDestino: -73.26043125965342,
                                    // latDestino: -3.739575981400892
                                  );
                                }                    
                              },
                              btnMuniappMaps: () async { 
                                Navigator.pop(context);
                                Global().modalCircularProgress(context: context, mensaje: uservidor.mensajesubTituloServidor2);
                                res = await Ubicacioncontroller().obtenerUbicacionActual();                              
                                if(res){
                                  uservidor.mensajesubTituloServidor2.value = "iniciando ruta...";
                                  await Chofercontroller().iniciarRuta(idruta: int.parse(urutas.idRutaSeleccionadaValue.value));
                                  await Notifacionmodel().enviaarNotificacionChofer(idruta: int.parse(urutas.idRutaSeleccionadaValue.value), tiponotificacion: "inicio");
                                  Navigator.pop(context);
                                  uchofer.saberNaveMapEligida.value = 2;
                                  Get.toNamed("/navegacionpage", 
                                    arguments: {
                                      "idruta": int.parse(urutas.idRutaSeleccionadaValue.value),
                                      "idinicioruta" : urutas.idinicioruta.value,
                                      "iduser": uusuario.usuariologin["id_users"]
                                    }
                                  );
                                }     
                              }
                            );                                                   
                          }, 
                          label: Style.textSubTitulo(mensaje: "Iniciar Ruta"),
                          icon: Icon(Icons.location_on),
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }else{
                        return SizedBox.shrink();
                      }
                    })
                                       
                  ],
                );
              }
            }
          ),
          
      
          Expanded(
            child: Obx(() {
              if (tubicacion.cargarLocalizar.value) {
                return Center(
                  child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25 ),
                );
              } else if(!tubicacion.mapaCargada.value){ 
                return SizedBox.shrink();
              }else{                
                return Ubicacionwidget().mostrarMapa2();
              }
            }),
          )
        ],
      )
    );
  }
}