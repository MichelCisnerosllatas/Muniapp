import 'package:flutter/rendering.dart';
import '../../../config/library/import.dart';

class Detallerecolectorpage extends StatefulWidget {
  const Detallerecolectorpage({super.key});

  @override
  State<Detallerecolectorpage> createState() => _DetallerecolectorpageState();
}

class _DetallerecolectorpageState extends State<Detallerecolectorpage> {
  final ScrollController _scrollController = ScrollController();
  final Trecolector urecoletor = Get.find<Trecolector>();

  @override
  void initState() {
    super.initState();
    urecoletor.mostrarDetalle.value = false;
    urecoletor.mostrarScroolTOPDetalle.value = false;
    urecoletor.offsetScrollDetalle.value = 0;
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double offset = _scrollController.offset;
    if(offset <= 210 && urecoletor.mostrarDetalle.value){
      urecoletor.mostrarDetalle.value = false;
    }
    if(offset > 210 && !urecoletor.mostrarDetalle.value){
      urecoletor.mostrarDetalle.value = true;
    }

    //Para saber si se llego al ultimo y al primero
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      urecoletor.mostrarScroolTOPDetalle.value = true; // Ocultar al hacer scroll hacia abajo
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      urecoletor.mostrarScroolTOPDetalle.value = false; // Mostrar al hacer scroll hacia arriba
    }

    // if (offset > umbralOcultar && urecoletor.mostrarDetalle.value) {
    //   // 📌 Si el usuario baja más de "umbralOcultar", ocultamos el widget
    //   urecoletor.mostrarDetalle.value = true;
    // } else if (offset < umbralMostrar && !urecoletor.mostrarDetalle.value) {
    //   // 📌 Si el usuario sube por encima de "umbralMostrar", mostramos el widget
    //   urecoletor.mostrarDetalle.value = false;
    // }

    urecoletor.offsetScrollDetalle.value = offset; // Guardamos la última posición

    
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _detalleFlotante(){
    return Style.estiloCard(
      colorBorde: Colors.transparent,
      elevation: 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Asegura alineación correcta
        children: [
          // 📌 Imagen del vehículo
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              Get.arguments["vehiculo_foto"].toString(),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.car_crash, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
      
          const SizedBox(width: 10),
      
          // 📌 Contenedor con la información del vehículo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea correctamente los textos
              children: [
                Recolectorwidget().infoRowDetalleRecolector("Nombre Vehículo:", Get.arguments["vehiculo_nombre"]),
                Divider(),
                Recolectorwidget().infoRowDetalleRecolector("Tipo de vehículo:", Get.arguments["tipo_vehiculo_nombre"]),
                Divider(),
                Recolectorwidget().infoRowDetalleRecolector("Marca del vehículo:", Get.arguments["vehiculo_marca"]),
                Divider(),
                Recolectorwidget().infoRowDetalleRecolector("Serie del vehículo:", Get.arguments["vehiculo_serie"]),
              ],
            ),
          ),
      
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        title:  Style.textTitulo(mensaje: "Detalle Recolector")
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,          
              children: [
                Style.textTitulo(mensaje: "Ficha del Vehículo", fontSize: 16 ),
                const SizedBox(height: 10),
                Style.estiloCard(
                  colorBorde: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          Get.arguments["vehiculo_foto"].toString(),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[300],
                              child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[300],
                              child: Icon(Icons.car_crash, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
          
          
                      const SizedBox(height: 20),
                      Recolectorwidget().infoRowDetalleRecolector("Nombre Vehículo:", Get.arguments["vehiculo_nombre"]),
                      Divider(),
                      Recolectorwidget().infoRowDetalleRecolector("Tipo de vehículo:", Get.arguments["tipo_vehiculo_nombre"]),
                      Divider(),
                      Recolectorwidget().infoRowDetalleRecolector("Marca del vehículo:", Get.arguments["vehiculo_marca"]),
                      Divider(),
                      Recolectorwidget().infoRowDetalleRecolector("Serie del vehículo:", Get.arguments["vehiculo_serie"]),
                    ],
                  )
                ),

                const SizedBox(height: 20),
                Style.textTitulo(mensaje: "Características", negitra: true, colorTexto: Theme.of(context).appBarTheme.backgroundColor),
                
                const SizedBox(height: 10),   
                Style.estiloCard(
                  elevation: 5,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [   
                            const SizedBox(height: 20),
                            Recolectorwidget().infoRowDetalleRecolector("Longitud del Vehículo:", Get.arguments["vehiculo_longitud"]),
                        
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Ancho del Vehículo:", Get.arguments["vehiculo_ancho"]),
                        
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Altura del Vehículo:", "${Get.arguments["vehiculo_altura"].toString()} Mt"),
                        
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Año del modelo:", Get.arguments["vehiculo_anho_modelo"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Color Principal:", Get.arguments["vehiculo_color_uno"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Color Secundario:", Get.arguments["vehiculo_color_dos"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Año de fabricación:", Get.arguments["vehiculo_anho_fabricacion"]),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  )
                ),
          
                const SizedBox(height: 20),
                Style.textTitulo(mensaje: "Capacidades y Pesos", negitra: true, colorTexto: Theme.of(context).appBarTheme.backgroundColor),
                Style.estiloCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Recolectorwidget().infoRowDetalleRecolector("Peso neto del vehículo:", Get.arguments["vehiculo_anho_fabricacion"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Peso bruto del vehículo:", Get.arguments["vehiculo_peso_bruto"] + " T"),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Capacidad de carga:", Get.arguments["vehiculo_carga_util"] + " Kg"),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                ),
          
                const SizedBox(height: 20),
                Style.textTitulo(mensaje: "Componetes y Estructura Mecánica", negitra: true, colorTexto: Theme.of(context).appBarTheme.backgroundColor),
                Style.estiloCard(
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Recolectorwidget().infoRowDetalleRecolector("Numero de asientos:", Get.arguments["vehiculo_numero_asiento"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Número de ejes:", Get.arguments["vehiculo_numero_eje"]),
          
                            Divider(),
                            Recolectorwidget().infoRowDetalleRecolector("Número de ruedas:", Get.arguments["vehiculo_numero_rueda"]),
          
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),

          // 📌 Widget que se mostrará al hacer scroll hacia arriba
          Obx(() => AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: urecoletor.mostrarDetalle.value ? -2 : -150, // Se oculta desplazándolo fuera de la vista
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: urecoletor.mostrarDetalle.value ? 1.0 : 0.0, // Controla la opacidad con animación
              child: _detalleFlotante(),
            ),
          )),


          // 📌 Widget Scroll To Top (Botón flotante con animación)
          Obx(() => AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: urecoletor.mostrarScroolTOPDetalle.value ? 20 : -100, // 📌 Se oculta moviéndolo fuera de la pantalla
            right: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: urecoletor.mostrarScroolTOPDetalle.value ? 1.0 : 0.0, // 📌 Opacidad con animación
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(0, // 📌 Mueve al inicio
                  duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                  urecoletor.mostrarScroolTOPDetalle.value = false;
                },
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          )),
        ]
      ),
    );
  }  
}