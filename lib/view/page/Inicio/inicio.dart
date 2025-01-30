import 'package:muniapp/view/widgets/inicioWidget.dart';

import '../../../config/library/import.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final Tubicacion tubicacion = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: false, 
        title: Style.textTitulo(mensaje: "MuniApp", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        actions: [
          Obx((){
            if (tubicacion.latidude.value == 0 && tubicacion.longitude.value == 0){
              return SizedBox.shrink();
            }else{
              return Ubicacionwidget().seleccionarEstiloComoPopupMenu();
            }
          }),
          
          // PopupMenuButton(
          //   icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onPrimary),
          //   itemBuilder:(context) {
          //     return [
          //       PopupMenuItem(
          //         child: Text("show location"),
          //         onTap: () async => await Ubicacioncontroller().mostrarLocalizacionEnMapa(),
          //       ),

          //       PopupMenuItem(
          //         child: Text("location bearing"),
          //         onTap: () async => await Ubicacioncontroller().mostrarFelchaGuia(),
          //       ),

          //       PopupMenuItem(
          //         child: Text("show pulsing"),
          //         onTap: () async => await Ubicacioncontroller().mostrarPulsaciones(),
          //       )
          //     ];
          //   },
          // )
        ]
      ),
      body: Iniciowidget().tabController3Roles(context: context)
    );
  }
}