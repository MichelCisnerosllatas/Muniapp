import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../../config/library/import.dart';
import '../../controller/navegcioncontroller.dart';

class Ubicacionwidget {
  final tubicacion = Get.find<Tubicacion>();
  final unavegacion = Get.find<Unavegacion>();
  
  Widget seleccionarEstiloComoPopupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.layers), // Cambia el ícono según tus necesidades
      onSelected: (String nuevoEstilo) async{
        Ubicacioncontroller().cambiarEstilo(nuevoEstilo);
        tubicacion.mapboxMapp?.style.setStyleURI(nuevoEstilo);
        await Ubicacioncontroller().obtenerCoordenasdetalleRutaChofer(idruta:int.parse( Get.find<Urutas>().idRutaSeleccionadaValue.value));
        await Ubicacioncontroller().agregarRutaAlMapa();
        await Ubicacioncontroller().agregarIconosInicioFin();
        await Ubicacioncontroller().centrarMapaEnRuta();
      },
      itemBuilder: (BuildContext context) {
        return Tubicacion.estilosMapa.map((estilo) {
          return PopupMenuItem<String>(
            value: estilo["uri"],
            child: Text(estilo["nombre"]!),
          );
        }).toList();
      },
    );
  }

  Widget showlocation(){
    return TextButton(
      child: Text('show location'),
      onPressed: () async => await Ubicacioncontroller().mostrarLocalizacionEnMapa()
    );
  }

  Widget showBearing() {
    return TextButton(
      child: Text('show location bearing'),
      onPressed: () async => await Ubicacioncontroller().mostrarFelchaGuia(),
    );
  }

  Widget hideBearing() {
    return TextButton(
      child: Text('hide location bearing'),
      onPressed: () async => await Ubicacioncontroller().ocultarFelchaGuia(),
    );
  }

  Widget showPulsing() {
    return TextButton(
      child: Text('show pulsing'),
      onPressed: () async => await Ubicacioncontroller().mostrarPulsaciones()
    );
  }

  Widget hidePulsing() {
    return TextButton(
      child: Text('hide pulsing'),
      onPressed: () async => await Ubicacioncontroller().ocultarPulsaciones()
    );
  }

  Widget mostrarMapa({required double latitude, required double longitude}) {
    return Obx((){
      mapbox.MapWidget mapWidget = mapbox.MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: tubicacion.mapaEstilo.value,
        cameraOptions: mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(longitude, latitude)),
          zoom: 15.0,
        ),
        onMapCreated: (mapboxMap) {
          Ubicacioncontroller().crearMapBox(mapboxMap);

          // Inicializa automáticamente las configuraciones al crear el mapa
          Ubicacioncontroller().mostrarLocalizacionEnMapa();
          Ubicacioncontroller().mostrarPulsaciones();
          Ubicacioncontroller().mostrarFelchaGuia();
          
        },
      );

      if(longitude == 0 && latitude == 0){
        return SizedBox.shrink();
      }else{
        return mapWidget;
      }  
    });    
  }

  Widget mostrarMapa2() {
    return Obx((){
      mapbox.MapWidget mapWidget = mapbox.MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: tubicacion.mapaEstilo.value,
        // cameraOptions: mapbox.CameraOptions(
        //   center: mapbox.Point(coordinates: mapbox.Position(-73.3062039, -3.7788892)),
        //   zoom: 15.0,
        // ),
        onMapCreated: (mapboxMap) async {
          Ubicacioncontroller().crearMapBox(mapboxMap);
          // await Ubicacioncontroller().cargarMapa();

          // Inicializa automáticamente las configuraciones al crear el mapa
          // await Ubicacioncontroller().mostrarLocalizacionEnMapa();
          // await Ubicacioncontroller().mostrarPulsaciones();
          // await Ubicacioncontroller().mostrarFelchaGuia();

          // await Ubicacioncontroller().obtenerCoordenasDireccionAPI();
          await Ubicacioncontroller().agregarRutaAlMapa();
          await Ubicacioncontroller().agregarIconosInicioFin();
          await Ubicacioncontroller().centrarMapaEnRuta();
          
        },
      );

      return mapWidget;

      // if(longitude == 0 && latitude == 0){
      //   return SizedBox.shrink();
      // }else{
      //   return mapWidget;
      // }  
    });    
  }

  Widget mostrarMapaNavegacion() {
    return mapbox.MapWidget(
      key: ValueKey("mapWidgetNavegacion"),
      styleUri: tubicacion.mapaEstilo.value,  // Mantén el estilo del mapa      
      onMapCreated: (mapboxMap) async {
        final navegacionController = Get.find<Navegcioncontroller>();

        // Guardar la instancia del mapa en el controlador
        navegacionController.crearMapBox(mapboxMap);

        // Configurar la navegación después de que el mapa ha sido creado
        await navegacionController.mostrarUbicacionNavegacion();
        await navegacionController.configurarVistaNavegacion();  // Configura la vista en 3D

        // Obtener ruta y agregar iconos
        await navegacionController.trazarRutaNavegacion();
        await navegacionController.agregarIconosInicioFinNavegacion();

        // Iniciar seguimiento de ubicación en tiempo real
        navegacionController.iniciarSeguimientoNavegacion();
      },
    );
  }
}