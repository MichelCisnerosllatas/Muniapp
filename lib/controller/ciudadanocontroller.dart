import '../config/library/import.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class Ciudadanocontroller extends GetxController {
  final Uciudadano uciudadano = Get.find<Uciudadano>();
  final UServidor uservidor = Get.find<UServidor>();
  final UUsuario uusuario = Get.find();
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

  void initStateRegistroCiudadano(){
    uciudadano.focotxtxtNombre = FocusNode();
    uciudadano.focotxtApellido = FocusNode();
    uciudadano.focotxtcorreo = FocusNode();
    uciudadano.focotxtusuario = FocusNode();
    uciudadano.focotxtClave = FocusNode();
    uciudadano.focotxtCelular = FocusNode();
  }

  Future<List<List<double>>> detalleRutaCamionCiudadano({required int idruta, int? pantallaOrigen = 2}) async {
    try{      
      Map<String, dynamic> mapRuta = {};
      if(pantallaOrigen == 1){
        //El 1 es de Regstrar Ciudadano
        mapRuta = uciudadano.listarutasCiudadano.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});
      }else if(pantallaOrigen == 2){
        //El 2 es Inicio del Ciudadano
        mapRuta = uciudadano.listarutasCiudadanoInicio.firstWhere((e) => e["id_ruta"] == idruta, orElse: () => {});
      }

      if (mapRuta.containsKey('detalleruta') && mapRuta['detalleruta'].isNotEmpty){

        List<dynamic> coords = mapRuta['detalleruta'];
        
        // Convertimos las coordenadas de String a double de forma segura
        uciudadano.coordenadasRutaCiudadano.value = coords.map((coord) {
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

      print( "Detalle Ruta: ${uciudadano.coordenadasRutaCiudadano}");
    }catch(ex){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "detalleRutaCamionCiudadano $ex");      
    }  

    return uciudadano.coordenadasRutaCiudadano;  
  }

  Future<void> agregarRutaAlMapaCiudadano() async {
    if (uciudadano.mapboxMappCiudadano == null || uciudadano.coordenadasRutaCiudadano.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {

      // Convertir las coordenadas al formato GeoJSON
      List<List<double>> coords = uciudadano.coordenadasRutaCiudadano;
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
      await uciudadano.mapboxMappCiudadano!.style.addSource(
        mapbox.GeoJsonSource(
          id: "routeSource",
          data: jsonEncode({
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "geometry": {
                  "type": "LineString",
                  "coordinates": uciudadano.coordenadasRutaCiudadano
                },
                "properties": {}
              }
            ]
          }),
        ),
      );


      // Agregar la capa para mostrar la línea de la ruta
      await uciudadano.mapboxMappCiudadano!.style.addLayer(
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

  Future<void> centrarMapaEnRutaCiudadano() async {
    if (uciudadano.mapboxMappCiudadano == null || uciudadano.coordenadasRutaCiudadano.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la lista de coordenadas
      List<List<double>> coords = uciudadano.coordenadasRutaCiudadano;

      // Calcular el punto medio de la ruta
      double sumLat = 0.0, sumLng = 0.0;
      for (var coord in coords) {
        sumLng += coord[0];
        sumLat += coord[1];
      }

      double centerLng = sumLng / coords.length;
      double centerLat = sumLat / coords.length;

      // Establecer la cámara en el punto medio calculado
      await uciudadano.mapboxMappCiudadano!.setCamera(
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

  Future<void> agregarIconosInicioFinCiudadano() async {
    if (uciudadano.mapboxMappCiudadano == null || uciudadano.coordenadasRutaCiudadano.isEmpty) {
      print("Mapa no inicializado o no hay coordenadas disponibles.");
      return;
    }

    try {
      // Obtener la primera y última coordenada
      var inicio = uciudadano.coordenadasRutaCiudadano.first;
      var fin = uciudadano.coordenadasRutaCiudadano.last;

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
      await uciudadano.mapboxMappCiudadano!.style.addSource(
        mapbox.GeoJsonSource(id: "pointsSource", data: geoJson),
      );

      // Agregar la capa de símbolos para mostrar los iconos predefinidos
      await uciudadano.mapboxMappCiudadano!.style.addLayer(
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
  
  Future<void> listarrutasCiudadano() async{
    try{
      uservidor.cargaprogreso.value = true;
      uciudadano.listarutasCiudadano.value = await Rutamodel().mostrarRutasRegistroCiudadano();
      uciudadano.listarutasCiudadanoDropdowsbutton.value = uciudadano.listarutasCiudadano.isEmpty ? [] : uciudadano.listarutasCiudadano.map((e) {
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

  Future<void> listarrutasGuardadasCiudadano({required int idRuta}) async{
    try{
      // Validar si el idRuta ya existe en la lista
      bool existe = uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.any((ruta) {
        return ruta["id_ruta"] == idRuta.toString();
      });

      if (existe) {
        Global().modalErrorShowDialog(context: Get.context!, mensaje: "La ruta con ID $idRuta ya está guardada.");
        return;
      }

      // Si no existe, almacenamos el ID y su nombre
      final nuevaRuta = uciudadano.listarutasCiudadano.firstWhere(
        (e) => e["id_ruta"] == idRuta,
        orElse: () => {},
      );

      if (nuevaRuta == null) {
        Global().modalErrorShowDialog(context: Get.context!, mensaje: "No se encontró información para el ID de ruta $idRuta.");
        return;
      }

      // Agregar la nueva ruta a la lista de rutas guardadas
      uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.add({
        "id_ruta": nuevaRuta["id_ruta"].toString(),
        "ruta_nombre": nuevaRuta["ruta_nombre"].toString()
      });
    }catch(ex){
      uservidor.servidorExpecion(ex, modal: true, localizar: "Ciudadanocontroller [listarrutasGuardadasCiudadano]");
    }
  }

  void registrarCiudadanoyCoordenadasCasa() {  

    if(uciudadano.coordenadaCasaGuardadaMap.isEmpty){
      Global().modalErrorShowDialog(context: Get.context!, mensaje: "No se han agregado coordenadas de casa.");
      return;
    }

    Global().modalShowModalBottomSheetPregunta(
      context: Get.context!, 
      titulo: "estas seguro?", 
      mensaje: "verifica tus coordenadas antes de registrar",
      onPressedOK: () async{
        Navigator.pop(Get.context!);
        uservidor.mensajeTituloServidor.value = "Registrando Ciudadano"; 
        Global().modalCircularProgress(context: Get.context!, mensaje: uservidor.mensajeTituloServidor);
        var m = await Ciudadanomodel().registrarCiudadano(datosJson: {
          "nombre" : uciudadano.txtNombre.text.trim(),
          "apellido" : uciudadano.txtApellido.text.trim(),
          "correo" : uciudadano.txtcorreo.text.trim(),
          "celular" : uciudadano.txtCelular.text.trim(),
          "usuario" : uciudadano.txtusuario.text.trim(),
          "clave" : uciudadano.txtClave.text.trim()
        });
        
        if(!m["success"] || !m.containsKey("data")){
          Navigator.pop(Get.context!);
          Global().modalErrorShowDialog(context: Get.context!, mensaje: "error al Registrar el Ciudadano.");
          return;
        }

        int iduciuda = m["data"]["id_users"];
        uservidor.mensajeTituloServidor.value = "Registrando Coordenadas";
        
        // uciudadano.coordenadaCasaGuardadalista.clear();        
        final idrutasselecionadas = uciudadano.coordenadaCasaGuardadaMap
        .expand((entry) => entry.keys) // Obtiene las claves de los mapas
        .map((key) => key.toString()) // Convierte a String
        .toList();

        for(int i = 0; i < idrutasselecionadas.length; i++){
          List<List<double>> coordenadas = obtenercoordenadaCasaGuardadaPorRuta(idrutasselecionadas[i]);
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
        await limpiarAnotaciones();
        limpiarregistroCiudadano();
        await Usuariocontroller().validarLogin(username: uciudadano.txtusuario.text.trim(), password: uciudadano.txtClave.text.trim());
      }
    );   
    
  }
  
  List<List<double>> obtenercoordenadaCasaGuardadaPorRuta(String idRuta) {
    var ruta = uciudadano.coordenadaCasaGuardadaMap.firstWhere(
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
    int rutaIndex = uciudadano.coordenadaCasaGuardadaMap.indexWhere((element) => element.containsKey(idRuta));
    
    if (rutaIndex != -1) {
      if (uciudadano.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.length > index) {
        uciudadano.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.removeAt(index);
        
        // Si la lista de coordenadas queda vacía, eliminamos toda la ruta
        if (uciudadano.coordenadaCasaGuardadaMap[rutaIndex][idRuta]!.isEmpty) {
          uciudadano.coordenadaCasaGuardadaMap.removeAt(rutaIndex);
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
    if (uciudadano.mapboxMappCiudadano == null) {
      print("Error: El mapa no está inicializado.");
      return;
    }

    // Inicializar o reiniciar el annotationManager si es necesario
    if (annotationManager == null) {
      annotationManager = await uciudadano.mapboxMappCiudadano!.annotations.createPointAnnotationManager();
    }

    try {
      final latitude = context.point.coordinates.lat;
      final longitude = context.point.coordinates.lng;
      uciudadano.coordenadasCasaCiudadano.add([latitude.toDouble(), longitude.toDouble()]);

      if (uciudadano.idRutaCiudadanoSeleccionadaValue.isEmpty) {
        print("Error: No hay una ruta seleccionada.");
        return;
      }

       // Buscar si ya existe esta ruta en la lista
      int index = uciudadano.coordenadaCasaGuardadaMap.indexWhere((element) => element.containsKey(uciudadano.idRutaCiudadanoSeleccionadaValue.value));

      if (index != -1) {
      // Si la ruta ya existe, agregamos la coordenada a su lista
        uciudadano.coordenadaCasaGuardadaMap[index][uciudadano.idRutaCiudadanoSeleccionadaValue.value]!.add([latitude.toDouble(), longitude.toDouble()]);
      } else {
        // Si la ruta no existe, creamos una nueva entrada
        uciudadano.coordenadaCasaGuardadaMap.add({
          uciudadano.idRutaCiudadanoSeleccionadaValue.value : [[latitude.toDouble(), longitude.toDouble()]]
        });
      }

      await agregarAnotacionMapaCiudadano(latitude.toDouble(), longitude.toDouble(), uciudadano.coordenadasCasaCiudadano.length);
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
    if (uciudadano.mapboxMappCiudadano != null) {
      
      // Inicializar o reiniciar el annotationManager si es necesario
      if (annotationManager == null) {
        annotationManager = await uciudadano.mapboxMappCiudadano!.annotations.createPointAnnotationManager();
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
        uciudadano.annotationIds.add(annotation); // Agrega la anotación a la lista
        print("Anotación creada con éxito: ${annotation.id}");
      } catch (e) {
        print("Error al agregar anotación: $e");
      }
    } else {
      print("El mapa no está inicializado.");
    }
  }

  Future<void> eliminarAnotacionMapaCiudadano(int index) async {
    if (uciudadano.mapboxMappCiudadano != null && annotationManager != null && index < uciudadano.annotationIds.length) {
      try {
        // Eliminar la anotación específica
        // Valida que la anotación aún exista en el mapa
        final annotationToDelete = uciudadano.annotationIds[index];
        if (annotationToDelete != null) {
          await annotationManager!.delete(annotationToDelete);
          uciudadano.annotationIds.removeAt(index);
          uciudadano.coordenadasCasaCiudadano.removeAt(index);
          eliminarCoordenadaCasaGuardadaPorRuta(uciudadano.idRutaCiudadanoSeleccionadaValue.value, index);
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
    if (uciudadano.mapboxMappCiudadano == null) {
      print("El mapa no está inicializado.");
      return;
    }

    List<List<double>> coordenadas = obtenercoordenadaCasaGuardadaPorRuta(idRuta);
    uciudadano.coordenadaCasaGuardadalista.value = coordenadas;
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
      uciudadano.annotationIds.clear();

      for (int i = 0; i < uciudadano.coordenadasCasaCiudadano.length; i++) {
        final coord = uciudadano.coordenadasCasaCiudadano[i];
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
    uciudadano.annotationIds.clear();
    uciudadano.coordenadasCasaCiudadano.clear();
    
  }

  void limpiarregistroCiudadano(){
    uciudadano.txtNombre.clear();
    uciudadano.txtApellido.clear();
    // uciudadano.txtClave.clear();
    uciudadano.txtcorreo.clear();
    uciudadano.listaGuardadasderutasCiudadanoDropdowsbutton.clear();
    uciudadano.listarutasCiudadano.clear();
    uciudadano.listarutasCiudadanoDropdowsbutton.clear();

    uciudadano.coordenadaCasaGuardadaMap.clear();
    uciudadano.coordenadaCasaGuardadalista.clear();
    uciudadano.coordenadasCasaCiudadano.clear();
    uciudadano.coordenadasRutaCiudadano.clear();
    uciudadano.cargarMapaLocalizarCiudadano.value = false;
    uciudadano.cargarRegistroCiudadano.value = false;
    uciudadano.idRutaCiudadanoSeleccionadaValue.value = '';
    uciudadano.idRutaGuardadaCiudadanoSeleccionadaValue.value = '';
  }
  
  onTap(mapbox.MapContentGestureContext context) {
    print("OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" + " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}");
  }

  crearMapBoxCiudadano(mapbox.MapboxMap mapboxMap) => uciudadano.mapboxMappCiudadano = mapboxMap;
}