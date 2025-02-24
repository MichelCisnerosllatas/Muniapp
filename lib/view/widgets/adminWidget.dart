import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../config/library/import.dart';

class Adminwidget {
  final UServidor tservidor = Get.find<UServidor>();
  final UUsuario uusuario = Get.find<UUsuario>();
  final Uadmin uadmin = Get.find<Uadmin>();

  Obx bodyAdmin({BuildContext? context}){
    return Obx((){
      if(tservidor.cargaprogreso.value){
        uadmin.widgetAdmin.value = !uadmin.pantallaCargadaAdmin.value ? Style.shimmerListViewProgress(context: Get.context!, leading: false, trailing:  true) : uadmin.widgetAdmin.value;
      } else if(tservidor.tipoError.value == 3){
        uadmin.widgetAdmin.value = Style.widgetNoConexion(mensaje: tservidor.mensajeTituloServidor.value, subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async {
          uadmin.pantallaCargadaAdmin.value = false;
          await Admincontroller().getAdmin();
        });
      } else if (tservidor.tipoError.value == 2){
        uadmin.widgetAdmin.value = Style.widgetErrorServidor(context: Get.context!, subTitulo: tservidor.mensajesubTituloServidor.value, mensaje: tservidor.mensajeTituloServidor.value);
      } else if (tservidor.tipoError.value == 1){
        uadmin.widgetAdmin.value = Style.widgetError(mensaje: tservidor.mensajeTituloServidor.value,subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async => {});
      } else if (uadmin.datosetiqueta.isEmpty) {
        uadmin.widgetAdmin.value = Style.widgetSinRegistro(titulo: "No Hay Registro", mensaje: "Aqui se visualizaran los registros del personal", btnReintentar: () async {
          uadmin.pantallaCargadaAdmin.value = false;
          await Admincontroller().getAdmin();
        });
      }else{
        uadmin.widgetAdmin.value = smartRefreshAdmin();
      }
      return uadmin.widgetAdmin.value;
    });
  }

  SmartRefresher smartRefreshAdmin(){
    return SmartRefresher(
      controller: uadmin.refreshControllerAdmin.value,
      scrollController: uadmin.scrollControllerAdmin.value,
      enablePullDown: true,
      enablePullUp: true,
      enableTwoLevel: true,
      onRefresh: () async {
        tservidor.limpiarSeleccion();
        await Admincontroller().getAdmin();
        uadmin.refreshControllerAdmin.value.refreshCompleted();
      },
      header: WaterDropHeader(
        complete: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text("Completado"),
          ],
        ),
        failed: const Text("INI FAILED"),
        refresh: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeRotatingDots(
              color: Style.colorceleste,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text("Cargando..."),
          ],
        ),
        waterDropColor: Style.colorceleste,
      ),
      footer: CustomFooter(
        height: 100,
        loadStyle: LoadStyle.ShowAlways,
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Style.textTitulo(mensaje: "Tire hacia arriba para cargar más"),
                const SizedBox(height: 20), // Espacio adicional debajo del texto
              ],
            );
          } else if (mode == LoadStatus.loading) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.threeRotatingDots(color: Style.colorceleste, size: 20),
                    const SizedBox(width: 10),
                    Style.textTitulo(mensaje: "Espere..."),
                  ],
                ),
                const SizedBox(height: 20), // Espacio adicional debajo del indicador de carga
              ],
            );
          } else if (mode == LoadStatus.failed) {
            body = const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Load failed! Tap to retry."),
                SizedBox(height: 20), // Espacio adicional debajo del texto
              ],
            );
          } else if (mode == LoadStatus.canLoading) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 100,
                  child: Center(
                    child: Style.textTitulo(mensaje: "¿Cargar más?"),
                  ),
                ),
                const SizedBox(height: 20), // Espacio adicional debajo del texto
              ],
            );
          } else if (mode == LoadStatus.noMore) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30), // Espacio adicional debajo del texto
                Style.textTitulo(mensaje: "No hay mas Informacion", textAlign: TextAlign.center),
                
              ],
            );
            // body = Predeterminado.TextTitulo(Mensaje: "No hay más préstamos", TextAlign: TextAlign.center);
          } else {
            body = const SizedBox.shrink();
          }
          return body;
        },
      ),
      onLoading: () async {
        await Future.delayed(const Duration(seconds: 2)); 
        uadmin.refreshControllerAdmin.value.loadNoData();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 5, top: 10),
          //   child: Style.textTitulo(mensaje: Global().obtenerSaludo()),
          // ),
          
          Style.estiloCard(
            elevation: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.background,
                border: Border.all(color: Theme.of(Get.context!).appBarTheme.backgroundColor!),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(Get.context!).colorScheme.surface,
                    radius: 30,
                    child: uusuario.usuariologin['profile_picture'] == null || uusuario.usuariologin['profile_picture'].isEmpty
                    ? Builder(
                        builder: (context) {
                          List<String> palabras = uusuario.usuariologin['name'].split(' ');
                          String iniciales;

                          if (palabras.length > 1 && palabras[1].isNotEmpty) { 
                            iniciales = palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
                          } else {
                            iniciales = palabras[0].substring(0, 1);
                          }

                          return Style.textTitulo(mensaje: iniciales.toUpperCase());
                        },
                      )
                    : ClipOval(
                      child: Image.network(
                        uusuario.usuariologin['profile_picture'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, size: 30, color: Colors.grey); 
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
      
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Style.textTitulo(mensaje: Global().obtenerSaludo()),
                        const SizedBox(height: 10),
                        Style.textTitulo(mensaje: "Hola, ${uusuario.usuariologin['name'] ?? ""}"),
                        Style.textSubTitulo(mensaje: "su rol es Administrador"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      
          // Grid de Tarjetas Estadísticas
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // 2 columnas
              children: [
                Adminwidget().etiquetasCard("Vehículos Registrados", uadmin.datosetiqueta["vehiculos_registrados"].toString(), Icons.directions_bus, Colors.blueAccent),
                Adminwidget().etiquetasCard("Personal Operativo", uadmin.datosetiqueta["personal_operativo"].toString(), Icons.people, Colors.green),
                Adminwidget().etiquetasCard("Vehículos en Ruta", uadmin.datosetiqueta["vehiculos_en_ruta"].toString(), Icons.directions_car, Colors.orange),
                Adminwidget().etiquetasCard("Ciudadanos Registrados", uadmin.datosetiqueta["ciudadanos_registrados"].toString(), Icons.person, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para Tarjetas de Estadísticas
  Widget etiquetasCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Style.textTitulo(mensaje: value, fontSize: 20),
            const SizedBox(height: 5),
            Style.textSubTitulo(mensaje: title),
          ],
        ),
      ),
    );
  }
}