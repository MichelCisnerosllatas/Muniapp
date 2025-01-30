import 'package:muniapp/view/widgets/ciudadanoWidget.dart';

import '../../../config/library/import.dart';

class Ciudadanopage extends StatefulWidget {
  const Ciudadanopage({super.key});

  @override
  State<Ciudadanopage> createState() => _CiudadanopageState();
}

class _CiudadanopageState extends State<Ciudadanopage> {
  final UUsuario uusuario = Get.find<UUsuario>();
  final Uciudadano uciudadano = Get.find<Uciudadano>();

  @override
  void initState() {
    super.initState();
    Ciudadanocontroller().mostrarRutasInicioCiudadano();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: false, 
        title: Style.textTitulo(mensaje: "MuniApp", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        // actions: [
        //   Obx((){
        //     if (tubicacion.latidude.value == 0 && tubicacion.longitude.value == 0){
        //       return SizedBox.shrink();
        //     }else{
        //       return Ubicacionwidget().seleccionarEstiloComoPopupMenu();
        //     }
        //   }),
        // ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 10),
            child: Style.textTitulo(mensaje: Global().obtenerSaludo()),
          ),          

          Style.estiloCard(
            elevation: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 25,
                    child: Builder(
                      builder: (context) {
                        List<String> palabras = uusuario.usuariologin['name'].split(' ');
                        String iniciales;
            
                        if (palabras.length > 1 && palabras[1].isNotEmpty) { 
                          iniciales = palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
                        } else {
                          iniciales = palabras[0].substring(0, 1);
                        }
            
                        return Style.textTitulo(mensaje: iniciales.toUpperCase().toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Style.textTitulo(mensaje: "Hola, ${uusuario.usuariologin['name']}"),
                        Style.textSubTitulo(mensaje: "su rol es ciudadano."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Style.textTitulo(mensaje: "Tus rutas", negitra: true),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 13, right: 8, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Style.estiloIcon(icon: Icons.check_circle, size: 25, color: Colors.greenAccent),
                    Style.textSubTitulo(mensaje: "Activas: "),
                    Obx(() => Style.textTitulo(mensaje: uciudadano.listarutasCiudadanoInicio.where((ruta) => ruta["ruta_activa"] == true).length.toString())),
                  ],
                ),
            
                Row(
                  children: [
                    Style.estiloIcon(icon: Icons.check_circle, size: 25, color: Theme.of(context).colorScheme.error),
                    Style.textSubTitulo(mensaje: "Inactivas: "),
                    Obx(() => Style.textTitulo(mensaje: uciudadano.listarutasCiudadanoInicio.where((ruta) => ruta["ruta_activa"] == false).length.toString())),
                  ],
                )              
              ]
            ),
          ),
          Expanded(
            child: Ciudadanowidget().mostrarRutasCiudadanoInicio()
          )
        ],
      )
    );
  }
}