import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../config/library/import.dart';

class Recolectorwidget {
  final UServidor tservidor = Get.find<UServidor>();
  final Trecolector trecolector = Get.find<Trecolector>();

  Widget bodyRecolector({required Map<String, dynamic> datos}){
    return Obx((){
      if(tservidor.cargaprogreso.value){
        trecolector.widgetRecolector.value = !trecolector.pantallaCargadaRecolector.value ? Style.shimmerListViewProgress(context: Get.context!, leading: true, trailing:  true) : trecolector.widgetRecolector.value;
      } else if(tservidor.tipoError.value == 3){
        trecolector.widgetRecolector.value = Style.widgetNoConexion(mensaje: tservidor.mensajeTituloServidor.value, subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async {
          trecolector.pantallaCargadaRecolector.value = false;
          // Funcionprestamo().listarPrestamoCliente(datos: datos);
        });
      } else if (tservidor.tipoError.value == 2){
        trecolector.widgetRecolector.value = Style.widgetErrorServidor(context: Get.context!, subTitulo: tservidor.mensajesubTituloServidor.value, mensaje: tservidor.mensajeTituloServidor.value);
      } else if (tservidor.tipoError.value == 1){
        trecolector.widgetRecolector.value = Style.widgetError(mensaje: tservidor.mensajeTituloServidor.value,subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async => {});
      } else if (trecolector.listaRecolector.isEmpty) {
        trecolector.widgetRecolector.value = Style.widgetSinRegistro(titulo: "No Hay Registro", mensaje: "Aqui se visualizaran los registros de las Unidades Recolectoras", btnReintentar: () async {
          trecolector.pantallaCargadaRecolector.value = false;
          await Personalcontroller().listarPersonal(datos: datos);
        });
      }else{
        trecolector.widgetRecolector.value = smartRefreshRecolector(seleccionado: tservidor.seleccionado.value, listRecolector: trecolector.listaRecolector, parametros: datos);
      }
      return trecolector.widgetRecolector.value;
    });
  }

  Widget smartRefreshRecolector({required bool seleccionado, required dynamic listRecolector, required Map<String, dynamic> parametros}){
    return SmartRefresher(
      controller: trecolector.refreshControllerRecolector.value,
      scrollController: trecolector.scrollControllerRecolector.value,
      enablePullDown: !seleccionado ? true : false,
      enablePullUp: !seleccionado ? true : false,
      enableTwoLevel: !seleccionado ? true : false,
      onRefresh: () async {
        tservidor.limpiarSeleccion();
        await Future.delayed(const Duration(seconds: 1));
        trecolector.refreshControllerRecolector.value.refreshCompleted();
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
        trecolector.refreshControllerRecolector.value.loadNoData();
      },
      child: listViewbuilderRecolector(rxPersonalLista: listRecolector, datos: parametros),
    );
  }

  Widget listViewbuilderRecolector({required dynamic rxPersonalLista, Map<String, dynamic>? datos}){
    return ListView.builder(
      controller: trecolector.scrollControllerRecolector.value,
      itemCount: rxPersonalLista.length,
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
          title: Style.textTitulo(mensaje: "${rxPersonalLista[index]["vehiculo_nombre"]}, ${rxPersonalLista[index]["vehiculo_anho_modelo"]}"),	
          subtitle: Style.textSubTitulo(mensaje:"Marca: ${rxPersonalLista[index]["vehiculo_marca"]}, Tipo: ${rxPersonalLista[index]["tipo_vehiculo_nombre"]}"),
        );
      }
    );
  }
}