import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../config/library/import.dart';

class Personalwidjet {
  final UServidor tservidor = Get.find<UServidor>();
  final UPersonal tpersonal = Get.find<UPersonal>();

  Widget bodyPersonal({required Map<String, dynamic> datos}){
    return Obx((){
      if(tservidor.cargaprogreso.value){
        tpersonal.widgetPersonal.value = !tpersonal.pantallaCargadaPersonal.value ? Style.shimmerListViewProgress(context: Get.context!, leading: true, trailing:  true) : tpersonal.widgetPersonal.value;
      } else if(tservidor.tipoError.value == 3){
        tpersonal.widgetPersonal.value = Style.widgetNoConexion(mensaje: tservidor.mensajeTituloServidor.value, subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async {
          tpersonal.pantallaCargadaPersonal.value = false;
          Personalcontroller().listarPersonal(datos: datos);
        });
      } else if (tservidor.tipoError.value == 2){
        tpersonal.widgetPersonal.value = Style.widgetErrorServidor(context: Get.context!, subTitulo: tservidor.mensajesubTituloServidor.value, mensaje: tservidor.mensajeTituloServidor.value);
      } else if (tservidor.tipoError.value == 1){
        tpersonal.widgetPersonal.value = Style.widgetError(mensaje: tservidor.mensajeTituloServidor.value,subTitulo: tservidor.mensajesubTituloServidor.value, btnReintentar: () async => {});
      } else if (tpersonal.listaPersonal.isEmpty) {
        tpersonal.widgetPersonal.value = Style.widgetSinRegistro(titulo: "No Hay Registro", mensaje: "Aqui se visualizaran los registros del personal", btnReintentar: () async {
          tpersonal.pantallaCargadaPersonal.value = false;
          await Personalcontroller().listarPersonal(datos: datos);
        });
      }else{
        tpersonal.widgetPersonal.value = smartRefreshPersonal(seleccionado: tservidor.seleccionado.value, listpersonal: tpersonal.listaPersonal, parametros: datos);
      }
      return tpersonal.widgetPersonal.value;
    });
  }

  Widget smartRefreshPersonal({required bool seleccionado, required dynamic listpersonal, required Map<String, dynamic> parametros}){
    return SmartRefresher(
      controller: tpersonal.refreshControllerPersonal.value,
      scrollController: tpersonal.scrollControllerPersonal.value,
      enablePullDown: !seleccionado ? true : false,
      enablePullUp: !seleccionado ? true : false,
      enableTwoLevel: !seleccionado ? true : false,
      onRefresh: () async {
        tservidor.limpiarSeleccion();
        await Future.delayed(const Duration(seconds: 1));
        tpersonal.refreshControllerPersonal.value.refreshCompleted();
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
                Style.textTitulo(mensaje: "No hay mas Personas", textAlign: TextAlign.center),
                
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
        tpersonal.refreshControllerPersonal.value.loadNoData();
      },
      child: listViewbuilderPersonal(rxPersonalLista: listpersonal, datos: parametros),
    );
  }

  Widget listViewbuilderPersonal({required dynamic rxPersonalLista, Map<String, dynamic>? datos}){
    return ListView.builder(
      controller: tpersonal.scrollControllerPersonal.value,
      itemCount: rxPersonalLista.length,
      itemBuilder: (context, index) {
        return ListTile(
          style: ListTileStyle.list,
          dense: true,
          leading: CircleAvatar(
            radius: 25,
            child: Builder(
              builder: (context) {
                List<String> palabras = rxPersonalLista[index]['personal_nombre'] == null ? [] : rxPersonalLista[index]['personal_nombre'].split(' ');
                String iniciales;
    
                if (palabras.isEmpty) {
                  iniciales = 'N';
                }
                else if (palabras.length > 1 && palabras[1].isNotEmpty) { 
                  iniciales = palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
                } else {
                  iniciales = palabras[0].substring(0, 1);
                }
    
                return Style.textTitulo(mensaje: iniciales.toUpperCase().toString());
              },
            ),
          ),
          title: Style.textTitulo(mensaje: "${rxPersonalLista[index]["personal_nombre"]}, ${rxPersonalLista[index]["personal_apellido_paterno"]} ${rxPersonalLista[index]["personal_apellido_materno"]}"),
          subtitle: Style.textSubTitulo(mensaje: rxPersonalLista[index]["personal_email"] ?? ""),
        );
      }
    );
  }
}