import 'package:muniapp/controller/navegcioncontroller.dart';

import '../../../config/library/import.dart';

class Navegacionpage extends StatefulWidget {
  const Navegacionpage({super.key});

  @override
  State<Navegacionpage> createState() => _NavegacionpageState();
}

class _NavegacionpageState extends State<Navegacionpage> {
  final argumentos = Get.arguments;
  final tubicacion = Get.find<Tubicacion>();
  final navegacionController = Get.find<Navegcioncontroller>();

  @override
  void dispose() {
    navegacionController.detenerSeguimientoNavegacion(para: argumentos);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final argumentos = Get.arguments;
        Global().modalShowModalBottomSheetPregunta(
          context: context, 
          isDismissible: true,
          titulo: "Finalizar Navegación", 
          mensaje: "¿Estas seguro de finalizar la navegación?", 
          onPressedOK: () async {
            Navigator.pop(context);  
            if (argumentos != null) {
              await navegacionController.detenerSeguimientoNavegacion(para: argumentos);
            } else {
              print("Los argumentos están nulos");
            }
            
            // Navigator.pop(context);
            Get.back();
          }, 
          botonNombreOK: "Aceptar"
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            // Mapa ocupando toda la pantalla
            Positioned.fill(
              child: Ubicacionwidget().mostrarMapaNavegacion()
            ),
      
            // Barra de información arriba
            Positioned(
              top: 40.0,
              left: 20.0,
              right: 20.0,
              child: Obx(() => Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latitud: ${tubicacion.latidude.value}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Longitud: ${tubicacion.longitude.value}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )),
              // child: Container(
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.black.withOpacity(0.6),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Style.textTitulo(mensaje: "Hola"),
              //   // child: Obx(() => Text(
              //   //   "Distancia: ${tubicacion.distancia.value} km  |  Tiempo: ${tubicacion.duracion.value} min",
              //   //   style: TextStyle(color: Colors.white, fontSize: 18),
              //   // )),
              // ),
            ),
      
            // Botón para finalizar navegación
            Positioned(
              bottom: 40.0,
              left: 20.0,
              right: 20.0,
              child: ElevatedButton(
                onPressed: () {                

                  Global().modalShowModalBottomSheetPregunta(
                    context: context, 
                    titulo: "Finalizar Navegación", 
                    mensaje: "¿Estas seguro de finalizar la navegación?", 
                    isDismissible: true,
                    onPressedOK: () async {
                      Navigator.pop(context);                      
                      if (argumentos != null) {
                        await navegacionController.detenerSeguimientoNavegacion(para: argumentos);                        
                      } else {
                        print("Los argumentos están nulos");
                      }
                      Get.back();
                    }, 
                    botonNombreOK: "Aceptar"
                  );
                },

                child: Text("Finalizar Navegación"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}