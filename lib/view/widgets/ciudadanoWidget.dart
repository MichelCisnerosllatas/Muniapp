import 'dart:ui';
import '../../config/library/import.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class Ciudadanowidget {
  final UciudadanoMapRegistrociudadano2 uciudadanoMapRegistrociudadano2page = Get.find<UciudadanoMapRegistrociudadano2>();
  final UciudadanoMapciudadanapage2 uciudadanoMapciudadanapage2page = Get.find<UciudadanoMapciudadanapage2>();
  final MapBoxCiudadanoRegistroController mapBoxCiudadanoRegistroController = Get.find<MapBoxCiudadanoRegistroController>();
  final MapBoxCiudadanoPage2Controller mapBoxCiudadanoPage2Controller = Get.find<MapBoxCiudadanoPage2Controller>();
  final Uciudadano uciudadano = Get.find<Uciudadano>();
  final UServidor uservidor = Get.find<UServidor>();
  final Ciudadanocontroller ciudadanocontroller = Get.find<Ciudadanocontroller>();

  Obx mostrarRutasCiudadanoInicio(){
    return Obx((){
      if(uservidor.cargaprogreso.value){
        return Center( child: LoadingAnimationWidget.hexagonDots(color: Theme.of(Get.context!).appBarTheme.backgroundColor!, size: 25));
      }else{
        return ListView.builder(
          itemCount: uciudadano.listarutasCiudadanoInicio.length,
          itemBuilder: (context, index) {
            final item = uciudadano.listarutasCiudadanoInicio[index];
            return Style.estiloCard(
              child: ListTile(
                onTap: () => Get.toNamed('/ciudadanopage2', arguments: item),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                leading: Style.estiloIcon(icon: Icons.check_circle, size: 25, color: (item.containsKey("ruta_activa") && item["ruta_activa"] is Map && item["ruta_activa"]?["activa"] == true) ? Colors.greenAccent : Theme.of(context).colorScheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), 
                  // side: BorderSide(color: Theme.of(Get.context!).appBarTheme.backgroundColor!, width: 2)
                ),
                title: Style.textTitulo(mensaje: item['ruta_nombre']),
                subtitle: Style.textSubTitulo(mensaje: item['ruta_descripcion']),
                trailing: Style.estiloIcon(icon: Icons.arrow_forward_ios, size: 20),              
              ),
            );
          }
        );
      }
    });
  }
  
  Widget mostrarMapaCiudadanoRegistro({Map<String, dynamic>? data}) {
    return Stack(
      children: [
        // Widget del Mapa
        Obx(() {
          return mapbox.MapWidget(
            key: ValueKey("mapWidgetCiudadano"),
            styleUri: uciudadanoMapRegistrociudadano2page.mapaEstiloCiudadano.value,
            onMapCreated: (mapboxMap) {
              mapBoxCiudadanoRegistroController.crearMapBoxCiudadano(mapboxMap);              
            },
            onMapLoadedListener: (mapLoadedEventData) async{
              await mapBoxCiudadanoRegistroController.obtenerDetalleRutaMapBoxCiudadanoRegistro(idruta: int.parse(data?['id_ruta'].toString() ?? '0'));
              await mapBoxCiudadanoRegistroController.cargarImagenIconosInicioFin();
              await mapBoxCiudadanoRegistroController.mostrarRutaCamionMapaCiudadano();
              await mapBoxCiudadanoRegistroController.mostrarIconosInicioFin();
              await mapBoxCiudadanoRegistroController.centrarMapaEnRutaCiudadano();
            },
            onTapListener: (mapbox.MapContentGestureContext context) {
              if(uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value){
                mapBoxCiudadanoRegistroController.onMapTapCiudadano(context);       
              }                     
            },
          );
        }),

        Positioned(
          bottom: 5,
          left: 0,
          right: 65,
          child: Obx(() {
            if(uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value && uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.isNotEmpty){
              return Container(
                height: 57,  // Reducido el tamaño total de la lista
                padding: EdgeInsets.only(left: 5, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),  // Bordes redondeados más sutiles
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),  // Efecto de desenfoque más suave
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),  // Opacidad reducida para mejor visibilidad del fondo
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            clipBehavior: Clip.none, // Permite que el ícono sobresalga del contenedor
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if(uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value){
                                    mapBoxCiudadanoRegistroController.eliminarAnotacionMapaCiudadano(index);
                                  }                              
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.withOpacity(0.7),
                                        Colors.blueAccent.withOpacity(0.9)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on, color: Colors.white, size: 20),  // Icono más pequeño
                                      SizedBox(width: 6),
                                      Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,  // Tamaño del número reducido
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Ícono de eliminar en la parte superior
                              Positioned(
                                // top: -2, // Ajusta la posición arriba del elemento
                                right: -2, // Ajusta la posición a la derecha del elemento
                                child: GestureDetector(
                                  onTap: () {
                                    mapBoxCiudadanoRegistroController.eliminarAnotacionMapaCiudadano(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent, // Color de fondo para destacar
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Icon(Icons.close, color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            } else if(!uciudadanoMapRegistrociudadano2page.saberDropDowButtonSeleccionado.value && uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadalista.isNotEmpty){
              return Container(
                height: 57,  // Reducido el tamaño total de la lista
                padding: EdgeInsets.only(left: 5, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),  // Bordes redondeados más sutiles
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),  // Efecto de desenfoque más suave
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),  // Opacidad reducida para mejor visibilidad del fondo
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Colors.white.withOpacity(0.3)), // Borde más sutil
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadalista.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              //ciudadanocontroller.eliminarAnotacionMapaCiudadano(index);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.7),
                                    Colors.blueAccent.withOpacity(0.9)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white, size: 20),  // Icono más pequeño
                                  SizedBox(width: 6),
                                  Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,  // Tamaño del número reducido
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            } else{
              return SizedBox.shrink();
            }
          }),
        )
      ],
    );
  }

  Widget mostrarMapaCiudadanoInicioPagina2({int idinicioruta = 0, int idruta = 0}) {
    return Stack(
      children: [
        Obx(() {
          return mapbox.MapWidget(
            key: ValueKey("mapWidgetCiudadanoInicio"),
            styleUri: uciudadanoMapRegistrociudadano2page.mapaEstiloCiudadano.value,
            onMapCreated: (mapboxMap) {
              mapBoxCiudadanoPage2Controller.crearMapBoxCiudadanoPage2(mapboxMap);
              mapBoxCiudadanoPage2Controller.inicializarPointAnnotationManager();
            },
            onMapLoadedListener: (mapLoadedEventData) async {
              await mapBoxCiudadanoPage2Controller.cargarImagenVehiculo();
              await mapBoxCiudadanoPage2Controller.obtenerDetalleRutaMapBoxCiudadanoRegistro(idruta: idruta);
              await mapBoxCiudadanoPage2Controller.cargarImagenIconosInicioFin();
              await mapBoxCiudadanoPage2Controller.mostrarRutaCamionMapaCiudadano();
              await mapBoxCiudadanoPage2Controller.mostrarPuntosInicioFin();
              
              // ✅ Se centra la ruta después de asegurarse de que todo está listo
              await mapBoxCiudadanoPage2Controller.centrarMapaEnRutaCiudadano();
            },
          );
        }),

        // 🔹 Este `Obx()` detecta cuando `coordenadaCamionActual` cambia y muestra el icono del vehículo
        Obx(() {
          if (uciudadanoMapciudadanapage2page.coordenadaCamionActual.isNotEmpty) {
            print("🚚 Coordenada del camión 2: ${uciudadanoMapciudadanapage2page.coordenadaCamionActual}");
            mapBoxCiudadanoPage2Controller.mostrarIconoVehiculo(uciudadanoMapciudadanapage2page.coordenadaCamionActual);
          }
          return SizedBox(); // No renderiza nada, solo escucha cambios
        }),
      ],
    );
  }
}