import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../config/library/import.dart';

class Global {

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
}