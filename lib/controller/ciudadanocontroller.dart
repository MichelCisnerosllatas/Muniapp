import '../config/library/import.dart';
import 'dart:ui' as ui;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class Ciudadanocontroller extends GetxController {
  final UciudadanoMapRegistrociudadano2 uciudadanoMapRegistrociudadano2page = Get.find<UciudadanoMapRegistrociudadano2>();
  final MapBoxCiudadanoRegistroController mapBoxCiudadanoRegistroController = Get.find<MapBoxCiudadanoRegistroController>();
  final Uciudadano uciudadano = Get.find(); 

  final UServidor uservidor = Get.find<UServidor>();
  final UUsuario uusuario = Get.find();
  final Notificacioncontroller notificacioncontroller = Get.find();
  mapbox.PointAnnotationManager? annotationManager;

  Future<void> mostrarRutasInicioCiudadano() async {
    try{
      uservidor.cargaprogreso.value = true;
      uciudadano.listarutasCiudadanoInicio.value = await Ciudadanomodel().listarRutasInicioCiudadano(parametros: {"idusuario": uusuario.usuariologin["id_users"].toString()});
      uservidor.cargaprogreso.value = false;
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al mostrar las rutas. $ex");
      return;
    }
  }

  //Registro del Ciudadano
  void registrarCiudadanoyCoordenadasCasa() {
    uciudadano.boolpintartxtClave2.value = false;
    uciudadano.boolpintartxtClave.value = false;  

    if(uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.isEmpty){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "No se han agregado coordenadas de casa.");
      return;
    }

    if(uciudadano.txtClave.text.trim() != uciudadano.txtClave2.text.trim()){
      uciudadano.boolpintartxtClave2.value = true;
      uciudadano.boolpintartxtClave.value = true;
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Ambas Claves tiene que ser Iguales.");
      return;
    }

    Global().modalShowModalBottomSheetPregunta(
      context: Get.context!, 
      titulo: "¿Estás seguro?", 
      mensaje: "verifica tus coordenadas antes de registrar",
      onPressedOK: () async{
        Navigator.pop(Get.context!);
        uservidor.mensajeTituloServidor.value = "Registrando Ciudadano"; 
        Global().modalCircularProgress(context: Get.context!, mensaje: uservidor.mensajeTituloServidor);
        var m = await Ciudadanomodel().registrarCiudadano(datosJson: {
          "nombre" : uciudadano.txtNombre.text.trim(),
          "apellido" : uciudadano.txtApellidoPat.text.trim(),
          "apellido2" : uciudadano.txtApellidoMat.text.trim(),
          "correo" : uciudadano.txtcorreo.text.trim(),
          "celular" : uciudadano.txtCelular.text.trim(),
          "usuario" : uciudadano.txtusuario.text.trim(),
          "sexo" : uciudadano.txtSexo.value.trim(),
          "clave" : uciudadano.txtClave.text.trim(),
          "tokendispositivo" : notificacioncontroller.deviceToken.value,
          "foto" : uciudadano.fotoCiudadano.value,
        });

        if(m.containsKey("error")){
          Navigator.pop(Get.context!);
          Global().modalErrorShowDialog(context: Get.context!, mensaje: m["error"].toString());
          return;
        }
        
        // if(!m["success"] || !m.containsKey("data")){
        //   Navigator.pop(Get.context!);
        //   Global().modalErrorShowDialog(context: Get.context!, mensaje: "error al Registrar el Ciudadano.");
        //   return;
        // }

        int iduciuda = m["data"]["id_users"];
        uservidor.mensajeTituloServidor.value = "Registrando Coordenadas";
        
        // uciudadano.coordenadaCasaGuardadalista.clear();        
        final idrutasselecionadas = uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap
        .expand((entry) => entry.keys) // Obtiene las claves de los mapas
        .map((key) => key.toString()) // Convierte a String
        .toList();

        for(int i = 0; i < idrutasselecionadas.length; i++){
          List<List<double>> coordenadas = mapBoxCiudadanoRegistroController.obtenercoordenadaCasaGuardadaPorRuta(idrutasselecionadas[i]);
          for(int t = 0; t < coordenadas.length; t++){
            m = await Ciudadanomodel().registrarCoordenadasCiudadano(datosJson: {
              "idusuario" : iduciuda,
              "idruta" : idrutasselecionadas[i],
              "rutax" : coordenadas[t][0],
              "rutay" : coordenadas[t][1],
            });

            if(!m["success"]) {
              Navigator.pop(Get.context!);
              Global().modalErrorShowDialog(context: Get.context!, mensaje: "");            
              break;            
            }
          }
        }

        Navigator.pop(Get.context!);
        Global().mensajeShowToast(mensaje: "Registro Existoso", colorFondo: Style.colorceleste);
        await mapBoxCiudadanoRegistroController.limpiarAnotaciones();
        limpiarregistroCiudadano();
        await Usuariocontroller().validarLogin(username: uciudadano.txtusuario.text.trim(), password: uciudadano.txtClave.text.trim());
      }
    );  
    
  }

  void initStateRegistroCiudadano(){
    uciudadano.focotxtxtNombre = FocusNode();
    uciudadano.focotxtApellidoPat = FocusNode();
    uciudadano.focotxtApellidoMat = FocusNode();
    uciudadano.focotxtcorreo = FocusNode();
    uciudadano.focotxtusuario = FocusNode();
    uciudadano.focotxtClave = FocusNode();
    uciudadano.focotxtClave2 = FocusNode();
    uciudadano.focotxtCelular = FocusNode();
    uciudadano.focotxtSexo = FocusNode();
  }

  void limpiarregistroCiudadano(){
    uciudadano.txtNombre.clear();
    uciudadano.txtApellidoPat.clear();
    // uciudadano.txtClave.clear();
    uciudadano.txtcorreo.clear();
    uciudadano.cargarRegistroCiudadano.value = false;
  }
  
  onTap(mapbox.MapContentGestureContext context) {
    print("OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" + " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}");
  }
}


