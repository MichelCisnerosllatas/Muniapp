import '../../../config/library/import.dart';

class SearchPersonal extends SearchDelegate<String> {
  final UPersonal tpersona = Get.find<UPersonal>();
  // final RxList<String> dataList = <String>[].obs;

  // SearchPersonal() {
  //   dataList.value = ['Flutter', 'Dart', 'GetX', 'Provider', 'Bloc'];
  // }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);

    return currentTheme.copyWith(
      appBarTheme: currentTheme.appBarTheme.copyWith(
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        foregroundColor: currentTheme.appBarTheme.foregroundColor,
        iconTheme: currentTheme.appBarTheme.iconTheme,
        actionsIconTheme: currentTheme.appBarTheme.actionsIconTheme,
      ),
      textTheme: currentTheme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        displayLarge: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
      ),
      inputDecorationTheme: currentTheme.inputDecorationTheme.copyWith(
        hintStyle: TextStyle(
          color: currentTheme.appBarTheme.foregroundColor?.withOpacity(0.6), // Color del texto de "Buscar..."
          fontSize: 16,
        ),
        errorStyle: currentTheme.inputDecorationTheme.errorStyle?.copyWith(
          color: currentTheme.colorScheme.error,
        ),
      )
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          tpersona.listaPersonalBusqueda.value = [];
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        tpersona.listaPersonalBusqueda.value = [];
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    tpersona.listaPersonalBusqueda.value = tpersona.listaPersonal.where((element) =>
        element.entries.any((entry) => entry.value.toString().toLowerCase().contains(query.toLowerCase()))).toList();


    return Obx(() {
      if (tpersona.listaPersonalBusqueda.isEmpty) {
        return Container(
          color: Theme.of(context).colorScheme.background, // Fondo dinámico según el tema
          child: const Center(
            child: Text("No se encontraron resultados"),
          ),
        );
      }
      return Container(
        color: Theme.of(context).colorScheme.background, // Fondo dinámico
        child: ListView.builder(
          itemCount: tpersona.listaPersonalBusqueda.length,
          itemBuilder: (context, index) {
            final item = tpersona.listaPersonalBusqueda[index];
            return ListTile(
              title: Text(item['personal_nombre'] ?? ''),
              subtitle: Text(item['personal_email'] ?? ''),
              onTap: () {
                close(context, item["id_personal"].toString());
              },
            );
          },
        ),
      );
    });
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty 
    ? tpersona.listaPersonal
    : tpersona.listaPersonal.where((element) => element.entries.any((entry) => entry.value.toString().toLowerCase().contains(query.toLowerCase()))).toList();
    
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text("${suggestion['personal_nombre']} ${suggestion['personal_apellido_paterno']}", 
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            onTap: () {
              query = suggestion['personal_nombre'] ?? '';
              showResults(context); // Muestra los resultados basados en la selección.
            },
          );
        },
      ),
    );    
  }


  @override
  String get searchFieldLabel => 'Buscar...';
}
