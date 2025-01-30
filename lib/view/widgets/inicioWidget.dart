import '../../config/library/import.dart';

class Iniciowidget { 
  final tubicacion = Get.find<Tubicacion>();

  Widget tabController3Roles({required BuildContext context}) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            backgroundColor: Colors.red,
            unselectedBackgroundColor: Colors.grey[300],
            unselectedLabelStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.admin_panel_settings),
                text: "Administrador",
              ),
              Tab(
                icon: Icon(Icons.emoji_people_outlined),
                text: "Trabajador",
              ),
              Tab(
                icon: Icon(Icons.directions_car),
                text: "Conductor",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(), // Desactiva los gestos de desplazamiento
              children: <Widget>[                
                Adminpage(),                 
                Ciudadanopage(),
                Choferpage()
              ],
            ),
          )
          
          // Expanded(
          //   child: NotificationListener<ScrollNotification>(
          //     onNotification: (notification) {
          //       // Previene el desplazamiento entre tabs
          //       return true;
          //     },
          //     child: TabBarView(
          //       physics: NeverScrollableScrollPhysics(), // Desactiva los gestos de desplazamiento
          //       children: <Widget>[                
          //         Center(
          //           child: Style.textTitulo(mensaje: "Administrador")
          //         ),                  
          //         Trabajadorpage(),
          //         Choferpage()
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget tabController3Roles1({required BuildContext context}) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            backgroundColor: Colors.red,
            unselectedBackgroundColor: Colors.grey[300],
            unselectedLabelStyle: TextStyle(color: Colors.black),
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: Icon(Icons.admin_panel_settings),
                text: "Adminsitrador",
              ),
              Tab(
                icon: Icon(Icons.emoji_people_outlined),
                text: "Trabajador",
              ),
              Tab(icon: Icon(Icons.directions_car), text: "Conductor"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                Obx(() {
                  if(tubicacion.cargarLocalizar.value){
                    return Center( child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.onPrimary, size: 25));
                  } else if(tubicacion.latidude.value == 0 && tubicacion.longitude.value == 0){
                    return Center( child: Icon(Icons.directions_transit));
                  } else{
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Ubicacionwidget().mostrarMapa(latitude: tubicacion.latidude.value, longitude: tubicacion.longitude.value)
                    );
                  }
                }),

                Center(
                  child: Icon(Icons.directions_transit),
                ),
                Center(
                  child: Icon(Icons.directions_bike),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}