import 'package:flutter/rendering.dart';
import '../../../config/library/import.dart';

class Detallepersonapage extends StatefulWidget {
  const Detallepersonapage({super.key});

  @override
  State<Detallepersonapage> createState() => _DetallepersonapageState();
}

class _DetallepersonapageState extends State<Detallepersonapage> {
  final ScrollController _scrollController = ScrollController();
  final UPersonal upersonal = Get.find<UPersonal>();

  @override
  void initState() {
    super.initState();
    upersonal.mostrarDetalle.value = false;
    upersonal.mostrarScroolTOPDetalle.value = false;
    upersonal.offsetScrollDetalle.value = 0;
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double offset = _scrollController.offset;
    if(offset <= 210 && upersonal.mostrarDetalle.value){
      upersonal.mostrarDetalle.value = false;
    }
    if(offset > 210 && !upersonal.mostrarDetalle.value){
      upersonal.mostrarDetalle.value = true;
    }

    //Para saber si se llego al ultimo y al primero
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      upersonal.mostrarScroolTOPDetalle.value = true; // Ocultar al hacer scroll hacia abajo
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      upersonal.mostrarScroolTOPDetalle.value = false; // Mostrar al hacer scroll hacia arriba
    }
    upersonal.offsetScrollDetalle.value = offset;   
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget detallePersonalFlotante(){
    return Style.estiloCard(
      colorBorde: Colors.transparent,
      elevation: 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Asegura alineación correcta
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(Webservice().dominio() + Get.arguments["personal_foto"].toString(),
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
                Style.textSubTitulo(mensaje: "Nombre Personal"),
                Style.textTitulo(mensaje: "${Get.arguments["personal_nombre"]} ${Get.arguments["personal_apellido_paterno"]} ${Get.arguments["personal_apellido_materno"]}", fontSize: 16,),
                // Recolectorwidget().infoRowDetalleRecolector("Nombre Vehículo:", Get.arguments["vehiculo_nombre"]),
                // Divider(),
                // Recolectorwidget().infoRowDetalleRecolector("Tipo de vehículo:", Get.arguments["tipo_vehiculo_nombre"]),
                // Divider(),
                // Recolectorwidget().infoRowDetalleRecolector("Marca del vehículo:", Get.arguments["vehiculo_marca"]),
                // Divider(),
                // Recolectorwidget().infoRowDetalleRecolector("Serie del vehículo:", Get.arguments["vehiculo_serie"]),
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
        title:  Style.textTitulo(mensaje: "Ficha del Personal")
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(Webservice().dominio() + Get.arguments["personal_foto"].toString(),
                      fit: BoxFit.cover, width: 200, height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: Icon(Icons.car_crash, size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),

                
                Style.textTitulo(mensaje: "${Get.arguments["personal_nombre"]} ${Get.arguments["personal_apellido_paterno"]} ${Get.arguments["personal_apellido_materno"]}", fontSize: 16,),
                const SizedBox(height: 10),

                Style.estiloCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Nombre: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_nombre"]),
                          ],
                        ),
                    
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Apellido Paterno: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_apellido_paterno"]),
                          ],
                        ),
                    
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Apellido Materno: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_apellido_materno"]),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Correo: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_email"]),
                          ],
                        ),

                        Divider(),
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "DNI: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_dni"]),
                          ],
                        ),

                        Divider(),
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Telefono: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_telefono"]),
                          ],
                        ),

                        Divider(),
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Fecha de nacimiento: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_nacimiento"]),
                          ],
                        ),
                        Row(
                          children: [
                            Style.textSubTitulo(mensaje: "Sexo: "),
                            Style.textTitulo(mensaje: Get.arguments["personal_sexo"] == "M" ? "Masculino" : "Femenino"),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),

          // 📌 Widget que se mostrará al hacer scroll hacia arriba
          Obx(() => AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: upersonal.mostrarDetalle.value ? -2 : -150, // Se oculta desplazándolo fuera de la vista
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: upersonal.mostrarDetalle.value ? 1.0 : 0.0, // Controla la opacidad con animación
              child: detallePersonalFlotante(),
            ),
          )),


          // 📌 Widget Scroll To Top (Botón flotante con animación)
          Obx(() => AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: upersonal.mostrarScroolTOPDetalle.value ? 20 : -100, // 📌 Se oculta moviéndolo fuera de la pantalla
            right: 16,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: upersonal.mostrarScroolTOPDetalle.value ? 1.0 : 0.0, // 📌 Opacidad con animación
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(0, // 📌 Mueve al inicio
                  duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                  upersonal.mostrarScroolTOPDetalle.value = false;
                },
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          )),
        ],
      ),
    );
  }
}