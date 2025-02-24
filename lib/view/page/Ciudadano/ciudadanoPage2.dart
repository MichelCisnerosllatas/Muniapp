import '../../../config/library/import.dart';

class Ciudadanopage2 extends StatefulWidget {
  const Ciudadanopage2({super.key});

  @override
  State<Ciudadanopage2> createState() => _Ciudadanopage2State();
}

class _Ciudadanopage2State extends State<Ciudadanopage2> {
  MapBoxCiudadanoPage2Controller mapBoxCiudadanoPage2Controller = Get.find();
  UciudadanoMapciudadanapage2 uciudadanoMapciudadano2page = Get.find();
  Map argumentos = Get.arguments;
  
  @override
  void initState() {
    super.initState();     
    verificarYIniciarSeguimiento();
  }

  @override
  void dispose() {
    print("🛑 Cerrando la pantalla y limpiando recursos.");

    // 🔹 Evitar llamar métodos si el controlador ya fue eliminado
    if (Get.isRegistered<MapBoxCiudadanoPage2Controller>()) {
      mapBoxCiudadanoPage2Controller.detenerSeguimientovehiculotiemporeal();
    }

    // 🔹 Verificar que el mapa y anotaciones aún existan antes de limpiar
    // if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 != null && uciudadanoMapciudadano2page.pointAnnotationManager != null) {
    //   try {
    //     print("🛑 Eliminando todas las anotaciones del mapa...");
    //     uciudadanoMapciudadano2page.pointAnnotationManager!.deleteAll();
    //   } catch (e) {
    //     print("⚠ No se pudo eliminar las anotaciones: $e");
    //   }
    //   uciudadanoMapciudadano2page.pointAnnotationManager = null;
    // }

    super.dispose();
  }

  void verificarYIniciarSeguimiento() async {
    if (argumentos.containsKey("ruta_activa") &&
        argumentos["ruta_activa"] is Map &&
        argumentos["ruta_activa"]["activa"] == true) {
      
      // 🔹 Obtener la ubicación del camión ANTES de iniciar el stream
      var coordenadas = await Ciudadanomodel().listarCoordenadTiempoRealCamion(
        parametros: { "idinicioruta": argumentos["ruta_activa"]["id_inicio_ruta"].toString() }
      );

      if (coordenadas != null && coordenadas.isNotEmpty) {
        uciudadanoMapciudadano2page.coordenadaCamionActual.value = coordenadas;
        print("✅ Coordenada inicial del camión: $coordenadas");

        // 🔹 Asegurar que el mapa ya está renderizado antes de mostrar el icono
        Future.delayed(Duration(seconds: 1), () async {
          await mapBoxCiudadanoPage2Controller.mostrarIconoVehiculo(uciudadanoMapciudadano2page.coordenadaCamionActual);
        });
      }

      // 🔹 Iniciar el seguimiento en un pequeño delay para evitar conflictos con la carga inicial
      Future.delayed(Duration(seconds: 2), () {
        mapBoxCiudadanoPage2Controller.iniciarSeguimientoVehiculo(idinicioruta: int.parse(argumentos["ruta_activa"]["id_inicio_ruta"].toString()));
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leading: IconButton(
          onPressed: () async {
            mapBoxCiudadanoPage2Controller.detenerSeguimientovehiculotiemporeal();
            Get.delete<MapBoxCiudadanoPage2Controller>();  // Eliminar el controlador
            Get.delete<UciudadanoMapciudadanapage2>();
            Get.back();          
          }, 
          icon: Icon(Icons.arrow_back),
        ),
        title: Style.textTitulo(mensaje: argumentos["ruta_nombre"], fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)
      ),
      body: Column(
        children: [
          if(argumentos.containsKey("ruta_activa") && argumentos["ruta_activa"] != null && argumentos["ruta_activa"].containsKey("activa") && argumentos["ruta_activa"]["activa"] == false) Style.estiloCard(
            colorBorde: Colors.redAccent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2), // Rojo suave con opacidad
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                border: Border.all(color: Colors.redAccent, width: 1), // Borde rojo más fuerte
              ),
              child: Column(
                children: [
                  Style.textTitulo(mensaje: "Ruta no disponible", colorTexto: Theme.of(context).colorScheme.error),
                  Style.textSubTitulo(mensaje: Get.arguments["ruta_descripcion"])
                ],
              ),
            )
          ),
          Expanded(
            child: Ciudadanowidget().mostrarMapaCiudadanoInicioPagina2(
              idinicioruta: (argumentos.containsKey("ruta_activa") && 
                argumentos["ruta_activa"] is Map && argumentos["ruta_activa"]?["id_inicio_ruta"] != null && 
                argumentos["ruta_activa"]["id_inicio_ruta"].toString().isNotEmpty)
                ? int.tryParse(argumentos["ruta_activa"]["id_inicio_ruta"].toString()) ?? 0 : 0,
              idruta: argumentos["id_ruta"]
            ),
          ),
        ],
      ),
    );
  }
}

class Ciudadanopage2Bindings implements Bindings{
  
  @override
  void dependencies() {    
    Get.lazyPut(() => Uciudadano(), fenix: true);
    Get.lazyPut(() => UciudadanoMapciudadanapage2(), fenix: true);
    Get.lazyPut(() => MapBoxCiudadanoPage2Controller(), fenix: true);
  }
}