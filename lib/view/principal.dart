import '../config/library/import.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int indece = 0;
  List<Widget> pantallasWidgets = [];
  List<BottomNavigationBarItem> items = [];
  final UUsuario uusuario = Get.find<UUsuario>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Asegurar que se ejecuta después de que la pantalla haya sido construida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pantallarol();
    });
  }

  void pantallarol() {
    if (uusuario.usuariologin["id_rol"] == null) {
      Global().modalErrorShowDialog(context: context, mensaje: "No se ha iniciado sesión.");
      return;
    }

    setState(() {
      if (uusuario.usuariologin["id_rol"] == 1) {
        pantallasWidgets = [
          Adminpage(),
          RecolectorPage(),
          PersonalPage(),
          Vermas()
        ];

        items = [
          BottomNavigationBarItem(
            label: "inicio",
            icon: Icon(Icons.home, size: 20),
            activeIcon: Icon(Icons.home, size: 25, color: Theme.of(context).appBarTheme.backgroundColor)
          ),
          BottomNavigationBarItem(
            label: "vehículo",
            icon: Icon(Icons.car_crash_sharp, size: 20),
          ),
          BottomNavigationBarItem(
            label: "personal",
            icon: Icon(Icons.person_2, size: 20),
          ),
          BottomNavigationBarItem(
            label: "más",
            icon: Icon(Icons.masks, size: 20),
          )
        ];
      } else if (uusuario.usuariologin["id_rol"] == 2) {
        pantallasWidgets = [
          Choferpage(),
          Historiarutaspage(),
          Vermas()
        ];

        items = [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: Icon(Icons.home, size: 20),
            activeIcon: Icon(Icons.home, size: 25, color: Theme.of(context).appBarTheme.backgroundColor)
          ),
          BottomNavigationBarItem(
            label: "Mis Rutas",
            icon: Icon(Icons.history, size: 20),
            activeIcon: Icon(Icons.history, size: 25, color: Theme.of(context).appBarTheme.backgroundColor)
          ),
          BottomNavigationBarItem(
            label: "Más",
            icon: Icon(Icons.masks, size: 20),
          )
        ];
      } else if (uusuario.usuariologin["id_rol"] == 3) {
        pantallasWidgets = [
          Ciudadanopage(),
          Vermas()
        ];

        items = [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: Icon(Icons.home, size: 20),
            activeIcon: Icon(Icons.home, size: 25, color: Theme.of(context).appBarTheme.backgroundColor)
          ),
          BottomNavigationBarItem(
            label: "Más",
            icon: Icon(Icons.masks, size: 20),
          )
        ];
      }
    });
  }

  void cambiarPantalla(int index) {
    setState(() {
      indece = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pantallasWidgets.isNotEmpty ? pantallasWidgets[indece] : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: pantallasWidgets.isNotEmpty ? BottomNavigationBar(
        currentIndex: indece,
        items: items,
        onTap: (index) => cambiarPantalla(index),
        type: BottomNavigationBarType.fixed,
      )
      : null,
    );
  }
}
