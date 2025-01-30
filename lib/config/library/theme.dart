import '../library/import.dart';

class TemasPerzonalizado {
  static final ThemeMode temaSistema = ThemeMode.system; 

  static final ThemeData temaClaro = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Style.colorceleste,
      foregroundColor: Style.colorBlanco,
      iconTheme: IconThemeData(color: Style.colorBlanco),
      actionsIconTheme: IconThemeData(color: Style.colorBlanco),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Color de fondo
        foregroundColor: Colors.white, // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue, // Color del texto
        side: BorderSide(color: Colors.blue),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue, // Color del texto
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Style.colorNegro, // Color del cursor
      selectionColor: const Color.fromARGB(255, 152, 193, 255),
      selectionHandleColor: const Color.fromARGB(255, 55, 55, 55)
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Style.colorBlanco,
      selectedItemColor: Style.colorceleste, // Contraste con el fondo claro
      selectedLabelStyle: TextStyle(color: Style.colorceleste),
      unselectedLabelStyle: TextStyle(color: Colors.black12),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      type: BottomNavigationBarType.shifting,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      background: Style.colorBlanco,
      onBackground: Style.colorNegro,
      primary: Style.colorBlanco,
      onPrimary: Style.colorNegro,
      secondary: Style.colorCelesteClaro1,
      onSecondary: Style.colorCelesteClaro2,
      error: Style.colorRojo,
      surface: Colors.grey[200]!,
      seedColor: Colors.blue,
      onError: Style.colorRojo,
    ),
    useMaterial3: true,
  );

  static final ThemeData temaOscuro = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Style.colorceleste,
      foregroundColor: Style.colorBlanco,
      iconTheme: IconThemeData(color: Style.colorBlanco),
      actionsIconTheme: IconThemeData(color: Style.colorBlanco),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Color de fondo
        foregroundColor: Colors.white, // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue, // Color del texto
        side: BorderSide(color: Colors.blue),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue, // Color del texto
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true, // Mostrar etiquetas seleccionadas
      showUnselectedLabels: true, // Mostrar etiquetas no seleccionadas      
      backgroundColor: Style.colorNegro, // Fondo oscuro
      selectedItemColor: Style.colorCelesteClaro1, // Color del ícono seleccionado
      unselectedItemColor: Colors.grey, // Color del ícono no seleccionado
      
      // Estilo de las etiquetas seleccionadas
      selectedLabelStyle: TextStyle(color: Style.colorCelesteClaro1, fontWeight: FontWeight.bold, fontSize: 12),
      
      // Estilo de las etiquetas no seleccionadas
      unselectedLabelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontWeight: FontWeight.normal,
      ),
      type: BottomNavigationBarType.shifting, // Fijo, sin animaciones
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Style.colorNegro,
      iconColor: Style.colorCelesteClaro1,
      textColor:  Style.colorBlanco,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness : Brightness.dark,
      background: Style.colorNegro,
      onBackground: Style.colorBlanco,
      primary: Style.colorNegro,
      onPrimary: Style.colorBlanco, //Para botones flotantes
      secondary: const Color.fromARGB(255, 7, 34, 56),
      onSecondary: Style.colorCelesteClaro2,
      error: Style.colorRojo,
      surface: Colors.grey[200]!,
      seedColor: Colors.blue,
      onError: Style.colorRojo,
    ),
    useMaterial3: true,
  );

  static final ThemeData temaRosa = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink,
      foregroundColor: Style.colorBlanco,
      iconTheme: IconThemeData(color: Style.colorBlanco),
      actionsIconTheme: IconThemeData(color: Style.colorBlanco),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink, // Color de fondo
        foregroundColor: Colors.white, // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, // Color del texto
        side: BorderSide(color: Colors.pink),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.pink, // Color del texto
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true, // Mostrar etiquetas seleccionadas
      showUnselectedLabels: true, // Mostrar etiquetas no seleccionadas      
      backgroundColor: Colors.pink, // Fondo oscuro
      selectedItemColor: const Color.fromARGB(255, 178, 0, 59), // Color del ícono seleccionado
      unselectedItemColor: Style.colorBlanco, // Color del ícono no seleccionado
      
      // Estilo de las etiquetas seleccionadas
      selectedLabelStyle: TextStyle(color: const Color.fromARGB(255, 178, 0, 59), fontWeight: FontWeight.bold, fontSize: 12),
      
      // Estilo de las etiquetas no seleccionadas
      unselectedLabelStyle: TextStyle(
        color: Style.colorBlanco,
        fontSize: 11,
        fontWeight: FontWeight.normal,
      ),
      type: BottomNavigationBarType.shifting, // Fijo, sin animaciones
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness : Brightness.light,
      background: const Color.fromARGB(255, 248, 113, 158),
      onBackground: Style.colorNegro,
      primary: Style.colorBlanco,
      onPrimary: Style.colorBlanco,
      secondary: Style.colorCelesteClaro1,
      onSecondary: Style.colorCelesteClaro2,
      error: Style.colorRojo,
      surface: Colors.grey[200]!,
      seedColor: Colors.blue,
      onError: Style.colorRojo,
    ),
    useMaterial3: true,
  );

  static final ThemeData temaVerde = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
  );
}