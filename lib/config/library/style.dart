import '../../config/library/import.dart';

class Style {
  static Color colorceleste = const Color.fromARGB(255, 50, 132, 255); 
  static Color colorBlanco = Colors.white;  
  static Color colorNegro = Colors.black; 
  static Color colorCelesteClaro1 = const Color.fromARGB(255, 217, 231, 250); 
  static Color colorCelesteClaro2 = const Color.fromARGB(255, 236, 243, 252);
  // static Color colorAzulClaro = const Color.fromARGB(255, 50, 132, 255); 
  static Color colorRojo = Colors.red; 

  static Icon estiloIcon({required IconData icon, Color? color, double? size}) {
    return Icon(
      icon, 
      size: size, 
      color: color
    );
  } 

  static AppBar estiloAppbar({Color? backgroundColor, bool? leadingbool = true, Widget? leading, Widget? title, bool? centerTitle, List<Widget>? actions, PreferredSizeWidget? bottom}) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Theme.of(Get.context!).appBarTheme.backgroundColor,
      leading: leadingbool == true ? (leading ?? IconButton(
        icon: estiloIcon(icon: Icons.arrow_back, color: Theme.of(Get.context!).appBarTheme.foregroundColor, size: 25),
        onPressed: () => Get.back()
      )) : null,
      title: title,      
      actions: actions,
      bottom: bottom,
    );
  }

  static ElevatedButton btnElevatedButton({required VoidCallback onPressed, Widget? child, VoidCallback? onLongPress,
    FocusNode? focusNode, double? borderRadius, Color? backgroundColor, Color? hoverColor, Color? colorPressed, Size? minimumSize, String? label,
    double? fontlabel, Color? colorlabel, Color? colorlabelpressed, Widget? icon,
  }) {
    return ElevatedButton.icon(
      onPressed: () => Future.delayed(const Duration(milliseconds: 0), () => onPressed()),
      onLongPress: onLongPress,
      focusNode: focusNode,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        minimumSize: minimumSize,
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor ?? colorceleste,
        foregroundColor: colorceleste,
        elevation: 5,
        shadowColor: Colors.black, // Color de la sombra del botón
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return hoverColor ?? colorCelesteClaro2.withOpacity(0.2);
            } else if (states.contains(MaterialState.pressed)) {
              return colorPressed?.withOpacity(0.5) ?? colorceleste.withOpacity(0.5);
            }
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return TextStyle(
                color: colorlabel ?? Colors.blueAccent, // Cambia el color del texto al pasar el cursor
                fontSize: fontlabel ?? 18,
              );
            } else if (states.contains(MaterialState.pressed)) {
              return TextStyle(
                color: colorlabelpressed ?? Colors.white, // Asegúrate de que este color contraste con colorPressed
                fontSize: fontlabel ?? 18,
              );
            }
            return TextStyle(
              color: colorlabel ?? colorBlanco, // Color predeterminado del texto
              fontSize: fontlabel ?? 18,
            );
          },
        ),
      ),
      icon: icon,
      label: child ?? textTitulo( mensaje: label ?? "Botón",  negitra: true, fontSize: fontlabel ?? 18, colorTexto: colorlabel ?? colorBlanco ),
    );
  }

  static Card estiloCard({required Widget child, BuildContext? context, Color? colorFondo, Color? colorBorde, Color? shadowColor, double? elevation, double? margin, double? borderRadius}){
    return Card.filled(
      // margin: EdgeInsets.all(margin ?? 0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorBorde ?? Theme.of(Get.context!).appBarTheme.backgroundColor!, width: 2.0),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      elevation: elevation,
      shadowColor: shadowColor ?? Theme.of(Get.context!).appBarTheme.backgroundColor!,
      color: colorFondo ?? colorBlanco,
      child: child,
    );
  }

  static Obx texFormField({
    required TextEditingController controller, 
    String? labelText, 
    String? hintext, 
    Color? colorhintext, 
    RxBool? enable, 
    FocusNode? focusNode,     
    bool? readOnly, 
    double? fontsize, 
    TextInputType? keyboard, 
    Function(String)? validator, 
    Color? colorBorderSide,
    Widget? prefixIcon, 
    Rx<Widget>? suffixIcon, // ⬅️ Cambiado para que sea reactivo
    String? errorText, 
    String? initialValue,
    RxBool? rxboolText, 
    RxBool? obscureText, // ⬅️ Ahora obscureText es RxBool
    String? obscuringCharacter,  
    int? maxLength, 
    int? multilinea, 
    Function(String)? onChanged
  }) {
    return Obx(() {
      final validObscuringCharacter = (obscuringCharacter != null && obscuringCharacter.length == 1) ? obscuringCharacter : '•';
      return TextFormField(
        enabled: enable == null ? true : enable.value,
        focusNode: focusNode ?? FocusNode(),
        controller: controller,
        readOnly: readOnly ?? false, 
        initialValue: initialValue,     
        style: TextStyle(
          color: rxboolText!.value ? Theme.of(Get.context!).colorScheme.error : Theme.of(Get.context!).colorScheme.onBackground,
          fontSize: fontsize ?? 14,
        ),
        keyboardType: keyboard,
        validator: validator != null ? (value) => validator(value ?? '') : null, 
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon?.value,
          label: Text(labelText ?? '', style: TextStyle(color: rxboolText.value ? Theme.of(Get.context!).colorScheme.error : Theme.of(Get.context!).colorScheme.onBackground, fontSize: fontsize ?? 14)),
          hintText: hintext,
          hintStyle: TextStyle(color: hintext != null ? colorhintext ?? Theme.of(Get.context!).colorScheme.onBackground : Theme.of(Get.context!).colorScheme.onBackground, fontSize: fontsize ?? 16),
          border: OutlineInputBorder(
            borderSide: BorderSide( color: rxboolText.value ? Theme.of(Get.context!).colorScheme.error : (colorBorderSide ?? Theme.of(Get.context!).colorScheme.primaryContainer), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: rxboolText.value == true ? Theme.of(Get.context!).colorScheme.error : (colorBorderSide ?? Theme.of(Get.context!).colorScheme.primaryContainer), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: rxboolText.value == true ? Theme.of(Get.context!).colorScheme.error : (colorBorderSide ?? Theme.of(Get.context!).colorScheme.primaryContainer), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(Get.context!).colorScheme.error),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(Get.context!).colorScheme.error),
            borderRadius: BorderRadius.circular(10),
          ),
          errorText: errorText, // Ajustado para mostrar el texto de error
        ),       
        // decoration: InputDecoration(
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        //   prefixIcon: prefixIcon,
        //   suffixIcon: suffixIcon?.value, // ⬅️ Ahora el suffixIcon es reactivo
        //   label: Text(labelText ?? '', style: TextStyle(color: rxboolText.value ? colorRojo : colorNegro, fontSize: fontsize ?? 14)),
        //   hintText: hintext,
        //   hintStyle: TextStyle(color: hintext != null ? colorhintext ?? colorNegro : colorNegro, fontSize: fontsize ?? 16),
        //   border: OutlineInputBorder(
        //     borderSide: BorderSide( color: rxboolText.value ? colorRojo : (colorBorderSide ?? colorceleste), width: 2.0),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: rxboolText.value == true ? colorRojo : (colorBorderSide ?? colorceleste), width: 2.0),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: rxboolText.value == true ? colorRojo : (colorBorderSide ?? colorceleste), width: 2.0),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   errorBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: colorRojo),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   focusedErrorBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: colorRojo),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   errorText: errorText, 
        // ),        
        maxLines: multilinea ?? 1,
        keyboardAppearance: Brightness.dark,
        maxLength: maxLength,
        obscureText: obscureText?.value ?? false, // ⬅️ Ahora obscureText es reactivo
        obscuringCharacter: validObscuringCharacter,
        onChanged: onChanged ?? (value) {},
        inputFormatters: null,
      );
    });
  }


  static Text textTitulo({required String mensaje, TextAlign? textAlign, Color? colorTexto, double? fontSize, int? maxlines, TextOverflow? textOverflow, bool? negitra, String? fontFamily, Color? background}) {
    return Text(
      mensaje, 
      textAlign: textAlign, 
      style: TextStyle( 
        backgroundColor: background,
        fontSize: fontSize ?? 14, 
        fontFamily: fontFamily ?? "Poppins", 
        color: colorTexto, 
        fontWeight: negitra == false ? FontWeight.normal : FontWeight.bold,
      ),
      maxLines: maxlines, 
      overflow: textOverflow ?? TextOverflow.ellipsis,
    );
  }

  static Text textSubTitulo({required String mensaje, TextAlign? textAlign, Color? colorTexto, double? fontSize, int? maxlines, TextOverflow? textOverflow, bool? negitra = false, String? fontFamily, Color? background}) {
    return Text(
      mensaje, 
      textAlign: textAlign, 
      style: TextStyle( 
        backgroundColor: background,
        fontSize: fontSize ?? 12, 
        fontFamily: fontFamily ?? "Poppins", 
        color: colorTexto, 
        fontWeight: negitra == false ? FontWeight.normal : FontWeight.bold,
      ),
      maxLines: maxlines, 
      overflow: textOverflow ?? TextOverflow.ellipsis,
    );
  }

  static Widget shimmerGridViewProgress(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      loop: 100,
      period: const Duration(milliseconds: 800),
      baseColor: isDark ? Colors.white12 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.white24 : Colors.grey.shade100,
      child: 
      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas
          childAspectRatio: 2/3, // Proporción del aspecto de cada tarjeta
          crossAxisSpacing: 10, // Espacio horizontal entre tarjetas
          mainAxisSpacing: 10, // Espacio vertical entre tarjetas
        ),
        padding: const EdgeInsets.all(10),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Style.colorBlanco,
                    ),
                    height: 50,
                    width: 50,
                    child: const Icon(Icons.person, size: 60, color: Colors.red,)
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Style.colorBlanco,
                    ),
                    height: 20,
                    width: width / 3,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Style.colorBlanco,
                    ),
                    height: 15,
                    width: width / 4,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Style.colorBlanco,
                        ),
                        height: 8,
                        width: 50,
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Style.colorBlanco,
                        ),
                        height: 8,
                        width: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          );
        
        },
      ),
    );
  }

  static Widget shimmerListViewProgress({required BuildContext context, bool? leading, bool? trailing}) {  
    var width = MediaQuery.sizeOf(context).width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      loop: 100,
      period: const Duration(milliseconds: 800),
      baseColor: isDark ? Colors.white12 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.white24 : Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: leading == true ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Style.colorBlanco
              ),
              height: 50,
              width: 50,
            ) : null,
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Style.colorBlanco,
                  ),
                  height: 8,
                  width: width / 6,
                ),
              ],
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Style.colorBlanco
              ),
              height: 8,
            ),
            trailing: trailing == true ? SizedBox(width: 55, child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Style.colorBlanco
                    ),
                    height: 8,
                    width: 50,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Style.colorBlanco
                    ),
                    height: 8,
                    width: 5,
                  ),
                ],
              ),
            ) : null,
            
          );
        },
      ),
    );
  }

  static Center widgetSinRegistro({String? titulo, String? mensaje, VoidCallback? btnnuevo, VoidCallback? btnReintentar, String? imageNetwork, Widget? imageAsset}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if(imageNetwork != null) Image.network(imageNetwork,
            loadingBuilder: (context, child, loadingProgress) => SizedBox(
              width: 150,
              height: 150,
              child: loadingProgress == null ? child : CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 100, color: Colors.red);
            },             
            width: 150, 
            height: 150, 
            fit: BoxFit.contain
          ),

          if(imageAsset != null) imageAsset,

          if(imageNetwork == null && imageAsset == null) estiloIcon(icon: Icons.search_off_sharp, color: Theme.of(Get.context!).colorScheme.onBackground, size: 100),

          //urlImagen == null ? Image.asset('assets/img/SinResultados.png', width: 100, height: 100, fit: BoxFit.cover) : Image.network(urlImagen, width: 100, height: 100, fit: BoxFit.cover),
          if(titulo != null) const SizedBox(height: 20),
          if(titulo != null) textTitulo(mensaje: titulo, fontSize: 20),
          
          if(mensaje != null) const SizedBox(height: 10),
          if(mensaje != null) Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: textSubTitulo(mensaje: mensaje, negitra: false),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
            child: Column(
              children: [
                Visibility(
                  visible: btnnuevo == null ? false : true,
                  child: SizedBox(
                    width: 200, height: 50,
                    child: btnElevatedButton(
                      onPressed: btnnuevo ?? () {}, 
                      child: textTitulo(mensaje: "Nuevo", fontSize: 16),
                      backgroundColor: colorCelesteClaro1
                    ),
                  ),
                ),
                
                const SizedBox(height: 10,),
                Visibility(
                  visible: btnReintentar == null ? false : true,
                  child: SizedBox(
                    width: 200, height: 50,
                    child: btnElevatedButton(
                      backgroundColor: colorCelesteClaro1,
                      onPressed: btnReintentar ?? () {}, 
                      label: "Reintentar"
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Center widgetNoConexion({required String mensaje, String? subTitulo, VoidCallback? btnReintentar, BuildContext? context}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          estiloIcon(icon: Icons.wifi_off, color: Theme.of(Get.context!).colorScheme.error, size: 100),  
          const SizedBox(height: 10),
          textTitulo(mensaje: mensaje),
          
          if(subTitulo != null) const SizedBox(height: 10),
          if(subTitulo != null) textSubTitulo(mensaje: subTitulo),
          
          if(btnReintentar != null) const SizedBox(height: 10),
          if(btnReintentar != null) btnElevatedButton(
            onPressed: btnReintentar, 
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue,
              ),
              child: textTitulo(mensaje: "Reintentar", colorTexto: colorBlanco),
            ),
          )
        ],
      ),
    );
  }

  static Center widgetErrorServidor({required BuildContext context, required String mensaje, String? subTitulo, VoidCallback? btnReintentar}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network("https://www.exefiles.com/images/error-icon.png", width: 100, height: 100, fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) => SizedBox(
              width: 40,
              height: 25,
              child: loadingProgress == null ? child : const CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 30, color: Colors.red);
            },
          ),
          const SizedBox(height: 20),
          textTitulo(mensaje: mensaje),

          if(subTitulo != null) const SizedBox(height: 10),          
          if(subTitulo != null) textSubTitulo(mensaje: subTitulo, maxlines: 10),
          
          const SizedBox(height: 10),
          btnElevatedButton(onPressed: btnReintentar!, label: "Reintentar", minimumSize: const Size(100, 40)),
        ],
      ),
    );
  }

  static Widget widgetError({required String mensaje, String? subTitulo, VoidCallback? btnReintentar}) {
    return Center(
      child: SingleChildScrollView(        
        child: Column(          
          mainAxisSize: MainAxisSize.min, 
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            estiloIcon(icon: Icons.error, color: Theme.of(Get.context!).colorScheme.error, size: 100),
            textTitulo(mensaje: "Error!",fontSize: 18, maxlines: 3, textAlign: TextAlign.center),
            textTitulo(mensaje: "Lamentamos los problemas, estamos trabajando para solucionarlo", fontSize: 12, maxlines: 3, textAlign: TextAlign.center),

            const SizedBox(height: 20),            
            textTitulo(mensaje: mensaje, fontSize: 14, maxlines: 3, textAlign: TextAlign.center),
            
            const SizedBox(height: 5),
            if(subTitulo != null) ExpansionTile(
              title: textTitulo(mensaje: "Toca para ver el Error", maxlines: 10),
              children: [
                textSubTitulo(mensaje: subTitulo, maxlines: 10),
              ],
            ),

            if (btnReintentar != null) btnElevatedButton(onPressed: btnReintentar, label: "Reintentar", minimumSize: const Size(100, 40)),
          ],
        ),
      ),
    );
  }
}