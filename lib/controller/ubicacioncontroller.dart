import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../config/library/import.dart';

class Ubicacioncontroller extends GetxController {
  final Tubicacion tubicacion = Get.find();
  final unavegacion = Get.find<Unavegacion>();
  final Urutas urutas = Get.find();  


  Future<void> obtenerCoordenasdetalleRutaChofer({required int idruta}) async {
    try{      
      final mapRuta = urutas.listarutas.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});  
      unavegacion.rutafinalXCamion.value = double.parse(mapRuta["ruta_punto_fin_x"]);
      unavegacion.rutafinalYCamion.value = double.parse(mapRuta["ruta_punto_fin_y"]);

      if (mapRuta.containsKey('detalleruta') && mapRuta['detalleruta'].isNotEmpty){

        List<dynamic> coords = mapRuta['detalleruta'];
        
        // Convertimos las coordenadas de String a double de forma segura
        tubicacion.coordenadasRuta.value = coords.map((coord) {
          double? lat = double.tryParse(coord['detalle_ruta_coordenada_y'] ?? '');
          double? lng = double.tryParse(coord['detalle_ruta_coordenada_x'] ?? '');

          // Asegurarse de que los valores no sean nulos antes de agregarlos a la lista
          if (lat != null && lng != null) {
            return [lat, lng];
          } else {
            throw Exception("Coordenada inválida en la ruta.");
          }
        }).toList();
      }
      
      // final mappeticion = await Rutamodel().directionsMapBoxAPI(
      //   startLng: double.parse(mapRuta["ruta_punto_inicio_y"]), 
      //   startLat: double.parse(mapRuta["ruta_punto_inicio_x"]), 
      //   endLng: double.parse(mapRuta["ruta_punto_fin_y"]),
      //   endLat: double.parse(mapRuta["ruta_punto_fin_x"])
      // );

      // // final mappeticion = await Rutamodel().directionsMapBoxAPI(startLng: -73.304640, startLat: -3.777662, endLng: -73.303170, endLat: -3.774332);
      // if (mappeticion.containsKey('routes') && mappeticion['routes'].isNotEmpty){

