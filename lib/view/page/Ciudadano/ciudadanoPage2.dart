import 'package:muniapp/view/widgets/ciudadanoWidget.dart';
import '../../../config/library/import.dart';

class Ciudadanopage2 extends StatefulWidget {
  const Ciudadanopage2({super.key});

  @override
  State<Ciudadanopage2> createState() => _Ciudadanopage2State();
}

class _Ciudadanopage2State extends State<Ciudadanopage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(leadingbool: true, title: Style.textTitulo(mensaje: Get.arguments["ruta_nombre"], fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: Column(
        children: [
          if(Get.arguments["ruta_activa"] == false) Style.estiloCard(
            colorBorde: Colors.redAccent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2), // Rojo suave con opacidad
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                border: Border.all(color: Colors.redAccent, width: 1), // Borde rojo más fuerte
              ),
              child: Column(
                children: [
                  Style.textTitulo(mensaje: "Ruta no disponible", colorTexto: Theme.of(context).colorScheme.error),
                  Style.textSubTitulo(mensaje: Get.arguments["ruta_descripcion"])
                ],
              ),
            )
          ),
          Expanded(
            child: Ciudadanowidget().mostrarMapaCiudadanoInicioPagina2(data: Get.arguments),
          ),
        ],
      ),
    );
  }
}