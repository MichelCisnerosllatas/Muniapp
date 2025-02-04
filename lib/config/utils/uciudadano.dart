import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../library/import.dart';

class Uciudadano extends GetxController {
  final formKeyRegistroCiudadano= GlobalKey<FormState>();
  MapboxMap? mapboxMappCiudadano;
  RxBool cargarMapaLocalizarCiudadano = false.obs;
  RxBool mapaCaragadaCiudadano = false.obs;
  RxList<Map<String, dynamic>> listarutasCiudadanoInicio = <Map<String, dynamic>>[].obs; // esto alimenta en el Inicio principal
  RxList<List<double>> coordenadasRutaCiudadano = <List<double>>[].obs;  // Lista para almacenar las coordenadas de la Ruta del Camion Ciudadno
  RxList<List<double>> coordenadasCasaCiudadano = <List<double>>[].obs;  // Lista para almacenar las coordenadas de su casa
  // Lista para almacenar los IDs de las anotaciones agregadas
  List<PointAnnotation> annotationIds = [];


  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtApellidoPat = TextEditingController();
  TextEditingController txtApellidoMat = TextEditingController();
  TextEditingController txtcorreo = TextEditingController();
  TextEditingController txtCelular = TextEditingController();
  TextEditingController txtusuario = TextEditingController();
  TextEditingController txtClave = TextEditingController();
  TextEditingController txtClave2 = TextEditingController();
  RxString txtSexo = RxString('');

  RxBool boolEnabletxtNombre = true.obs;
  RxBool boolpintartxtApellidoPat = false.obs;
  RxBool boolpintartxtApellidoMat = false.obs;
  RxBool boolpintartxtNombre = false.obs;
  RxBool boolpintartxtcorreo = false.obs;
  RxBool boolpintartxtCelular = false.obs;
  RxBool boolpintartxtusuario = false.obs;
  RxBool boolpintartxtClave = false.obs;
  RxBool boolpintartxtClave2 = false.obs;
  RxBool boolpintartxtSexo = false.obs;

  late FocusNode focotxtxtNombre;
  late FocusNode focotxtApellidoPat;
  late FocusNode focotxtApellidoMat;
  late FocusNode focotxtcorreo;
  late FocusNode focotxtCelular;
  late FocusNode focotxtusuario;
  late FocusNode focotxtClave;
  late FocusNode focotxtClave2;
  late FocusNode focotxtSexo;

  RxBool verClave = false.obs;
  RxBool verClave2 = false.obs;
  RxBool cargarRegistroCiudadano = false.obs;
  RxString mapaEstiloCiudadano = MapboxStyles.MAPBOX_STREETS.obs;


  //Esto se usa en el Registro y en el Incio del Ciudadano
  RxList<Map<String, dynamic>> listarutasCiudadano = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> listarutasCiudadanoDropdowsbutton = RxList<Map<String, dynamic>>([]);  
  RxString idRutaCiudadanoSeleccionadaValue = ''.obs;

  RxList<Map<String, dynamic>> listaGuardadasderutasCiudadanoDropdowsbutton = RxList<Map<String, dynamic>>([]);
  RxString idRutaGuardadaCiudadanoSeleccionadaValue = ''.obs;

  // RxList<int> idrutaCasaGuardada = RxList<int>([]);
  // RxList<Map<String, List<double>>> coordenadaCasaGuardada = RxList<Map<String, List<double>>>([]);
  RxList<List<double>> coordenadaCasaGuardadalista = <List<double>>[].obs;
  RxList<Map<String, List<List<double>>>> coordenadaCasaGuardadaMap = <Map<String, List<List<double>>>>[].obs;
  RxBool saberDropDowButtonSeleccionado = false.obs;
}