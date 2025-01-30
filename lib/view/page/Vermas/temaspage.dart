import '../../../config/library/import.dart';

class Temaspage extends StatefulWidget {
  const Temaspage({super.key});

  @override
  State<Temaspage> createState() => _TemaspageState();
}

class _TemaspageState extends State<Temaspage> {
  final themeController = Get.find<Themecontroller>();
  final storage = GetStorage();

  final List<Map<String, String>> themes = [
    {'value': 'system', 'label': 'Sistema'},
    {'value': 'light', 'label': 'Claro'},
    {'value': 'dark', 'label': 'Oscuro'},
    {'value': 'pink', 'label': 'Rosa'},
    {'value': 'green', 'label': 'Verde'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(title: Style.textTitulo(mensaje: "Temas", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          return Obx(() => ListTile(
            title: Text(themes[index]['label']!),
            trailing: themeController.currentThemeIndex.value == index ? const Icon(Icons.check_box) : null,
            onTap: () => themeController.seleccionarTema(storage: storage, tema: themes[index]['value']),
          ));
        },
      )
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       DropdownButton<String>(
      //         value: storage.read('tema') ?? 'light', // Tema actual
      //         items: [
      //           DropdownMenuItem(value: 'light', child: Text('Tema Claro')),
      //           DropdownMenuItem(value: 'dark', child: Text('Tema Oscuro')),
      //           DropdownMenuItem(value: 'pink', child: Text('Tema Rosa')),
      //           DropdownMenuItem(value: 'green', child: Text('Tema Verde')),
      //           DropdownMenuItem(value: 'system', child: Text('Sistema')),
      //         ],
      //         onChanged: (String? value) {
      //           if (value != null) {
      //             themeController.seleccionarTema(storage: storage, tema: value);
      //           }
      //         },
      //       ),

      //       PopupMenuButton<String>(
      //         onSelected: (String value) {
      //           final themeController = Get.find<Themecontroller>();
      //           themeController.seleccionarTema(storage: GetStorage(), tema: value);
      //         },
      //         itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      //           const PopupMenuItem<String>(
      //             value: 'system',
      //             child: Text('Sistema'),
      //           ),
      //           const PopupMenuItem<String>(
      //             value: 'light',
      //             child: Text('Claro'),
      //           ),
      //           const PopupMenuItem<String>(
      //             value: 'dark',
      //             child: Text('Oscuro'),
      //           ),
      //           const PopupMenuItem<String>(
      //             value: 'pink',
      //             child: Text('Rosa'),
      //           ),
      //           const PopupMenuItem<String>(
      //             value: 'green',
      //             child: Text('Verde'),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // )
    );
  }
}