class MapBoxCiudadanoPage2Controller extends GetxController{
  final UciudadanoMapciudadanapage2 uciudadanoMapciudadano2page = Get.find<UciudadanoMapciudadanapage2>();
  mapbox.PointAnnotationManager? annotationManager;
  final UServidor uservidor = Get.find<UServidor>();
  final Uciudadano uciudadano = Get.find(); 
  StreamSubscription? streamSubscription;


  void iniciarSeguimientoVehiculo({int idinicioruta = 0}) {
    if (streamSubscription != null) {
      detenerSeguimientovehiculotiemporeal();
    }

    streamSubscription = Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      return await Ciudadanomodel().listarCoordenadTiempoRealCamion(parametros: {"idinicioruta": idinicioruta});
    }).listen((ubicacion) async {
      if (ubicacion != null && ubicacion.isNotEmpty) {
        // print("📍 Nueva ubicación recibida: ${ubicacion[1]}, ${ubicacion[0]}");

        // Guardamos la ubicación en la variable reactiva
        uciudadanoMapciudadano2page.coordenadaCamionActual.value = ubicacion;

        // Inicializar el marcador del vehículo solo si aún no existe
        if (uciudadanoMapciudadano2page.marcadorVehiculo == null) {
          await mostrarIconoVehiculo(ubicacion);
        } else {
          actualizarUbicacionVehiculo(ubicacion);
        }
      } else {
        print("⚠ Ubicación nula o vacía recibida.");
      }
    }, onError: (error) {
      print("❌ Error en el stream de ubicación: $error");
    });
  }

  void detenerSeguimientovehiculotiemporeal() {
    if (streamSubscription != null) {
      print("🛑 Deteniendo seguimiento en tiempo real.");
      streamSubscription?.cancel();
      streamSubscription = null;  // Evita que siga escuchando
    }
  }
  
  void inicializarPointAnnotationManager() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 != null) {
      uciudadanoMapciudadano2page.pointAnnotationManager = await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.annotations.createPointAnnotationManager();
    } else {
      print("⚠ Mapa no inicializado.");
    }
  }

  Future<void> cargarImagenVehiculo() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 != null) {
      try {
        // 🔹 Cargar imagen desde assets
        ByteData bytesVehiculo = await rootBundle.load("assets/img/camion.png");
        Uint8List listVehiculo = bytesVehiculo.buffer.asUint8List();

        ui.Codec codecVehiculo = await ui.instantiateImageCodec(listVehiculo);
        ui.FrameInfo frameInfoVehiculo = await codecVehiculo.getNextFrame();
        ui.Image imageVehiculo = frameInfoVehiculo.image;

        int widthVehiculo = imageVehiculo.width;
        int heightVehiculo = imageVehiculo.height;

        mapbox.MbxImage mbxImageVehiculo = mapbox.MbxImage(
          width: widthVehiculo,
          height: heightVehiculo,
          data: listVehiculo,
        );

        await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addStyleImage(
          "vehiculo-icon", 1.0, mbxImageVehiculo, false, [], [], null,
        );

        print("✅ Imagen del vehículo cargada correctamente en Mapbox.");        
      } catch (e) {
        print("❌ Error al cargar la imagen del vehículo: $e");
      }
    } else {
      print("⚠ No se pudo cargar la imagen porque el mapa es nulo.");
    }
  }

  Future<void> mostrarIconoVehiculo(List<double> posicionInicial) async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null) {
      print("⚠ Mapa no inicializado.");
      return;
    }

    // ✅ Asegurar que el PointAnnotationManager esté inicializado
    if (uciudadanoMapciudadano2page.pointAnnotationManager == null) {
      inicializarPointAnnotationManager();
    }

    try {
      print("🚚 Creando icono del vehículo en la posición inicial: $posicionInicial");

      // ✅ Si ya existe un marcador, no lo creamos de nuevo, solo actualizamos la posición
      if (uciudadanoMapciudadano2page.marcadorVehiculo != null) {
        await actualizarUbicacionVehiculo(posicionInicial);
        return;
      }

      // ✅ Crear el marcador inicial
      uciudadanoMapciudadano2page.marcadorVehiculo = await uciudadanoMapciudadano2page.pointAnnotationManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(
            coordinates: mapbox.Position(posicionInicial[0], posicionInicial[1]),
          ),
          iconImage: "vehiculo-icon",
          iconSize: 0.08,
        ),
      );

      print("🚚 Icono del vehículo agregado en el mapa.");
    } catch (e) {
      print("❌ Error al agregar el vehículo en el mapa: $e");
    }
  }

  Future<void> actualizarUbicacionVehiculo(List<double> ubicacion) async {
    if (uciudadanoMapciudadano2page.pointAnnotationManager == null) {
      print("⚠ PointAnnotationManager no inicializado, reinicializando...");
      inicializarPointAnnotationManager();
    }

    try {
      print("🔄 Moviendo vehículo a nueva ubicación: $ubicacion");

      // ✅ Si el marcador ya existe, actualizamos su posición directamente
      if (uciudadanoMapciudadano2page.marcadorVehiculo != null) {
        uciudadanoMapciudadano2page.marcadorVehiculo!.geometry = mapbox.Point(
          coordinates: mapbox.Position(ubicacion[0], ubicacion[1]),
        );

        await uciudadanoMapciudadano2page.pointAnnotationManager!.update(uciudadanoMapciudadano2page.marcadorVehiculo!);

        print("✅ Ubicación del vehículo actualizada sin crear duplicados.");
        return;
      }

      // ✅ Si no existe, crear uno nuevo
      uciudadanoMapciudadano2page.marcadorVehiculo = await uciudadanoMapciudadano2page.pointAnnotationManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(
            coordinates: mapbox.Position(ubicacion[0], ubicacion[1]),
          ),
          iconImage: "vehiculo-icon",
          iconSize: 0.08,
        ),
      );
    } catch (e) {
      print("❌ Error al actualizar la ubicación del vehículo: $e");
    }
  }












  Future<void> mostrarIconoVehiculo1(List<double> posicionInicial) async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null) {
      print("⚠ Mapa no inicializado.");
      return;
    }

    try {
      var geoJsonVehiculo = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "id": "vehiculoFeature",
            "geometry": {
              "type": "Point",
              "coordinates": posicionInicial // [longitud, latitud]
            },
            "properties": {
              "title": "Vehículo en ruta",
              "icon": "vehiculo-icon"
            }
          }
        ]
      });

      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addSource(
        mapbox.GeoJsonSource(id: "vehiculoSource", data: geoJsonVehiculo),
      );

      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addLayer(
        mapbox.SymbolLayer(
          id: "vehiculoLayer",
          sourceId: "vehiculoSource",
          iconImage: "vehiculo-icon",
          iconSize: 0.08,  // 🔹 Mantener el icono grande y visible
          iconAllowOverlap: true, // 🔥 Evita que el icono se oculte por otros
          iconIgnorePlacement: true, // 🔥 Evita reglas de colisión de iconos
          symbolZOrder: mapbox.SymbolZOrder.AUTO, // 🔥 Asegura que siempre se renderice el icono
          minZoom: 2, // 🔥 Se mantiene visible desde el nivel de zoom 2
          maxZoom: 22, // 🔥 Se mantiene visible hasta el máximo nivel de zoom
          textField: "Vehículo",
          textSize: 14.0,
          textColor: const Color.fromARGB(255, 29, 3, 174).value,
          textOffset: [0, 1.0],
          textAnchor: mapbox.TextAnchor.TOP,
        ),
      );

      print("🚗 Icono del vehículo agregado en el mapa.");
    } catch (e) {
      print("❌ Error al agregar el vehículo en el mapa: $e");
    }
  }

  Future<void> actualizarUbicacionVehiculo1(List<double> ubicacion) async {
    if (uciudadanoMapciudadano2page.pointAnnotationManager == null) {
      print("⚠ PointAnnotationManager no inicializado.");
      return;
    }

    try {
      print("🔄 Moviendo vehículo a nueva ubicación: $ubicacion");

      // 🔹 Si ya existe un marcador, actualizarlo
      // if (uciudadanoMapciudadano2page.marcadorVehiculo != null) {
      //   await uciudadanoMapciudadano2page.pointAnnotationManager!.update(
      //     uciudadanoMapciudadano2page.marcadorVehiculo!.(
      //       geometry: mapbox.Point(coordinates: mapbox.Position(ubicacion[0], ubicacion[1])),
      //     ),
      //   );
      //   print("✅ Ubicación del vehículo actualizada en el mapa.");
      //   return;
      // }

      // 🔹 Si no existe, crearlo
      print("🆕 Creando nuevo icono del vehículo...");
      uciudadanoMapciudadano2page.marcadorVehiculo = await uciudadanoMapciudadano2page.pointAnnotationManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(ubicacion[0], ubicacion[1])),
          iconImage: "vehiculo-icon",
          iconSize: 0.8,  // Ajusta el tamaño si es necesario
        ),
      );

      print("🚚 Vehículo agregado en el mapa correctamente.");
    } catch (e) {
      print("❌ Error al actualizar la ubicación del vehículo: $e");
    }
  }

















  Future<List<List<double>>> obtenerDetalleRutaMapBoxCiudadanoRegistro({required int idruta, int? pantallaOrigen = 2}) async {
    try{      
      Map<String, dynamic> mapRuta = uciudadano.listarutasCiudadanoInicio.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});

      if (mapRuta.containsKey('detalleruta') && mapRuta['detalleruta'].isNotEmpty){
        List<dynamic> coords = mapRuta['detalleruta'];
        
        // Convertimos las coordenadas de String a double de forma segura
        uciudadanoMapciudadano2page.cooredanddetalleRuta.value = coords.map((coord) {
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
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "obtenerDetalleRutaCamionMapaCiudadano: $ex");
      return [];     
    }  

    return uciudadanoMapciudadano2page.cooredanddetalleRuta;  
  }

  Future<void> cargarImagenIconosInicioFin() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null) {
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

      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addStyleImage(
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

      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addStyleImage(
        "end-icon", 1.0, mbxImageFin, false, [], [], null,
      );
    } catch (e) {
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al cargar iconos personalizados: $e");
      return;
    }
  }

  Future<void> mostrarRutaCamionMapaCiudadano() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null || uciudadanoMapciudadano2page.cooredanddetalleRuta.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {

      // Convertir las coordenadas al formato GeoJSON
      List<List<double>> coords = uciudadanoMapciudadano2page.cooredanddetalleRuta;
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
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addSource(
        mapbox.GeoJsonSource(
          id: "routeSource",
          data: jsonEncode({
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "geometry": {
                  "type": "LineString",
                  "coordinates": uciudadanoMapciudadano2page.cooredanddetalleRuta
                },
                "properties": {}
              }
            ]
          }),
        ),
      );


      // Agregar la capa para mostrar la línea de la ruta
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addLayer(
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
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "mostrarRutaCamionMapaCiudadano: $e");
      print("Error al mostrar Ruta Camion MapaCiudadano: $e");
      return;
    }
  }

  Future<void> mostrarPuntosInicioFin() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null || uciudadanoMapciudadano2page.cooredanddetalleRuta.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la primera y última coordenada
      var inicio = uciudadanoMapciudadano2page.cooredanddetalleRuta.first;
      var fin = uciudadanoMapciudadano2page.cooredanddetalleRuta.last;

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
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addSource(
        mapbox.GeoJsonSource(id: "startSource", data: geoJsonInicio),
      );

      // Agregar la fuente de datos para Fin
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addSource(
        mapbox.GeoJsonSource(id: "endSource", data: geoJsonFin),
      );

      // Agregar la capa de símbolos para el punto de INICIO (AZUL)
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addLayer(
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
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.style.addLayer(
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

  Future<void> centrarMapaEnRutaCiudadano() async {
    if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null || uciudadanoMapciudadano2page.cooredanddetalleRuta.isEmpty) {
      print("⚠ Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      var inicio = uciudadanoMapciudadano2page.cooredanddetalleRuta.first;
      var fin = uciudadanoMapciudadano2page.cooredanddetalleRuta.last;

      // 🔹 Calcular la distancia total de la ruta
      double distanciaTotal = Global().calcularDistanciaTotalRuta(uciudadanoMapciudadano2page.cooredanddetalleRuta);

      // 🔹 Calcular el centro entre los dos puntos
      double centerLat = (inicio[1] + fin[1]) / 2;
      double centerLng = (inicio[0] + fin[0]) / 2;

      // 🔹 Calcular el zoom basado en la distancia total
      double zoom = Global().calcularZoomSegunDistanciaMap(distanciaTotal);

      // 🔹 Esperar unos milisegundos antes de mover la cámara
      await Future.delayed(Duration(milliseconds: 800));

      if (uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 == null) {
        print("⚠ El mapa fue destruido antes de centrar la cámara.");
        return;
      }

      // 🔹 Mover la cámara al centro con el zoom calculado
      await uciudadanoMapciudadano2page.mapboxMapCiudadanapage2!.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
          zoom: zoom,
          padding: mapbox.MbxEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
        ),
      );

      print("✅ Cámara centrada correctamente en la ruta.");
    } catch (e) {
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al centrar el mapa en la ruta: $e");
      print("⚠ Error al centrar el mapa: $e");
      return;
    }
  }
  
  crearMapBoxCiudadanoPage2(mapbox.MapboxMap mapboxMap) => uciudadanoMapciudadano2page.mapboxMapCiudadanapage2 = mapboxMap;
}


