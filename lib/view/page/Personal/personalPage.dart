import '../../../config/library/import.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    super.initState();
    Personalcontroller().initStatePersonal();
    Personalcontroller().listarPersonal(datos: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: false, 
        title: Style.textTitulo(mensaje: "Personal", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: SearchPersonal());
            }, 
            icon: Icon(Icons.search)
          )
        ]
      ),
      body: Personalwidjet().bodyPersonal(datos: {})
    );
  }
}