// import 'package:flutter/cupertino.dart';
import '../../../config/library/import.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {  
  final Uadmin uadmin = Get.find<Uadmin>();

  @override
  void initState() {
    super.initState();
    Admincontroller().getAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(leadingbool: false, title: Style.textTitulo(mensaje: "MuniApp", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: Adminwidget().bodyAdmin(),
    );
  }
}