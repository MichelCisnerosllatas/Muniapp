import '../../../config/library/import.dart';

class RecolectorPage extends StatefulWidget {
  const RecolectorPage({super.key});

  @override
  State<RecolectorPage> createState() => _RecolectorPageState();
}

class _RecolectorPageState extends State<RecolectorPage> {
  final UServidor tservidor = Get.find<UServidor>();
  final Trecolector trecolector = Get.find<Trecolector>();

  @override
  void initState() {
    super.initState();
    Recolectorcontroler().initStateRecolector();
    Recolectorcontroler().listarRecolector(datos: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: false, 
        title: Style.textTitulo(mensaje: "Unidades Recolectores", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        actions: [
          Obx(() {
            if(!tservidor.cargaprogreso.value && trecolector.listaRecolector.isNotEmpty){
              return IconButton(
                onPressed: () => showSearch(context: context, delegate: SearchRecolector()),
                icon: Icon(Icons.search)
              );
            }else{
              return SizedBox.shrink();
            }
          })
        ]
      ),
      body: Recolectorwidget().bodyRecolector(datos: {})
    );
  }
}