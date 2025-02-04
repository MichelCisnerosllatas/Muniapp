import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../config/library/import.dart';

class Historialrutaschoferwidget {
  final UServidor tservidor = Get.find<UServidor>();
  final Uchofer uchofer = Get.find<Uchofer>();


  Widget bodyHostiorialChofer({required Map<String, dynamic> datos}){
    return Obx((){
      if(tservidor.cargaprogreso.value){
        uchofer.widgetHistorialRutasChofer.value = !uchofer.pantallaCargadaHistorialRutasChofer.value ? Style.shimmerListViewProgress(context: Get.context!, leading: true, trailing:  true) : uchofer.widgetHistorialRutasChofer.value;
      } else if(tservidor.tipoError.value == 3){
        uchofer.widgetHistorialRutasChofer.value = Style.widgetNoConexion(mensaje: tservidor.mensajeTituloServidor.value, subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async {
          uchofer.pantallaCargadaHistorialRutasChofer.value = false;
          await Chofercontroller().listarHistorialRutasChofers();
        });
      } else if (tservidor.tipoError.value == 2){
        uchofer.widgetHistorialRutasChofer.value = Style.widgetErrorServidor(context: Get.context!, subTitulo: tservidor.mensajesubTituloServidor.value, mensaje: tservidor.mensajeTituloServidor.value);
      } else if (tservidor.tipoError.value == 1){
        uchofer.widgetHistorialRutasChofer.value = Style.widgetError(mensaje: tservidor.mensajeTituloServidor.value,subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async => {});
      } else if (uchofer.listaHistorialRutasChofer.isEmpty) {
        uchofer.widgetHistorialRutasChofer.value = Style.widgetSinRegistro(titulo: "No Hay Registro", mensaje: "Aqui se visualizaran los registros de las Unidades Recolectoras", btnReintentar: () async {
          uchofer.pantallaCargadaHistorialRutasChofer.value = false;
          await Chofercontroller().listarHistorialRutasChofers();
        });
      }else{
        uchofer.widgetHistorialRutasChofer.value = smartRefreshHostiorialRutasChofer(seleccionado: tservidor.seleccionado.value, listRecolector: uchofer.listaHistorialRutasChofer, parametros: datos);
      }
      return uchofer.widgetHistorialRutasChofer.value;
    });
  }

  SmartRefresher smartRefreshHostiorialRutasChofer({required bool seleccionado, required dynamic listRecolector, required Map<String, dynamic> parametros}){
    return SmartRefresher(
      controller: uchofer.refreshControllerHistorialRutasChofer.value,
      scrollController: uchofer.scrollControllerHistorialRutasChofer.value,
      enablePullDown: !seleccionado ? true : false,
      enablePullUp: !seleccionado ? true : false,
      enableTwoLevel: !seleccionado ? true : false,
      onRefresh: () async {
        tservidor.limpiarSeleccion();
        await Future.delayed(const Duration(seconds: 1));
        uchofer.refreshControllerHistorialRutasChofer.value.refreshCompleted();
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
                Style.textTitulo(mensaje: "No hay mas Registros", textAlign: TextAlign.center),
                
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
        uchofer.refreshControllerHistorialRutasChofer.value.loadNoData();
      },
      child: listViewbuilderHistorialRutasChofer(rxHistorialRutasChoferLista: listRecolector, datos: parametros),
    );
  }

  Widget listViewbuilderHistorialRutasChofer({required dynamic rxHistorialRutasChoferLista, Map<String, dynamic>? datos}){
    return ListView.builder(
      controller: uchofer.scrollControllerHistorialRutasChofer.value,
      itemCount: rxHistorialRutasChoferLista.length,
      itemBuilder: (context, index) {
        return ListTile(
          style: ListTileStyle.list,
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Container( width: 40, height: 40,
            decoration: BoxDecoration(
              // color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.car_crash),
          ),
          title: Style.textTitulo(mensaje: "${rxHistorialRutasChoferLista[index]["vehiculo_nombre"]} -> ${rxHistorialRutasChoferLista[index]["ruta_nombre"]}"),	
          subtitle: Column(
            children: [
              Row(
                children: [
                  Style.textSubTitulo(mensaje: "Inciado: "),
                  Style.textSubTitulo(mensaje: Global().formatearFecha(rxHistorialRutasChoferLista[index]["inicio_ruta_fecha_inicio"].toString())),
                ],
              ),

              Row(
                children: [
                  Style.textSubTitulo(mensaje: "Terminado: "),
                  Style.textSubTitulo(mensaje: Global().formatearFecha(rxHistorialRutasChoferLista[index]["inicio_ruta_fecha_fin"].toString())),

                ],
              ),
            ],
          ),
        );
      }
    );
  }
}