import 'package:muniapp/view/widgets/choferWidget.dart';

import '../../../config/library/import.dart';

class Detallehistorialrutapage extends StatefulWidget {
  const Detallehistorialrutapage({super.key});

  @override
  State<Detallehistorialrutapage> createState() => _DetallehistorialrutapageState();
}

class _DetallehistorialrutapageState extends State<Detallehistorialrutapage> {
  @override
  void initState() {
    super.initState();
    Chofercontroller().obtenerdetallerutaChoferHistorial(parametros: Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(title: Style.textTitulo(mensaje: "Detalle de la ruta", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: Column(
        children: [
          if(Get.arguments["inicio_ruta_observacion"] != null) Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Style.textTitulo(mensaje: "Observacion de la Ruta"),
                  Style.textSubTitulo(mensaje: Get.arguments["inicio_ruta_observacion"] ?? "hol")
                ],
              ),
            ),
          ),

          Expanded(
            child: Choferwidget().mapaDetalleHistorialRutasChofer(data: {})
          )
        ],
      ),
    );
  }
}