import '../../../config/library/import.dart';

class SearchRecolector extends SearchDelegate<String> {
  final Trecolector trecolector = Get.find<Trecolector>();
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
          trecolector.listaRecolectorBusqueda.value = [];
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        trecolector.listaRecolectorBusqueda.value = [];
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    trecolector.listaRecolectorBusqueda.value = trecolector.listaRecolector.where((element) => element.entries.any((entry) => entry.value.toString().toLowerCase().contains(query.toLowerCase()))).toList();

    return Obx(() {
      if (trecolector.listaRecolectorBusqueda.isEmpty) {
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
          itemCount: trecolector.listaRecolectorBusqueda.length,
          itemBuilder: (context, index) {
            final item = trecolector.listaRecolectorBusqueda[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item["vehiculo_foto"],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  // 📌 Indicador de carga mientras la imagen se está descargando
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Si ya cargó, muestra la imagen

                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Color de fondo mientras carga
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                          value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null, // Barra de progreso si se conoce el tamaño
                        ),
                      ),
                    );
                  },

                  // 📌 En caso de error al cargar la imagen
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.car_crash, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              title: Text(item['vehiculo_nombre'] ?? ''),
              subtitle: Text(item['vehiculo_marca'] ?? ''),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                close(context, item["id_vehiculo"].toString());
                await Get.toNamed("/detaellerecolector", arguments: item);
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
    ? trecolector.listaRecolector
    : trecolector.listaRecolector.where((element) => element.entries.any((entry) => entry.value.toString().toLowerCase().contains(query.toLowerCase()))).toList();
    
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            leading: Style.estiloIcon(icon: Icons.alarm),
            title: Style.textSubTitulo(mensaje: "${suggestion['vehiculo_nombre']} ${suggestion['vehiculo_anho_modelo']}"),
            onTap: () {
              query = suggestion['vehiculo_nombre'] ?? '';
              showResults(context); // Muestra los resultados basados en la selección.
            },
          );
        },
      ),
    );    
  }


  @override
  String get searchFieldLabel => 'Buscar Recolector...';
}