      //   List<dynamic> coords = mappeticion['routes'][0]['geometry']['coordinates'];
      //   tubicacion.coordenadasRuta.value = coords.map((coord) => [coord[0] as double, coord[1] as double]).toList();
      // }
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "obtenerCoordenasDireccionAPI $ex");
    }    
  }
  
  Future<void> obtenerCoordenasDireccionAPI1({required int idruta}) async {
    try{      
      final mapRuta = urutas.listarutas.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});  
      unavegacion.rutafinalXCamion.value = double.parse(mapRuta["ruta_punto_fin_x"]);
      unavegacion.rutafinalYCamion.value = double.parse(mapRuta["ruta_punto_fin_y"]);
      
      final mappeticion = await Rutamodel().directionsMapBoxAPI(
        startLng: double.parse(mapRuta["ruta_punto_inicio_y"]), 
        startLat: double.parse(mapRuta["ruta_punto_inicio_x"]), 
        endLng: double.parse(mapRuta["ruta_punto_fin_y"]),
        endLat: double.parse(mapRuta["ruta_punto_fin_x"])
      );

      // final mappeticion = await Rutamodel().directionsMapBoxAPI(startLng: -73.304640, startLat: -3.777662, endLng: -73.303170, endLat: -3.774332);
      if (mappeticion.containsKey('routes') && mappeticion['routes'].isNotEmpty){

        List<dynamic> coords = mappeticion['routes'][0]['geometry']['coordinates'];
        tubicacion.coordenadasRuta.value = coords.map((coord) => [coord[0] as double, coord[1] as double]).toList();
      }
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "obtenerCoordenasDireccionAPI $ex");
    }    
  }

  Future<void> agregarRutaAlMapa() async {
    if (tubicacion.mapboxMapp == null || tubicacion.coordenadasRuta.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Convertir las coordenadas al formato GeoJSON
      List<List<double>> coords = tubicacion.coordenadasRuta;
      var geoJson = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": coords
            },
            "properties": {}
          }
        ]
      };

      // Agregar la fuente de datos al mapa
      await tubicacion.mapboxMapp!.style.addSource(
        mapbox.GeoJsonSource(
          id: "routeSource",
          data: jsonEncode({
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "geometry": {
                  "type": "LineString",
                  "coordinates": tubicacion.coordenadasRuta
                },
                "properties": {}
              }
            ]
          }),
        ),
      );


      // Agregar la capa para mostrar la línea de la ruta
      await tubicacion.mapboxMapp!.style.addLayer(
        mapbox.LineLayer(
          id: "routeLayer",
          sourceId: "routeSource",
          lineColor: Colors.blue.value,  // Convertir color a int
          lineWidth: 5.0,  // Grosor de la línea
          lineOpacity: 0.8,  // Opacidad de la línea (0.0 - 1.0)
          lineJoin: mapbox.LineJoin.ROUND,  // Unión de líneas redondeadas
          lineCap: mapbox.LineCap.ROUND,  // Cap de línea redondeado
          lineGapWidth: 1.0,  // Espaciado en la línea
          lineTranslate: [0.0, 0.0],  // No se aplica traslación
        ),
      );


      print("Ruta agregada al mapa con éxito.");
    } catch (e) {
      print("Error al agregar la ruta al mapa: $e");
    }
  }

  Future<void> centrarMapaEnRuta() async {
    if (tubicacion.mapboxMapp == null || tubicacion.coordenadasRuta.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la lista de coordenadas
      List<List<double>> coords = tubicacion.coordenadasRuta;

      // Calcular el punto medio de la ruta
      double sumLat = 0.0, sumLng = 0.0;
      for (var coord in coords) {
        sumLng += coord[0];
        sumLat += coord[1];
      }

      double centerLng = sumLng / coords.length;
      double centerLat = sumLat / coords.length;

      // Establecer la cámara en el punto medio calculado
      await tubicacion.mapboxMapp!.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
          zoom: 13.0,  // Ajusta el nivel de zoom según sea necesario
          padding: mapbox.MbxEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
        ),
      );

      print("Cámara centrada en la ruta con éxito.");
    } catch (e) {
      print("Error al centrar el mapa en la ruta: $e");
    }
  }

  Future<void> agregarIconosInicioFin() async {
    if (tubicacion.mapboxMapp == null || tubicacion.coordenadasRuta.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la primera y última coordenada
      var inicio = tubicacion.coordenadasRuta.first;
      var fin = tubicacion.coordenadasRuta.last;

      var geoJson = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": inicio
            },
            "properties": {
              "title": "Inicio",
              "icon": "marker"  // Icono predeterminado de Mapbox
            }
          },
          {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": fin
            },
            "properties": {
              "title": "Fin",
              "icon": "marker"
            }
          }
        ]
      });

      // Agregar la fuente de datos con puntos de inicio y fin
      await tubicacion.mapboxMapp!.style.addSource(
        mapbox.GeoJsonSource(id: "pointsSource", data: geoJson),
      );

      // Agregar la capa de símbolos para mostrar los iconos predefinidos
      await tubicacion.mapboxMapp!.style.addLayer(
        mapbox.SymbolLayer(
          id: "pointsLayer",
          sourceId: "pointsSource",
          iconImage: "marker",  // Usando el ícono de marcador predeterminado de Mapbox
          iconSize: 3,  // Tamaño del icono
          textField: "{title}",  // Accede a la propiedad 'title' del GeoJSON
          textSize: 14.0,  // Tamaño del texto
          textOffset: [0, 1.5],  // Posición del texto encima del icono
        ),
      );


      print("Iconos de inicio y fin agregados correctamente.");
    } catch (e) {
      print("Error al agregar los iconos de inicio/fin: $e");
    }
  }

  void cambiarEstilo(String uri) {
    tubicacion.mapaEstilo.value = uri;
  }  

  Future<Position> determinarPosicion1()async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Permiso denegado');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error('Los permisos de ubicación se deniegan permanentemente, no podemos solicitar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> determinarPosicion() async {
    int error = 0;
    try {
      // Verificar si el servicio de ubicación está habilitado
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        error = 1;
        throw 'Los servicios de ubicación están desactivados. Habilítelos para continuar.';
      }    

      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          error = 2;
          throw 'Permiso de ubicación denegado.';
        }
      }         

      if (permission == LocationPermission.deniedForever) {
        error = 3;
        throw 'Los permisos de ubicación se denegaron permanentemente. Habilítelos manualmente desde la configuración.';
      }

      // Obtener la posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Mayor precisión posible
      );

      return position;
    } catch (e) {
      Navigator.pop(Get.context!);
      Global().modalErrorShowDialog(context: Get.context!, mensaje: e.toString(), actions: [
        if (error == 1) TextButton(
          child: Style.textTitulo(mensaje: "Activar servicios"),
          onPressed: () async {
            await Geolocator.openLocationSettings();
            Navigator.pop(Get.context!);
            // determinarPosicion();  // Reintentar obtener la ubicación
          },
        ),

        if (error == 2) TextButton(
          child: Style.textTitulo(mensaje: "Activar permisos"),
          onPressed: () async {
            await Geolocator.openAppSettings();
            Navigator.pop(Get.context!);
            // determinarPosicion();  // Reintentar obtener la ubicación
          },
        ),

        TextButton(
          child: Style.textTitulo(mensaje: "Cerrar"),
          onPressed: () async => Navigator.pop(Get.context!),
        )
      ]);      

      return null; // Retornar null si ocurre algún error
    }
  }
  
  Future<bool> obtenerUbicacionActual() async {
    Position? position = await determinarPosicion(); // Cambiar a tipo 'Position?'

    if (position != null) {
      tubicacion.latidude.value = position.latitude;
      tubicacion.longitude.value = position.longitude;
      return true;
    } else { 
      return false;
    }
    // tubicacion.cargarLocalizar.value = true;
    // Position position = await determinarPosicion();

    // tubicacion.latidude.value = position.latitude;
    // tubicacion.longitude.value = position.longitude;
    // tubicacion.cargarLocalizar.value = false;
  }

  crearMapBox(mapbox.MapboxMap mapboxMap) => tubicacion.mapboxMapp = mapboxMap;
  Future<void> mostrarLocalizacionEnMapa() async => await tubicacion.mapboxMapp?.location.updateSettings(mapbox.LocationComponentSettings(enabled: true));
  Future<void> mostrarFelchaGuia() async => await tubicacion.mapboxMapp?.location.updateSettings(mapbox.LocationComponentSettings(puckBearingEnabled: true));
  Future<void> ocultarFelchaGuia() async => await tubicacion.mapboxMapp?.location.updateSettings(mapbox.LocationComponentSettings(puckBearingEnabled: false));
  Future<void> mostrarPulsaciones() async => await tubicacion.mapboxMapp?.location.updateSettings(mapbox.LocationComponentSettings(pulsingEnabled: true));
  Future<void> ocultarPulsaciones() async => await tubicacion.mapboxMapp?.location.updateSettings(mapbox.LocationComponentSettings(pulsingEnabled: false));
}