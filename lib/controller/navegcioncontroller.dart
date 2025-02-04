import '../config/library/import.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'dart:math';

class Navegcioncontroller extends GetxController{
  StreamSubscription<Position>? positionStream;
  final unavegacion = Get.find<Unavegacion>();
  final tubicacion = Get.find<Tubicacion>();
  final Urutas urutas = Get.find<Urutas>();
  final Uchofer uchofer = Get.find<Uchofer>();

  Future<void> abrirGoogleMapsConCoordenadas({double? latInicio, double? lonInicio, double? latDestino, double? lonDestino}) async {
    bool googleMapsInstalado = await verificarGoogleMapsInstalado();

    String googleMapsUrl;
    
    if (googleMapsInstalado) {
      // Si Google Maps está instalado, usa el esquema de la app (funciona en iOS y Android)
      iniciarSeguimientoNavegacion();
      googleMapsUrl = "comgooglemaps://?saddr=$latInicio,$lonInicio&daddr=$latDestino,$lonDestino&directionsmode=driving";
    } else {
      // Si Google Maps NO está instalado, usa el enlace web
      googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$latInicio,$lonInicio&destination=$latDestino,$lonDestino&travelmode=driving";
    }

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      print("⚠️ No se pudo abrir Google Maps.");
    }
  }

  Future<bool> verificarGoogleMapsInstalado() async {
    const String googleMapsScheme = "comgooglemaps://";
    bool instalado = await canLaunch(googleMapsScheme);
    
    if (instalado) {
      print("✅ Google Maps está instalado.");
    } else {
      print("❌ Google Maps NO está instalado.");
    }

    return instalado;
  }

  Future<void> showModalBottomSheetPreguntarAplicacion({VoidCallback? btnGoogleMaps, VoidCallback? btnMuniappMaps}){
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: Get.context!,
      isDismissible: true,
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea el contenido al centro
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Style.textTitulo(mensaje: "¿Donde quieres realizar la navegación?", colorTexto: Theme.of(context).colorScheme.onBackground),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Image.asset('assets/img/googleMapsImage.png', width: 30, height: 30, fit: BoxFit.cover ),
                      onPressed: btnGoogleMaps, 
                      label: Style.textTitulo(mensaje: "Google Maps"),
                    )
                  ),
                  const SizedBox(width: 16),                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: btnMuniappMaps, 
                      icon: Image.asset('assets/img/logo.png', width: 30, height: 30, fit: BoxFit.cover ),
                      label: Style.textTitulo(mensaje: "Muni Maps"),
                    )
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> mostrarUbicacionNavegacion() async {
    if (unavegacion.mapboxMappNavegacion == null) return;

    await unavegacion.mapboxMappNavegacion!.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,  // Habilita la visualización
        pulsingEnabled: true,  // Efecto de pulso
        pulsingColor: 0xFF0000FF,  // Color azul
        pulsingMaxRadius: 20.0,  // Reducir tamaño del pulso
        showAccuracyRing: true,  // Mostrar anillo de precisión
        accuracyRingColor: 0x5500FF00,  // Verde con transparencia
        accuracyRingBorderColor: 0xFF00FF00,  // Borde verde sólido
        puckBearingEnabled: true,  // Habilitar la dirección del icono
        puckBearing: mapbox.PuckBearing.COURSE,  // Sigue el movimiento del usuario
        // puckBearing: mapbox.PuckBearing.HEADING,  // Seguir la brújula del dispositivo
      ),
    );
  }

  Future<void> trazarRutaNavegacion() async {
    try {
      final mappeticion = await Rutamodel().directionsMapBoxAPI(
        startLng: tubicacion.longitude.value,
        startLat: tubicacion.latidude.value,
        endLng: unavegacion.rutafinalYCamion.value,
        endLat: unavegacion.rutafinalXCamion.value
      );

      if (mappeticion.containsKey('routes') && mappeticion['routes'].isNotEmpty) {
        List<dynamic> coords = mappeticion['routes'][0]['geometry']['coordinates'];
        tubicacion.coordenadasRuta.value = coords.map((coord) => [coord[0] as double, coord[1] as double]).toList();

        var geoJson = jsonEncode({
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
        });

        await unavegacion.mapboxMappNavegacion!.style.addSource(
          mapbox.GeoJsonSource(id: "routeSource", data: geoJson),
        );

        await unavegacion.mapboxMappNavegacion!.style.addLayer(
          mapbox.LineLayer(
            id: "routeLayer",
            sourceId: "routeSource",
            lineColor: Colors.blue.value,
            lineWidth: 6.0,
          ),
        );

        print("Ruta dibujada correctamente.");
      }
    } catch (e) {
      print("Error al obtener la ruta: $e");
    }
  }

  Future<void> configurarVistaNavegacion() async {
    if (unavegacion.mapboxMappNavegacion == null) return;

    await unavegacion.mapboxMappNavegacion!.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(
            tubicacion.longitude.value, 
            tubicacion.latidude.value
          )
        ),
        zoom: 16.0,  // Ajusta el nivel de zoom
        bearing: 180.0,  // Dirección de la cámara (0°=norte)
        pitch: 45.0,  // Inclinación de la cámara para vista 3D
      ),
    );

    print("Cámara configurada en vista de navegación.");
  }

  Future<void> agregarIconosInicioFinNavegacion() async {
    if (unavegacion.mapboxMappNavegacion == null || tubicacion.coordenadasRuta.isEmpty) {
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
      await unavegacion.mapboxMappNavegacion!.style.addSource(
        mapbox.GeoJsonSource(id: "pointsSource", data: geoJson),
      );

      // Agregar la capa de símbolos para mostrar los iconos predefinidos
      await unavegacion.mapboxMappNavegacion!.style.addLayer(
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

  double calcularDistanciaRestante(double lat1, double lon1) {
    // Coordenadas del destino final
    double lat2 = tubicacion.coordenadasRuta.last[1];  // latitud destino
    double lon2 = tubicacion.coordenadasRuta.last[0];  // longitud destino

    const R = 6371; // Radio de la Tierra en kilómetros
    double dLat = _gradosARadianes(lat2 - lat1);
    double dLon = _gradosARadianes(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) + cos(_gradosARadianes(lat1)) * cos(_gradosARadianes(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distancia = R * c;  // Resultado en kilómetros

    // tubicacion.distancia.value = distancia.toStringAsFixed(2);

    return distancia;
  }

  double _gradosARadianes(double grados) {
    return grados * pi / 180;
  }

  Future<void> detenerSeguimientoNavegacion({required Map<String, dynamic> para}) async {     
    if(urutas.idinicioruta.value == 0){
      return;
    }
    
    try{ 
      Global().modalCircularProgress(context: Get.context!, mensaje: RxString("Finalizando ruta..."));

      // Cancelar la suscripción a la ubicación
      await positionStream?.cancel();
      positionStream = null;  // Elimina la referencia para liberar memoria

      // Desactivar la ubicación en el mapa
      await unavegacion.mapboxMappNavegacion?.location.updateSettings(
        mapbox.LocationComponentSettings(
          enabled: false,  // Desactivar la visualización de ubicación
        ),
      );

      // Verificar si la ubicación sigue activa
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        print("El servicio de ubicación sigue habilitado.");
      } else {
        print("Seguimiento de ubicación detenido.");
      }
      
      final m =await Rutamodel().guardaInicioRuta(datosJson: para);
      await Notifacionmodel().enviaarNotificacionChofer(idruta: int.parse(para["idruta"].toString()), tiponotificacion: "finalizacion");

      urutas.idinicioruta.value = 0;
      uchofer.saberNaveMapEligida.value = 0;
      Navigator.pop(Get.context!);
      Global().mensajeShowToast(mensaje: m["message"], colorFondo: Colors.blueAccent);
    }
    catch(e){
      return;
    }    
  }

  void iniciarSeguimientoNavegacion() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        // LocationAccuracy.bestForNavigation ////Para apps de navegación en tiempo real, sigue la orientación del usuario, pero consume más batería que todas las opciones.
        // LocationAccuracy.best ////Similar a high, pero con más intentos de precisión. Consume más batería.
        // LocationAccuracy.medium // Para obtener ubicaciones razonablemente precisas sin consumir demasiada batería.
        // LocationAccuracy.low ////Cuando solo necesitas una ubicación aproximada, como en apps de clima.
        accuracy: LocationAccuracy.high, //Utiliza GPS en exteriores, Proporciona ubicaciones más precisas (alrededor de 5 a 10 metros de margen de error).
        distanceFilter: 1, //Obtiene nuevas coordenadas cada vez que el usuario se mueve al menos 1 metro
      ),
    ).listen((Position position) async {
      tubicacion.latidude.value = position.latitude;
      tubicacion.longitude.value = position.longitude;

      print("Ubicación obtenida: ${position.latitude}, ${position.longitude}");
      final m = await Rutamodel().guardarRutaCamionApi(datosJson: {
        "idinicioruta" : urutas.idinicioruta.value.toString(),
        "coordenadax" : tubicacion.longitude.value.toString(),
        "coordenaday" : tubicacion.latidude.value.toString(),
      });

      double bearing = position.heading;  // Obtener el rumbo del usuario en grados
      Global().mensajeShowToast(mensaje: "${m["message"]} latidude: ${tubicacion.latidude.value}, longitude: ${tubicacion.longitude.value}" );

      // Ajustar la cámara a la nueva ubicación
      unavegacion.mapboxMappNavegacion?.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(position.longitude, position.latitude)),
          zoom: 16.0,
          bearing: bearing,  // Dirección del usuario
          pitch: 50.0,  // Vista 3D más inclinada
        ),
      );
    });



    // Timer.periodic(Duration(seconds: 2), (timer) async {
    //   final settings = await unavegacion.mapboxMappNavegacion?.location.getSettings();
      
    //   if (settings != null) {
    //     final locationPuck = settings.locationPuck?.locationPuck2D;

    //     if (locationPuck != null) {
    //       print("Ubicación actualizada: Latitud=${tubicacion.latidude.value}, Longitud=${tubicacion.longitude.value}");

    //       // Actualiza la cámara a la nueva ubicación
    //       unavegacion.mapboxMappNavegacion?.setCamera(
    //         mapbox.CameraOptions(
    //           center: mapbox.Point(coordinates: mapbox.Position(tubicacion.longitude.value, tubicacion.latidude.value)),
    //           zoom: 16.0,
    //           bearing: 0.0,  // Ajustar la dirección en la que se mueve el usuario
    //           pitch: 45.0,  // Mantener la inclinación para vista 3D
    //         ),
    //       );
    //     }
    //   }
    // });
  }

  crearMapBox(mapbox.MapboxMap mapboxMap) => unavegacion.mapboxMappNavegacion = mapboxMap;
}