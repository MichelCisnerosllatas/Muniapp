import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'config/library/import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  await GetStorage.init();
  iniciarControladoresGetx();

  final storage = GetStorage();
  String initialRoute = storage.read('loginData') != null ? '/principal' : '/';
  if(storage.read('loginData') != null){
    Get.find<UUsuario>().usuariologin.value = storage.read('loginData');
  }  

  // Leer el tema guardado o usar el sistema por defecto
  Get.find<Themecontroller>().seleccionarTema(storage: storage);
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String? initialRoute;

  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(Tubicacion.tokenMapBox);
    
    return SafeArea(
      child: Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MuniApp',
        initialRoute: initialRoute,
        getPages: rutas,
        theme: Get.find<Themecontroller>().currentThemeData.value, // Tema actual
        darkTheme: TemasPerzonalizado.temaOscuro, // Tema oscuro
        themeMode: Get.find<Themecontroller>().currentThemeMode.value, // Observar cambios de tema
      )),
    );
  }
}


void iniciarControladoresGetx() {
  Get.put(Trecolector());
  Get.put(UUsuario());
  Get.put(Ttemas());
  Get.put(Tubicacion());
  Get.put(UPersonal());
  Get.put(UServidor());
  Get.put(Urutas());
  Get.put(Unavegacion());
  Get.put(Uciudadano());
  Get.put(Uadmin());

  Get.put(Notificacioncontroller());
  Get.put(Personalcontroller());
  Get.put(Recolectorcontroler());
  Get.put(Themecontroller());
  Get.put(Ubicacioncontroller());
  Get.put(Chofercontroller());
  Get.put(Navegcioncontroller());
  Get.put(Ciudadanocontroller());
  Get.put(Admincontroller());

  Get.put(Recolectormodel());
  Get.put(Ubicacionmodel());
  Get.put(Usuariomodel());
  Get.put(Personalmodel());  
}