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
          await Recolectorcontroler().listarRecolector(datos: datos);
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
        await Recolectorcontroler().listarRecolector(datos: parametros);
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
          title: Style.estiloCard(
            colorBorde: Colors.transparent,
            elevation: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(rxPersonalLista[index]["vehiculo_foto"],
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
                
            
                const SizedBox(width: 10),
            
                // 📌 Información del Vehículo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoTextRecolector("Nombre : ", rxPersonalLista[index]["vehiculo_nombre"]),
                      Divider(),
                      // const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          infoTextRecolector("Serie: ", rxPersonalLista[index]["vehiculo_serie"]),
                          infoTextRecolector("Color: ", rxPersonalLista[index]["vehiculo_color_uno"])                          
                        ],
                      ),                                               
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           infoTextRecolector("Marca: ", rxPersonalLista[index]["vehiculo_marca"]),
                          infoTextRecolector("Modelo: ", rxPersonalLista[index]["vehiculo_anho_modelo"]),                          
                        ],
                      )
                      
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () async => Recolectorcontroler().showbuttonshetOpcionesRecolector(), 
                  icon: Style.estiloIcon(icon: Icons.more_vert_rounded)
                )
                // 📌 Ícono de Estado
                // Icon(Icons.check, color: Colors.green, size: 20),
              ],
            ),
          ),
          onTap: () async => await Get.toNamed("/detaellerecolector", arguments: rxPersonalLista[index]),
        );
      }
    );
  }

  // Widget para formatear los textos
  Widget infoTextRecolector(String label, String value, {bool bold = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: 14, color: Theme.of(Get.context!).bottomNavigationBarTheme.unselectedItemColor),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: Theme.of(Get.context!).colorScheme.onBackground
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRowDetalleRecolector(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start, // 📌 Asegura alineación correcta
      children: [
        Expanded( // 📌 Deja que el label tome el espacio necesario
          flex: 3,
          child: Style.textSubTitulo(
            mensaje: label,
            // softWrap: true,
            // textOverflow: TextOverflow.visible, // 📌 Evita que se corten con "..."
          ),
        ),
        const SizedBox(width: 5),
        Expanded( // 📌 Permite que el valor ocupe el resto del espacio sin cortarse
          flex: 3,
          child: Style.textTitulo(
            mensaje: value,
            fontSize: 12,
            // softWrap: true,
            // textOverflow: TextOverflow.visible, // 📌 Evita que se corten con "..."
          ),
        ),
      ],
    );
  }

}