class MapBoxCiudadanoRegistroController extends GetxController{
  final UciudadanoMapRegistrociudadano2 uciudadanoMapRegistrociudadano2page = Get.find<UciudadanoMapRegistrociudadano2>();
  mapbox.PointAnnotationManager? annotationManager;
  final UServidor uservidor = Get.find<UServidor>();

  Future<void> listarutasCiudadanoDropdowsbutton() async {
    try{
      uservidor.cargaprogreso.value = true;
      uciudadanoMapRegistrociudadano2page.listarutasCiudadano.value = await Rutamodel().mostrarRutasRegistroCiudadano();
      uciudadanoMapRegistrociudadano2page.listarutasCiudadanoDropdowsbutton.value = uciudadanoMapRegistrociudadano2page.listarutasCiudadano.isEmpty ? [] : uciudadanoMapRegistrociudadano2page.listarutasCiudadano.map((e) {
        return {
          "id_ruta": e["id_ruta"].toString(),
          "ruta_nombre": e["ruta_nombre"].toString()
        };
      }).toList();
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "Ciudadanocontroller [listarrutasCiudadano]");
    }
    uservidor.cargaprogreso.value = false;
  }
  
  void limpiarMapBoxCiudadanoRegistro(){    
    uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.clear();
    uciudadanoMapRegistrociudadano2page.listarutasCiudadano.clear();
    uciudadanoMapRegistrociudadano2page.listarutasCiudadanoDropdowsbutton.clear();

    uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.clear();
    uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadalista.clear();
    uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.clear();
    uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.clear();
    uciudadanoMapRegistrociudadano2page.cargarMapaLocalizarCiudadano.value = false;
    
    uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value = '';
    uciudadanoMapRegistrociudadano2page.idRutaGuardadaCiudadanoSeleccionadaValue.value = '';
  }
  
  Future<List<List<double>>> obtenerDetalleRutaMapBoxCiudadanoRegistro({required int idruta, int? pantallaOrigen = 2}) async {
    try{      
      Map<String, dynamic> mapRuta = uciudadanoMapRegistrociudadano2page.listarutasCiudadano.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});
      // if(pantallaOrigen == 1){
      //   //El 1 es de Regstrar Ciudadano
      //   mapRuta = uciudadanoMapRegistrociudadano2page.listarutasCiudadano.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});
      // }else if(pantallaOrigen == 2){
      //   //El 2 es Inicio del Ciudadano
      //   mapRuta = uciudadanoMapRegistrociudadano2page.listarutasCiudadanoInicio.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});
      // }

      if (mapRuta.containsKey('detalleruta') && mapRuta['detalleruta'].isNotEmpty){
        List<dynamic> coords = mapRuta['detalleruta'];
        
        // Convertimos las coordenadas de String a double de forma segura
        uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.value = coords.map((coord) {
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
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "obtenerDetalleRutaCamionMapaCiudadano: $ex");
      return [];     
    }  

    return uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano;  
  }

  Future<void> cargarImagenIconosInicioFin() async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null) {
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

      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addStyleImage(
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

      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addStyleImage(
        "end-icon", 1.0, mbxImageFin, false, [], [], null,
      );
    } catch (e) {
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al cargar iconos personalizados: $e");
      return;
    }
  }

  Future<void> mostrarRutaCamionMapaCiudadano() async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null || 
        uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.isEmpty) {
      print("⚠ Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      var style = uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style;

      // 🔥 Verificar si la fuente ya existe y eliminarla antes de agregar una nueva
      try {
        await style.removeStyleSource("routeSourceRegistroCiudadano");
        await style.removeStyleLayer("routeLayerRegistroCiudadano");
        print("🗑 Fuente y capa eliminadas antes de actualizar.");
      } catch (e) {
        print("🔍 No se encontró la fuente/layer, se creará una nueva.");
      }

      // 🔹 Convertir las coordenadas al formato GeoJSON
      List<mapbox.Position> coords = uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano
          .map((coord) => mapbox.Position(coord[0], coord[1]))
          .toList();

      var lineString = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": coords.map((p) => [p.lng, p.lat]).toList(),
            },
            "properties": {}
          }
        ]
      });

      // 🔹 Agregar la fuente de datos al mapa
      await style.addSource(
        mapbox.GeoJsonSource(id: "routeSourceRegistroCiudadano", data: lineString),
      );

      // 🔹 Agregar la capa para visualizar la línea de la ruta
      await style.addLayer(
        mapbox.LineLayer(
          id: "routeLayerRegistroCiudadano",
          sourceId: "routeSourceRegistroCiudadano",
          lineColor: Colors.blue.value,
          lineWidth: 5.0,
          lineOpacity: 0.8,
          lineJoin: mapbox.LineJoin.ROUND,
          lineCap: mapbox.LineCap.ROUND,
        ),
      );

      print("✅ Ruta agregada al mapa con éxito.");
    } catch (e) {
      print("❌ Error al mostrar Ruta Camion MapaCiudadano: $e");
    }
  }

  Future<void> centrarMapaEnRutaCiudadano() async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null || 
        uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.isEmpty) {
      print("⚠ Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      var coords = uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano;

      // 🔹 Calcular el Bounding Box (mínimos y máximos de latitud y longitud)
      double minLat = double.infinity, maxLat = double.negativeInfinity;
      double minLng = double.infinity, maxLng = double.negativeInfinity;

      for (var coord in coords) {
        double lng = coord[0]; // Longitud
        double lat = coord[1]; // Latitud

        if (lat < minLat) minLat = lat;
        if (lat > maxLat) maxLat = lat;
        if (lng < minLng) minLng = lng;
        if (lng > maxLng) maxLng = lng;
      }

      // 🔹 Calcular el centro del Bounding Box
      double centerLat = (minLat + maxLat) / 2;
      double centerLng = (minLng + maxLng) / 2;

      // 🔹 Calcular distancia máxima para ajustar el zoom automáticamente
      double distancia = Global().calcularDistanciaMap(lat1: minLat,lon1: minLng, lat2: maxLat, lon2: maxLng);
      double zoom = Global().calcularZoomSegunDistanciaMap(distancia);

      // 🔹 Mover la cámara al centro con el zoom calculado
      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
          zoom: zoom,
          padding: mapbox.MbxEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0),
        ),
      );

      print("✅ Cámara centrada correctamente en la ruta.");
    } catch (e) {
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "Error al centrar el mapa en la ruta: $e");
      print("⚠ Error al centrar el mapa: $e");
    }
  }

  Future<void> mostrarIconosInicioFin() async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null || uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la primera y última coordenada
      var inicio = uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.first;
      var fin = uciudadanoMapRegistrociudadano2page.coordenadasRutaCiudadano.last;

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
      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addSource(
        mapbox.GeoJsonSource(id: "startSource", data: geoJsonInicio),
      );

      // Agregar la fuente de datos para Fin
      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addSource(
        mapbox.GeoJsonSource(id: "endSource", data: geoJsonFin),
      );

      // Agregar la capa de símbolos para el punto de INICIO (AZUL)
      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addLayer(
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
      await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.style.addLayer(
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
 
  Future<void> listarrutasGuardadasCiudadano({required int idRuta}) async{
    try{
      // Validar si el idRuta ya existe en la lista
      bool existe = uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.any((ruta) {
        return ruta["id_ruta"] == idRuta.toString();
      });

      if (existe) {
        Global().modalErrorShowDialog(context: Get.context!, mensaje: "Seleccionastes una ruta que ya estaba Guardada.\nvelve a seleccionar la ubicacion de su casa.");
      }

      // Si no existe, almacenamos el ID y su nombre
      final nuevaRuta = uciudadanoMapRegistrociudadano2page.listarutasCiudadano.firstWhere(
        (e) => e["id_ruta"] == idRuta,
        orElse: () => {},
      );

      if (nuevaRuta == null) {
        Global().modalErrorShowDialog(context: Get.context!, mensaje: "No se encontró información para el ID de ruta $idRuta.");
        return;
      }

      // Agregar la nueva ruta a la lista de rutas guardadas
      uciudadanoMapRegistrociudadano2page.listaGuardadasderutasCiudadanoDropdowsbutton.add({
        "id_ruta": nuevaRuta["id_ruta"].toString(),
        "ruta_nombre": nuevaRuta["ruta_nombre"].toString()
      });
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "Ciudadanocontroller [listarrutasGuardadasCiudadano]");
    }
  } 
  
  List<List<double>> obtenercoordenadaCasaGuardadaPorRuta(String idRuta) {
    var ruta = uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.firstWhere(
      (element) => element.containsKey(idRuta),
      orElse: () => {},
    );

    return ruta.isNotEmpty ? ruta[idRuta]! : [];

    //Ejemplo de uso:
    // String idRutaSeleccionada = "1";  // Suponiendo que esta es la ruta seleccionada
    // List<List<double>> coordenadas = obtenercoordenadaCasaGuardadaPorRuta(idRutaSeleccionada);
    // print("Coordenadas de la ruta $idRutaSeleccionada: $coordenadas");
  }

  void eliminarCoordenadaCasaGuardadaPorRuta(String idRuta, int index) { 
    int rutaIndex = uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.indexWhere((element) => element.containsKey(idRuta));
    
    if (rutaIndex != -1) {
      if (uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.length > index) {
        uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.removeAt(index);
        
        // Si la lista de coordenadas queda vacía, eliminamos toda la ruta
        if (uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.isEmpty) {
          uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.removeAt(rutaIndex);
        }

        print("Coordenada eliminada correctamente.");
      }
    } else {
      print("No se encontró la ruta con ID: $idRuta.");
    }

    // Ejemplo de uso 
    //Elimina la primera coordenada de la ruta con ID "1": 
    // eliminarCoordenadaCasaGuardadaPorRuta("1", 0);
  }

  Future<void> onMapTapCiudadano(mapbox.MapContentGestureContext context) async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null) {
      print("Error: El mapa no está inicializado.");
      return;
    }

    // Inicializar o reiniciar el annotationManager si es necesario
    if (annotationManager == null) {
      annotationManager = await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.annotations.createPointAnnotationManager();
    }

    try {
      final latitude = context.point.coordinates.lat;
      final longitude = context.point.coordinates.lng;
      uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.add([latitude.toDouble(), longitude.toDouble()]);

      if (uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.isEmpty) {
        print("Error: No hay una ruta seleccionada.");
        return;
      }

       // Buscar si ya existe esta ruta en la lista
      int index = uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.indexWhere((element) => element.containsKey(uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value));

      if (index != -1) {
      // Si la ruta ya existe, agregamos la coordenada a su lista
        uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap[index][uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value]!.add([latitude.toDouble(), longitude.toDouble()]);
      } else {
        // Si la ruta no existe, creamos una nueva entrada
        uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadaMap.add({
          uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value : [[latitude.toDouble(), longitude.toDouble()]]
        });
      }

      await agregarAnotacionMapaCiudadano(latitude.toDouble(), longitude.toDouble(), uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.length);
      print("Anotación agregada: Lat: $latitude, Lng: $longitude");
    } catch (e) {
      print("Error al manejar el toque en el mapa: $e");
    }
    // if (uciudadano.mapboxMappCiudadano != null) {
    //   // Obtener las coordenadas geográficas desde el evento de toque
    //   final latitude = context.point.coordinates.lat;
    //   final longitude = context.point.coordinates.lng;

    //   // Guardar las coordenadas en la lista reactiva
    //   uciudadano.coordenadasCasaCiudadano.add([latitude.toDouble(), longitude.toDouble()]);

    //   // Crear una anotación en la ubicación tocada
    //   await addAnnotation(latitude.toDouble(), longitude.toDouble(), uciudadano.coordenadasCasaCiudadano.length);

    //   // Mostrar mensaje de depuración
    //   print("Coordenadas seleccionadas: Lat: $latitude, Lng: $longitude");
    //   print("Punto en pantalla: X: ${context.touchPosition.x}, Y: ${context.touchPosition.y}");
    // }
  }

  Future<void> agregarAnotacionMapaCiudadano(double lat, double lng, int index) async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano != null) {
      
      // Inicializar o reiniciar el annotationManager si es necesario
      if (annotationManager == null) {
        annotationManager = await uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano!.annotations.createPointAnnotationManager();
      }

      final pointAnnotation = mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
        textField: index.toString(),
        textColor: 0xFFFFFFFF,  // Blanco en formato ARGB hexadecimal
        textSize: 20,  // Tamaño del texto
        textHaloColor: 0xFF000000,  // Contorno negro para contraste
        textHaloWidth: 1.5,  // Grosor del contorno de texto
        iconImage: "custom-marker-icon",
      );

      try {
        final annotation = await annotationManager!.create(pointAnnotation);
        uciudadanoMapRegistrociudadano2page.annotationIds.add(annotation); // Agrega la anotación a la lista
        print("Anotación creada con éxito: ${annotation.id}");
      } catch (e) {
        print("Error al agregar anotación: $e");
      }
    } else {
      print("El mapa no está inicializado.");
    }
  }

  Future<void> eliminarAnotacionMapaCiudadano(int index) async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano != null && annotationManager != null && index < uciudadanoMapRegistrociudadano2page.annotationIds.length) {
      try {
        // Eliminar la anotación específica
        // Valida que la anotación aún exista en el mapa
        final annotationToDelete = uciudadanoMapRegistrociudadano2page.annotationIds[index];
        if (annotationToDelete != null) {
          await annotationManager!.delete(annotationToDelete);
          uciudadanoMapRegistrociudadano2page.annotationIds.removeAt(index);
          uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.removeAt(index);
          eliminarCoordenadaCasaGuardadaPorRuta(uciudadanoMapRegistrociudadano2page.idRutaCiudadanoSeleccionadaValue.value, index);
          await actualizarMarcadores();
        }
        print("Marcador eliminado correctamente.");
      } catch (e) {
        print("Error eliminando anotación: $e");
      }
    } else {
      print("Índice inválido o lista vacía.");
    }
  }

  Future<void> mostrarAnotacionesRutaCoordenadaGuardada(String idRuta) async {
    if (uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano == null) {
      print("El mapa no está inicializado.");
      return;
    }

    List<List<double>> coordenadas = obtenercoordenadaCasaGuardadaPorRuta(idRuta);
    uciudadanoMapRegistrociudadano2page.coordenadaCasaGuardadalista.value = coordenadas;
    if (coordenadas.isEmpty) {
      print("No hay coordenadas guardadas para la ruta $idRuta.");
      return;
    }

    // // Limpiar anotaciones anteriores
    // await limpiarAnotaciones();

    // try {
    //   // Verificar si el annotationManager está inicializado, si no, crearlo
    //   annotationManager ??= await uciudadano.mapboxMappCiudadano!.annotations.createPointAnnotationManager();

    //   // 🔵 3️⃣ Agregar todas las coordenadas guardadas al mapa
    //   for (int i = 0; i < coordenadas.length; i++) {
    //     await agregarAnotacionMapaCiudadano(coordenadas[i][0], coordenadas[i][1], i + 1);
    //   }

    //   print("Anotaciones de la ruta $idRuta mostradas en el mapa.");
    // } catch (e) {
    //   print("Error al mostrar anotaciones: $e");
    // }
  }

  // Método para actualizar los marcadores después de la eliminación
  Future<void> actualizarMarcadores() async {
    if (annotationManager != null) {
      await annotationManager!.deleteAll();
      uciudadanoMapRegistrociudadano2page.annotationIds.clear();

      for (int i = 0; i < uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.length; i++) {
        final coord = uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano[i];
        await agregarAnotacionMapaCiudadano(coord[0], coord[1], i + 1);
      }
    }
  }

  Future<void> limpiarAnotaciones() async {

    if (annotationManager != null) {
      try {
        await annotationManager!.deleteAll(); // Elimina todas las anotaciones del mapa
        // if(uciudadano.saberDropDowButtonSeleccionado.value) annotationManager = null;
        annotationManager = null; // Invalida el annotationManager actual

        print("Anotaciones anteriores eliminadas.");
      } catch (e) {
        print("Error al limpiar anotaciones: $e");
      }
    }

    // Reinicia la lista de anotaciones locales
    uciudadanoMapRegistrociudadano2page.annotationIds.clear();
    uciudadanoMapRegistrociudadano2page.coordenadasCasaCiudadano.clear();
    
  }

  crearMapBoxCiudadano(mapbox.MapboxMap mapboxMap) => uciudadanoMapRegistrociudadano2page.mapboxMappRegistroCiudadano = mapboxMap;
}