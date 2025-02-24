import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../config/library/import.dart';

class Global {

  final picker = ImagePicker();

  /// 🔥 Método para monitorear la conexión a Internet
  void monitorearConexionInternet() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
    }

    // connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     print("❌ Sin conexión a Internet. Deteniendo seguimiento...");
    //     detenerSeguimientovehiculotiemporeal();
    //     isTrackingActive = true; // Guardamos que el seguimiento estaba activo
    //     Get.snackbar("Sin conexión", "No hay Internet. Seguimiento detenido.", snackPosition: SnackPosition.TOP);
    //   } else {
    //     if (isTrackingActive) {
    //       print("✅ Conexión restablecida. Reiniciando seguimiento...");
    //       isTrackingActive = false;
    //       iniciarSeguimientoVehiculo(); // 🔥 Reiniciar solo si estaba activo antes
    //     }
    //   }
    // });
  }

  String formatearFecha(String fecha) {
    try {
      DateFormat formatoEntrada = DateFormat("yyyy-MM-dd HH:mm:ss"); // Formato de entrada
      DateTime fechaDateTime = formatoEntrada.parse(fecha);

      // Formato de salida: dd/MM/yyyy HH:mm
      return DateFormat("dd/MM/yyyy HH:mm").format(fechaDateTime);
    } catch (e) {
      return "Fecha inválida $e";
    }
  }

  Future<Map<String, dynamic>> obtenerImagen({required bool tieneFoto}) async {
    XFile? foto;
    bool eliminar = false;

    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      showDragHandle: true,
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      context: Get.context!,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Style.textTitulo(mensaje: "Seleccione una opción"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    foto = await picker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context, {"foto": foto});
                  },
                  child: Column(
                    children: [
                      Style.estiloIcon(icon: Icons.camera_alt_outlined, size: 30),
                      Style.textTitulo(mensaje: "Cámara"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    foto = await picker.pickImage(source: ImageSource.gallery);
                    Navigator.pop(context, {"foto": foto});
                  },
                  child: Column(
                    children: [
                      Style.estiloIcon(icon: Icons.photo_outlined, size: 30),
                      Style.textTitulo(mensaje: "Galería"),
                    ],
                  ),
                ),
                if(tieneFoto) TextButton(
                  onPressed: () {
                    eliminar = true;
                    Navigator.pop(context, {"eliminar": true});
                  },
                  child: Column(
                    children: [
                      Style.estiloIcon(icon: Icons.delete, size: 30, color: Colors.red),
                      Style.textTitulo(mensaje: "Eliminar"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );

    if (resultado != null) {
      return resultado;
    } else {
      return {};
    }
  }

  String obtenerSaludo() {
    DateTime now = DateTime.now();
    int hora = now.hour;

    if (hora >= 6 && hora < 12) {
      return "¡Buenos días! 🌅";
      
    } else if (hora >= 12 && hora < 18) {
      return "¡Buenas tardes! ☀️";
    } else {
      return "¡Buenas noches! 🌙";
    }
  }

  bool validarJson(String source) {
    try {
      jsonDecode(source);
      return true;
    } catch (e) {
      return false;
    }
  }

  double valoraDouble(String value) {
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), ''); // Elimina caracteres no deseados
    if (cleanedValue.isEmpty || cleanedValue == '.') {
      return 0.0;
    }
    try {
      return double.parse(cleanedValue);
    } catch (e) {
      return 0.0;
    }
  }

  bool validarCorreoElectronico(String correo) {
    bool validar = false;
    try {
      RegExp emailCaracteres = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if(correo.contains(emailCaracteres)) {
        return true;   
      }
      else {       
        // mensajeShowToast(mensaje: "el Correo no tiene un formato correcto", colortexto: Predeterminado.ColorBlanco, colorFondo: Predeterminado.ColorRojo);
        return false;
      }  
    }
    catch(ex)  {
      // mensajeShowToast(mensaje: "ValidarCorreoElctronico: $ex", colortexto: Predeterminado.ColorBlanco, colorFondo: Predeterminado.ColorRojo);
      validar = false;
    }
    return validar;
  }

  void modalErrorShowDialog({required BuildContext context, String? mensaje, List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: <Widget> [
              Style.estiloIcon(icon: Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Style.textTitulo(mensaje: "Error", fontSize: 22)
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mensaje ?? "")
                // Style.textTitulo(mensaje: mensaje ?? "")
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  void modalCircularProgress({required BuildContext context,RxString? mensaje, bool? barrierDismissible}) async {
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: IntrinsicWidth(  // Se ajusta automáticamente al contenido en ancho
              child: IntrinsicHeight(  // Se ajusta automáticamente al contenido en altura
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,  // Ajusta el tamaño del Row al contenido
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Style.colorceleste),
                      ),
                      const SizedBox(width: 10),
                      if(mensaje != null) 
                        Obx(() => 
                          Flexible(  // Evita el desbordamiento del texto
                            child: Style.textTitulo(
                              mensaje: mensaje.value,
                              maxlines: 2,  // Limitar el texto a 2 líneas si es muy largo
                              textOverflow: TextOverflow.ellipsis,  // Cortar el texto si es muy largo
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //Mensaje modales showToast
  void mensajeShowToast({required String mensaje, Color? colorFondo, Color? colortexto, double? fontSize, int? timeInSecForIosWeb, ToastGravity? gravity}){
    if (Platform.isAndroid || Platform.isIOS) {
      Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
        textColor: colortexto ?? Style.colorBlanco,
        backgroundColor: colorFondo ?? Style.colorRojo,
        gravity: gravity ?? ToastGravity.BOTTOM,
        fontSize: fontSize ?? 11
      );  
    }    
  }

  void mensajeGetSnackBar({String? titulo, String? mensaje, Color? colorFondo, Color? colorTexto, SnackPosition? snackPosition, Widget? icon, Function(GetSnackBar)? onTap}) {
    Get.snackbar(
      icon: icon,
      titulo ?? "Titulo",
      mensaje ?? "Mensaje",
      snackPosition: snackPosition ?? SnackPosition.TOP,
      backgroundColor: colorFondo ?? Style.colorBlanco,
      colorText: colorTexto ?? Style.colorNegro,
      onTap: onTap,
      duration: const Duration(seconds: 3),
    );
  }
  
  Future<void> modalShowModalBottomSheetPregunta({required BuildContext context, bool? isDismissible, required String titulo, String? mensaje, 
  VoidCallback? onPressedCancel, VoidCallback? onLongPressedCancell, VoidCallback? onPressedOK, VoidCallback? onLongPressedOk, String? botonNombreOK, String? botonNombreCancell}) {  
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isDismissible: isDismissible ?? false,
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea el contenido al centro
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Style.textTitulo(mensaje: titulo, colorTexto: Theme.of(context).colorScheme.onBackground),
              const SizedBox(height: 20),
              if(mensaje != null) Style.textSubTitulo(mensaje: mensaje, colorTexto: Theme.of(context).colorScheme.onBackground),
              if(mensaje != null) const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Style.btnElevatedButton(
                      onLongPress: onLongPressedCancell,
                      onPressed: () {
                        if (onPressedCancel != null) {
                          onPressedCancel();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Style.textTitulo(mensaje: botonNombreCancell ?? "Cancelar", colorTexto: Style.colorBlanco),
                    )                    
                  ),
                  if(onLongPressedOk != null || onPressedOK != null || botonNombreOK != null) const SizedBox(width: 16),                  
                  if(onLongPressedOk != null || onPressedOK != null || botonNombreOK != null) Expanded(
                    child: Style.btnElevatedButton(
                      onLongPress: onLongPressedOk,
                      onPressed: () {
                        if (onPressedOK != null) {
                          onPressedOK();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Style.textTitulo(mensaje: botonNombreOK ?? "Aceptar", fontSize: 16, colorTexto: Style.colorBlanco),
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

  Future<void> modalShowCupertinoModalPopup({required BuildContext context, bool? isDismissible, required String titulo, String? mensaje, VoidCallback? onPressedCancel, 
    VoidCallback? onPressedOK, String? botonNombreOK, String? botonNombreCancell}) {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: isDismissible ?? false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Style.textTitulo(mensaje: titulo, fontSize: 16, colorTexto: Style.colorceleste),
          message: mensaje != null ? Style.textSubTitulo(mensaje: mensaje) : null,
          actions: <Widget>[
            if (botonNombreCancell != null)
              CupertinoActionSheetAction(
                onPressed: () {
                  if (onPressedCancel != null) {
                    onPressedCancel();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(botonNombreCancell, style: const TextStyle(color: Colors.red)),
              ),
            if (botonNombreOK != null || onPressedOK != null)
              CupertinoActionSheetAction(
                onPressed: () {
                  if (onPressedOK != null) {
                    onPressedOK();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Style.textTitulo(mensaje: botonNombreOK ?? "Aceptar")
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Style.textTitulo(mensaje: "Cerrar", fontSize: 16, colorTexto: Style.colorceleste),
          ),
        );
      },
    );
  }

  Future<void> modalShowCupertinoDialog({required BuildContext context, required String titulo,
    String? mensaje, VoidCallback? onPressedOK, String botonNombreOK = "Aceptar", Color colorTextOK = Colors.transparent, String botonNombreCancell = "Cancelar"
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Style.textTitulo(mensaje: titulo, colorTexto: Style.colorceleste),
          content: mensaje != null ? Style.textSubTitulo(mensaje: mensaje) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              child: Style.textTitulo(mensaje: botonNombreCancell, colorTexto: Style.colorceleste),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if(onPressedOK != null) CupertinoDialogAction(
              onPressed: onPressedOK,
              child: Style.textTitulo(mensaje: botonNombreOK, colorTexto: colorTextOK),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Función para calcular la distancia total de la ruta sumando cada segmento
  double calcularDistanciaTotalRuta(List<List<double>> coordenadas) {
    if (coordenadas.length < 2) return 0.0; // Si hay menos de 2 puntos, no hay distancia
    double distanciaTotal = 0.0;

    for (int i = 0; i < coordenadas.length - 1; i++) {
      double lat1 = coordenadas[i][1];
      double lon1 = coordenadas[i][0];
      double lat2 = coordenadas[i + 1][1];
      double lon2 = coordenadas[i + 1][0];

      distanciaTotal += calcularDistanciaMap(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2);
    }
    return distanciaTotal;
  }

  // 🔹 Calcular la distancia usando la diagonal del Bounding Box
  double calcularDistanciaMap({double? lat1, double? lon1, double? lat2, double? lon2}) {
    const double R = 6371; // Radio de la Tierra en km
    double dLat = (lat2! - lat1!) * pi / 180;
    double dLon = (lon2! - lon1!) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return (R * c) * 1000; // 🔥 Convertimos a METROS
  }

  // 🔹 Función optimizada para calcular el zoom según la distancia
  double calcularZoomSegunDistanciaMap(double distancia) {
    print("Distancia: $distancia");
    if (distancia <= 100) return 18.50;
    if (distancia <= 200) return 17.50;
    if (distancia <= 400) return 16;
    if (distancia <= 1000) return 14.50;
    if (distancia <= 1500) return 14.30;
    if (distancia <= 3000) return 13;
    if (distancia <= 5000) return 14;
    if (distancia <= 7000) return 13;
    if (distancia <= 10000) return 12;
    return 10.0; // 🔭 Más de 10 km
  }

}