import 'package:muniapp/view/widgets/choferWidget.dart';

import '../../../config/library/import.dart';

class Historiarutaspage extends StatefulWidget {
  const Historiarutaspage({super.key});

  @override
  State<Historiarutaspage> createState() => _HistoriarutaspageState();
}

class _HistoriarutaspageState extends State<Historiarutaspage> {
  @override
  void initState(){
    super.initState();
    Chofercontroller().listarHistorialRutasChofers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(leadingbool: false, title: Style.textTitulo(mensaje: "Historial de Rutas", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: Choferwidget().bodyHostiorialChofer(datos: {})
    );
  }
}