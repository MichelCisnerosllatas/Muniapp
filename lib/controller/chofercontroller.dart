import 'dart:math';
import 'dart:ui' as ui;  // Necesario para trabajar con imágenes en Flutter
import '../config/library/import.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class Chofercontroller extends GetxController{
  final Urutas urutas = Get.find();
  final Uchofer uchofer = Get.find();
  final UServidor uservidor = Get.find();
  final UUsuario uusuario = Get.find();
  final tubicacion = Get.find<Tubicacion>();

  void initStateChofer(){
    listarrutas();
  }

  Future<void> listarHistorialRutasChofers() async {
    try{
      await Future.delayed(Duration.zero);
      uservidor.cargaprogreso.value = true;
      uchofer.listaHistorialRutasChofer.value = await Rutamodel().mostrarHistorialRutasChofer();
      uchofer.pantallaCargadaHistorialRutasChofer.value = true;
      uservidor.cargaprogreso.value = false;
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: ex.toString());
    }
  }

  Future<void> iniciarRuta({required int idruta}) async {
    try{
      dynamic mapruta = await Rutamodel().guardaInicioRuta(datosJson: {
        "idruta" : idruta.toString(),
        "iduser" : uusuario.usuariologin["id_users"]
      });

      if(mapruta["success"]){
        urutas.idinicioruta.value = mapruta["id_inicio_ruta"];
      }    

      mapruta = await Rutamodel().guardarRutaCamionApi(datosJson: {
        "idinicioruta" : urutas.idinicioruta.value.toString(),
        "coordenadax" : tubicacion.longitude.value.toString(),
        "coordenaday" : tubicacion.latidude.value.toString(),
      });

      if(!mapruta["success"]){
        Global().mensajeShowToast(mensaje: mapruta["message"]);
      }
    }catch(ex){
      uservidor.servidorExpecion(ex);
    }
  }

  Future<void> listarrutas() async{
    try{
      uservidor.cargaprogreso.value = true;
      urutas.listarutas.value = await Rutamodel().mostrarRutasChofer();
      urutas.listarutasDropdowsbutton.value = urutas.listarutas.isEmpty ? [] : urutas.listarutas.map((e) {
        return {
          "id_ruta": e["id_ruta"].toString(),
          "ruta_nombre": e["ruta_nombre"].toString()
        };
      }).toList();
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "Chofercontroller, listarrutas");
    }
    uservidor.cargaprogreso.value = false;
  }

  void limpiarChofer(){    
    urutas.idinicioruta.value = 0;
  }

  //configuarcion del Mapa para el Detalle Historia de sus Rutas.
  Future<void> obtenerdetallerutaChoferHistorial({required Map<String, dynamic> parametros}) async {
    try{
      await Future.delayed(Duration.zero);
      uservidor.cargaprogreso.value = true;
      List<dynamic> coords = parametros['detalles_ruta'];
      List<dynamic> coords1 = parametros['coordenadas']; 
        
      // Convertimos las coordenadas de String a double de forma segura
      uchofer.coordenadasDetalleRutaHistorialChofer1.value = coords.map((coord) {
        double? lat = double.tryParse(coord['detalle_ruta_coordenada_y'] ?? '');
        double? lng = double.tryParse(coord['detalle_ruta_coordenada_x'] ?? '');

        // Asegurarse de que los valores no sean nulos antes de agregarlos a la lista
        if (lat != null && lng != null) {
          return [lat, lng];
        } else {
          throw Exception("Coordenada inválida en la ruta.");
        }
      }).toList();

      uchofer.coordenadasRecorrdiasDetalleHistorialChofer.value = coords1.map((coord) {
        double? lat = double.tryParse(coord['ruta_camion_coordenada_y'] ?? '');
        double? lng = double.tryParse(coord['ruta_camion_coordenada_x'] ?? '');

        // Asegurarse de que los valores no sean nulos antes de agregarlos a la lista
        if (lat != null && lng != null) {
          return [lat, lng];
        } else {
          throw Exception("Coordenada inválida en la ruta2.");
        }
      }).toList();
    }catch(ex){
      uservidor.cargaprogreso.value = false;
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "detalleRutaCamionCiudadano $ex"); 
      return;     
    } finally{
      uservidor.cargaprogreso.value = false;
    }
  }

  Future<void> mostrarRutaDetalleHistorialChofer() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    if (uchofer.coordenadasDetalleRutaHistorialChofer1.isEmpty) {
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "No se cargó la ruta original. Por favor, vuelve a intentarlo.");
      return;
    }

    if (uchofer.coordenadasRecorrdiasDetalleHistorialChofer.isEmpty) {
      Global().modalErrorShowDialog(context: Get.context!,mensaje: "No se cargó la ruta recorrida. Por favor, vuelve a intentarlo.");
      return;
    }

    try {
      var style = uchofer.mapboxMappDetalleHistorialChofer!.style;

      // 🔹 Convertir las coordenadas al formato GeoJSON
      var rutaOriginal = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": uchofer.coordenadasDetalleRutaHistorialChofer1
            },
            "properties": {}
          }
        ]
      });

      var rutaRecorrido = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": uchofer.coordenadasRecorrdiasDetalleHistorialChofer
            },
            "properties": {}
          }
        ]
      });

      // 🔹 Agregar la fuente de la ruta ORIGINAL (Azul)
      await style.addSource(
        mapbox.GeoJsonSource(id: "routeSource", data: rutaOriginal),
      );

      // 🔹 Agregar la fuente de la ruta RECORRIDA (Rojo)
      await style.addSource(
        mapbox.GeoJsonSource(id: "routeSource2", data: rutaRecorrido),
      );

      // 🔹 Agregar la capa para mostrar la línea de la ruta ORIGINAL (Azul)
      await style.addLayer(
        mapbox.LineLayer(
          id: "routeLayer",
          sourceId: "routeSource",
          lineColor: Colors.blueAccent.value, // 🔵 Azul para la ruta original
          lineWidth: 6.0,
          lineOpacity: 0.9,
          lineJoin: mapbox.LineJoin.ROUND,
          lineCap: mapbox.LineCap.ROUND,
        ),
      );

      // 🔹 Agregar la capa para mostrar la línea de la ruta RECORRIDA (Rojo)
      await style.addLayer(
        mapbox.LineLayer(
          id: "routeLayer2",
          sourceId: "routeSource2",
          lineColor: const ui.Color.fromARGB(255, 166, 29, 1).value, // 🔴 Rojo para la ruta recorrida
          lineWidth: 6.0,
          lineOpacity: 0.9,
          lineJoin: mapbox.LineJoin.ROUND,
          lineCap: mapbox.LineCap.ROUND,
        ),
      );
    } catch (e) {
      print("Error al agregar las rutas al mapa: $e");
    }
  }

  Future<void> centrarMapaDetalleHistorialChofer() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
        print("Mapa no inicializado o no hay coordenadas disponibles.");
        return;
    }

    try {
        // 🔹 Unir todas las coordenadas de ambas rutas
        List<List<double>> todasLasCoordenadas = [
            ...uchofer.coordenadasDetalleRutaHistorialChofer1,
            ...uchofer.coordenadasRecorrdiasDetalleHistorialChofer
        ];

         // Asegurarse de incluir los puntos de inicio y fin en la vista
        todasLasCoordenadas.add(uchofer.coordenadasDetalleRutaHistorialChofer1.first);
        todasLasCoordenadas.add(uchofer.coordenadasDetalleRutaHistorialChofer1.last);

        if (todasLasCoordenadas.isEmpty) {
            print("No hay coordenadas suficientes para centrar el mapa.");
            return;
        }

        // 🔹 Calcular los límites (Bounding Box)
        double minLat = double.infinity;
        double maxLat = double.negativeInfinity;
        double minLng = double.infinity;
        double maxLng = double.negativeInfinity;

        for (var coord in todasLasCoordenadas) {
            double lng = coord[0];
            double lat = coord[1];

            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng;
            if (lng > maxLng) maxLng = lng;
        }

        // 🔹 Calcular el centro del Bounding Box
        double centerLat = (minLat + maxLat) / 2;
        double centerLng = (minLng + maxLng) / 2;

        // 🔹 Calcular la distancia máxima para ajustar el zoom
        double distancia = calcularDistancia(minLat, minLng, maxLat, maxLng);
        double zoom = calcularZoomSegunDistancia(distancia);

        // 🔹 Mover la cámara con el centro y zoom ajustado
        await uchofer.mapboxMappDetalleHistorialChofer!.setCamera(
          mapbox.CameraOptions(
            center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
            zoom: zoom,
            padding: mapbox.MbxEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
          ),
        );

        print("✅ Cámara centrada correctamente en ambas rutas.");
    } catch (e) {
      print("Error al centrar el mapa en la ruta: $e");
    }
  }

  // 🔹 Función para calcular la distancia entre dos puntos (Fórmula de Haversine)
  // 🔹 Función para calcular la distancia entre dos puntos (Fórmula de Haversine)
  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
      const double R = 6371; // Radio de la Tierra en km
      double dLat = (lat2 - lat1) * pi / 180;
      double dLon = (lon2 - lon1) * pi / 180;
      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
          sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      return R * c;
  }

  // 🔹 Función mejorada para calcular el zoom óptimo
  double calcularZoomSegunDistancia(double distancia) {
      if (distancia < 1) return 17.0; // 🔍 Zoom muy cercano para rutas cortas
      if (distancia < 3) return 15.0;
      if (distancia < 10) return 13.0;
      if (distancia < 25) return 11.0;
      if (distancia < 50) return 9.0;
      return 7.0; // 🔭 Zoom más lejano para rutas largas
  }

  Future<void> cargarImagenIconosInicioFin() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
        print("Mapa no inicializado.");
        return;
    }

    try {
      // Cargar imagen para el punto de INICIO
      ByteData bytesInicio = await rootBundle.load("assets/img/circleinicio.png");
      Uint8List listInicio = bytesInicio.buffer.asUint8List();

      ui.Codec codecInicio = await ui.instantiateImageCodec(listInicio);
      ui.FrameInfo frameInfoInicio = await codecInicio.getNextFrame();
      ui.Image imageInicio = frameInfoInicio.image;

      int widthInicio = imageInicio.width;
      int heightInicio = imageInicio.height;

      mapbox.MbxImage mbxImageInicio = mapbox.MbxImage(
        width: widthInicio,
        height: heightInicio,
        data: listInicio,
      );

      await uchofer.mapboxMappDetalleHistorialChofer!.style.addStyleImage(
        "start-icon", 1.0, mbxImageInicio, false, [], [], null,
      );

      // Cargar imagen para el punto de FIN
      ByteData bytesFin = await rootBundle.load("assets/img/circlefin.png");
      Uint8List listFin = bytesFin.buffer.asUint8List();

      ui.Codec codecFin = await ui.instantiateImageCodec(listFin);
      ui.FrameInfo frameInfoFin = await codecFin.getNextFrame();
      ui.Image imageFin = frameInfoFin.image;

      int widthFin = imageFin.width;
      int heightFin = imageFin.height;

      mapbox.MbxImage mbxImageFin = mapbox.MbxImage(
        width: widthFin,
        height: heightFin,
        data: listFin,
      );

      await uchofer.mapboxMappDetalleHistorialChofer!.style.addStyleImage(
        "end-icon", 1.0, mbxImageFin, false, [], [], null,
      );

      print("✅ Iconos personalizados cargados correctamente.");
    } catch (e) {
      print("Error al cargar iconos personalizados: $e");
    }
  }

  Future<void> puntoInicioFINDetalleHistoriaChofer() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la primera y última coordenada
      var inicio = uchofer.coordenadasDetalleRutaHistorialChofer1.first;
      var fin = uchofer.coordenadasDetalleRutaHistorialChofer1.last;

      var geoJsonInicio = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": inicio
            },
            "properties": {
              "title": "Punto de Inicio",
              "icon": "start-icon"
            }
          }
        ]
      });

      var geoJsonFin = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": fin
            },
            "properties": {
              "title": "Destino Final",
              "icon": "end-icon"
            }
          }
        ]
      });

      // Agregar la fuente de datos para Inicio
      await uchofer.mapboxMappDetalleHistorialChofer!.style.addSource(
        mapbox.GeoJsonSource(id: "startSource", data: geoJsonInicio),
      );

      // Agregar la fuente de datos para Fin
      await uchofer.mapboxMappDetalleHistorialChofer!.style.addSource(
        mapbox.GeoJsonSource(id: "endSource", data: geoJsonFin),
      );

      // Agregar la capa de símbolos para el punto de INICIO (AZUL)
      await uchofer.mapboxMappDetalleHistorialChofer!.style.addLayer(
        mapbox.SymbolLayer(
          id: "startLayer",
          sourceId: "startSource",
          iconImage: "start-icon",
          iconSize: 0.07,

          //Personalización del texto para Inicio
          textField: "Punto de Inicio",
          textSize: 14.0,
          textColor: Colors.blue.value, //Color Azul
          textOffset: [0, 1.5], //Mantener texto debajo del icono
          textAnchor: mapbox.TextAnchor.TOP,
          textFont: ["Open Sans Bold"],
        ),
      );

      // Agregar la capa de símbolos para el punto de FIN (ROJO)
      await uchofer.mapboxMappDetalleHistorialChofer!.style.addLayer(
        mapbox.SymbolLayer(
          id: "endLayer",
          sourceId: "endSource",
          iconImage: "end-icon",
          iconSize: 0.07,

          // Personalización del texto para Fin
          textField: "Destino Final",
          textSize: 14.0,
          textColor: Colors.red.value, // Color Rojo
          textOffset: [0, 1.0], // Mover texto más arriba
          textAnchor: mapbox.TextAnchor.TOP,
          textFont: ["Open Sans Bold"],
        ),
      );
    } catch (e) {
      print("Error al agregar los iconos de inicio/fin: $e");
    }
  }



  Future<void> agregarFlechasEnRuta() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      List<dynamic> coordenadas = uchofer.coordenadasDetalleRutaHistorialChofer1;

      if (coordenadas.length < 2) {
        print("No hay suficientes puntos para agregar flechas.");
        return;
      }

      List<Map<String, dynamic>> features = [];

      // 🔥 Ajustamos la lógica: Tomamos siempre la dirección del siguiente punto.
      for (int i = 0; i < coordenadas.length - 1; i += 1) {
        if(i -1  < 0 || i + 1 > coordenadas.length - 1) continue;
        var puntoAnterior = coordenadas[i - 1]; 
        var puntoActual = coordenadas[i];
        var puntoSiguiente = coordenadas[i + 1];

        // 🔥 🔥 FORZAR QUE LA PRIMERA FLECHA SIEMPRE SE AGREGUE 🔥 🔥
        if (i == 1) {
            print("📍 Asegurando flecha en el punto de inicio: $puntoActual");
        } else {
            // 🔥 Si el punto está en una curva, lo omitimos (NO agregamos la flecha)
            if (esCurva(puntoAnterior, puntoActual, puntoSiguiente)) {
                print("⏭️ Omitiendo flecha en curva en el punto: $puntoActual");
                continue; // 🔥 Omitimos esta flecha
            }
        }

        double angulo = calcularAngulo(puntoActual, puntoSiguiente);

        features.add({
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": puntoActual
          },
          "properties": {
            "rotation": angulo
          }
        });
      }

      var geoJson = jsonEncode({
        "type": "FeatureCollection",
        "features": features,
      });

      await uchofer.mapboxMappDetalleHistorialChofer!.style.addSource(
        mapbox.GeoJsonSource(id: "arrowsSource", data: geoJson),
      );

      await uchofer.mapboxMappDetalleHistorialChofer!.style.addLayer(
        mapbox.SymbolLayer(
          id: "arrowsLayer",
          sourceId: "arrowsSource",
          iconImage: "arrow-icon",
          iconSize: 0.03,
          iconAllowOverlap: true,
          iconRotationAlignment: mapbox.IconRotationAlignment.MAP,
          iconRotateExpression: ["get", "rotation"],
        ),
      );

      print("✅ Flechas alineadas correctamente con la ruta.");
    } catch (e) {
      print("Error al agregar flechas en la ruta: $e");
    }
  }

  bool esCurva(List<double> puntoAnterior, List<double> puntoActual, List<double> puntoSiguiente) {
    double angulo1 = atan2(puntoActual[1] - puntoAnterior[1], puntoActual[0] - puntoAnterior[0]) * (180 / pi);
    double angulo2 = atan2(puntoSiguiente[1] - puntoActual[1], puntoSiguiente[0] - puntoActual[0]) * (180 / pi);

    double diferencia = (angulo2 - angulo1).abs();

    return diferencia > 25; // 🔥 Si el cambio de dirección es mayor a 25°, consideramos que es curva
  }

  double calcularAngulo(List<double> puntoActual, List<double> puntoSiguiente) {
    double deltaY = puntoSiguiente[1] - puntoActual[1];
    double deltaX = puntoSiguiente[0] - puntoActual[0];

    double angulo = atan2(deltaY, deltaX) * (180 / pi);
    
    return angulo + 180; // 🔥 Ajustamos 90° para que la imagen mire hacia adelante
  }

  Future<void> cargarImagenFlecha() async {
    if (uchofer.mapboxMappDetalleHistorialChofer == null) {
      print("Mapa no inicializado.");
      return;
    }

    try {
      // Cargar la imagen desde los assets
      ByteData bytes = await rootBundle.load("assets/img/arrow.png");
      Uint8List list = bytes.buffer.asUint8List();

      // Decodificar la imagen para obtener su ancho y alto
      ui.Codec codec = await ui.instantiateImageCodec(list);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      ui.Image image = frameInfo.image;

      int width = image.width;
      int height = image.height;

      // Crear la imagen MbxImage con los valores correctos
      mapbox.MbxImage mbxImage = mapbox.MbxImage(
        width: width,
        height: height,
        data: list,
      );

      // Agregar la imagen al estilo del mapa
      await uchofer.mapboxMappDetalleHistorialChofer!.style.addStyleImage(
        "arrow-icon", // Identificador de la imagen
        1.0, // Escala de la imagen
        mbxImage,
        false, // No es SDF (monocromo)
        [], // Sin stretchX
        [], // Sin stretchY
        null, // Sin contenido específico
      );

      print("Imagen de flecha agregada correctamente.");
    } catch (e) {
      print("Error al agregar la imagen de flecha: $e");
    }
  }

  crearMapBoxDetalleHistorialChofer(mapbox.MapboxMap mapboxMap) => uchofer.mapboxMappDetalleHistorialChofer = mapboxMap;
}