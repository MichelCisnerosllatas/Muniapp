import '../config/library/import.dart';

class Themecontroller extends GetxController {
  RxInt currentThemeIndex = 0.obs;
  Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;
  Rx<ThemeData> currentThemeData = TemasPerzonalizado.temaClaro.obs;

  void seleccionarTema({required GetStorage storage, String? tema}) {
    // final temaSeleccionado = tema ?? (storage.read('tema') ?? 'system');
    final temaSeleccionado = tema ?? (storage.read('tema')?.toString() ?? 'system');
    
    if (temaSeleccionado == 'system') {
      currentThemeIndex.value = 0;
      currentThemeMode.value = ThemeMode.system;
    } else if (temaSeleccionado == 'light') {
      currentThemeIndex.value = 1;
      currentThemeMode.value = ThemeMode.light;
      currentThemeData.value = TemasPerzonalizado.temaClaro;
    } else if (temaSeleccionado == 'dark') {
      currentThemeIndex.value = 2;
      currentThemeMode.value = ThemeMode.dark;
      currentThemeData.value = TemasPerzonalizado.temaOscuro;
    } else if (temaSeleccionado == 'pink') {
      currentThemeIndex.value = 3;
      currentThemeMode.value = ThemeMode.light;
      currentThemeData.value = TemasPerzonalizado.temaRosa;
    } else if (temaSeleccionado == 'green') {
      currentThemeIndex.value = 4;
      currentThemeMode.value = ThemeMode.light;
      currentThemeData.value = TemasPerzonalizado.temaVerde;
    }

    // Guardar el tema seleccionado
    // storage.erase(); 
    storage.write('tema', temaSeleccionado);
  }
}