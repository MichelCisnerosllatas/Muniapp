import 'dart:ui';

import '../../config/library/import.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class Ciudadanowidget {
  final Uciudadano uciudadano = Get.find();
  final UServidor uservidor = Get.find();
  final Ciudadanocontroller ciudadanocontroller = Get.find();

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
                leading: Style.estiloIcon(icon: Icons.check_circle, size: 25, color: item["ruta_activa"] == true ? Colors.greenAccent : Theme.of(context).colorScheme.error),
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
  
  Widget mostrarMapaCiudadanoRegistro() {
    return Stack(
      children: [
        // Widget del Mapa
        Obx(() {
          return mapbox.MapWidget(
            key: ValueKey("mapWidgetCiudadano"),
            styleUri: uciudadano.mapaEstiloCiudadano.value,
            onMapCreated: (mapboxMap) async {
              ciudadanocontroller.crearMapBoxCiudadano(mapboxMap);
              await ciudadanocontroller.agregarRutaAlMapaCiudadano();
              await ciudadanocontroller.agregarIconosInicioFinCiudadano();
              await ciudadanocontroller.centrarMapaEnRutaCiudadano();
              // if(!uciudadano.saberDropDowButtonSeleccionado.value){
              //   await ciudadanocontroller.mostrarAnotacionesRutaCoordenadaGuardada(uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value);
              // }
            },
            onTapListener: (mapbox.MapContentGestureContext context) {
              if(uciudadano.saberDropDowButtonSeleccionado.value){
                ciudadanocontroller.onMapTapCiudadano(context);       
              }                     
            },
          );
        }),

        Positioned(
          bottom: 15,
          left: 0,
          right: 65,
          child: Obx(() {
            if(uciudadano.saberDropDowButtonSeleccionado.value && uciudadano.coordenadasCasaCiudadano.isNotEmpty){
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
                        itemCount: uciudadano.coordenadasCasaCiudadano.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            clipBehavior: Clip.none, // Permite que el ícono sobresalga del contenedor
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if(uciudadano.saberDropDowButtonSeleccionado.value){
                                    ciudadanocontroller.eliminarAnotacionMapaCiudadano(index);
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
                                    ciudadanocontroller.eliminarAnotacionMapaCiudadano(index);
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
            } else if(!uciudadano.saberDropDowButtonSeleccionado.value && uciudadano.coordenadaCasaGuardadalista.isNotEmpty){
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
                        itemCount: uciudadano.coordenadaCasaGuardadalista.length,
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

  Widget mostrarMapaCiudadanoInicioPagina2({required Map<String, dynamic> data}) {
    return Stack(
      children: [

        // Widget del Mapa
        Obx(() {
          return mapbox.MapWidget(
            key: ValueKey("mapWidgetCiudadanoInicio"),
            styleUri: uciudadano.mapaEstiloCiudadano.value,
            onMapCreated: (mapboxMap) async {
              ciudadanocontroller.crearMapBoxCiudadano(mapboxMap);
              await ciudadanocontroller.detalleRutaCamionCiudadano(idruta: Get.arguments['id_ruta']);
              await ciudadanocontroller.agregarRutaAlMapaCiudadano();
              await ciudadanocontroller.agregarIconosInicioFinCiudadano();
              await ciudadanocontroller.centrarMapaEnRutaCiudadano();
            },
          );
        }),
      ],
    );
  }
}